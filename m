Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab3GHQfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 12:35:51 -0400
Received: from mtv-iport-4.cisco.com ([173.36.130.15]:18962 "EHLO
	mtv-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab3GHQfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 12:35:50 -0400
X-Greylist: delayed 578 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Jul 2013 12:35:49 EDT
X-IronPort-AV: E=Sophos;i="4.87,1021,1363132800"; 
   d="scan'208";a="85463518"
Message-ID: <51DAE823.4030406@cisco.com>
Date: Mon, 08 Jul 2013 09:26:11 -0700
From: Nishank Trivedi <nistrive@cisco.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Neel Patel <neepatel@cisco.com>, Christian Benvenuti <benve@cisco.com>
Subject: Re: [PATCH] drivers/net: enic: release rtnl_lock on error-path
References: <20130708072251.20540.50413.stgit@zurg>
In-Reply-To: <20130708072251.20540.50413.stgit@zurg>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/8/13 12:22 AM, Konstantin Khlebnikov wrote:
> enic_change_mtu_work() must call rtnl_unlock() on all exiting paths.
>
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Cc: Christian Benvenuti <benve@cisco.com>
> Cc: Roopa Prabhu <roprabhu@cisco.com>
> Cc: Neel Patel <neepatel@cisco.com>
> Cc: Nishank Trivedi <nistrive@cisco.com>
> ---
>   drivers/net/ethernet/cisco/enic/enic_main.c |    2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
> index 635f559..992ec2e 100644
> --- a/drivers/net/ethernet/cisco/enic/enic_main.c
> +++ b/drivers/net/ethernet/cisco/enic/enic_main.c
> @@ -1761,6 +1761,7 @@ static void enic_change_mtu_work(struct work_struct *work)
>   	enic_synchronize_irqs(enic);
>   	err = vnic_rq_disable(&enic->rq[0]);
>   	if (err) {
> +		rtnl_unlock();
>   		netdev_err(netdev, "Unable to disable RQ.\n");
>   		return;
>   	}
> @@ -1773,6 +1774,7 @@ static void enic_change_mtu_work(struct work_struct *work)
>   	vnic_rq_fill(&enic->rq[0], enic_rq_alloc_buf);
>   	/* Need at least one buffer on ring to get going */
>   	if (vnic_rq_desc_used(&enic->rq[0]) == 0) {
> +		rtnl_unlock();
>   		netdev_err(netdev, "Unable to alloc receive buffers.\n");
>   		return;
>   	}
>

Acked.

Thanks.
