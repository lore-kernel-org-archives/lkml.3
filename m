Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326Ab3GHQgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 12:36:37 -0400
Received: from rcdn-iport-4.cisco.com ([173.37.86.75]:35242 "EHLO
	rcdn-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab3GHQgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 12:36:35 -0400
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Jul 2013 12:36:35 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgkFALPn2lGtJV2a/2dsb2JhbABagwl/gwi9XBd7FnSCIwEBAQQjBA1FDAQCAQgRBAEBAQICBiACAgIwFQgIAgQBDQUIiAYBp2uRFYEmjhQWGwcGgk4zaQOhc4cogxGCKA
X-IronPort-AV: E=Sophos;i="4.87,1021,1363132800"; 
   d="scan'208";a="232261840"
From: "Neel Patel (neepatel)" <neepatel@cisco.com>
To: "Nishank Trivedi (nistrive)" <nistrive@cisco.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christian Benvenuti (benve)" <benve@cisco.com>
Subject: RE: [PATCH] drivers/net: enic: release rtnl_lock on error-path
Thread-Topic: [PATCH] drivers/net: enic: release rtnl_lock on error-path
Thread-Index: AQHOe6v/r7tslmN0WUy0e1cJ9qWDb5lbTDCA//+sPgA=
Date: Mon, 8 Jul 2013 16:26:58 +0000
Message-ID: <644DFB2E795E0348A1614A34EE0D35711837FDB1@xmb-rcd-x05.cisco.com>
References: <20130708072251.20540.50413.stgit@zurg>
 <51DAE823.4030406@cisco.com>
In-Reply-To: <51DAE823.4030406@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [171.71.13.213]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r68Gah0h005933

Looks good.

Thanks!

-----Original Message-----
From: Nishank Trivedi (nistrive) 
Sent: Monday, July 08, 2013 9:26 AM
To: Konstantin Khlebnikov
Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Neel Patel (neepatel); Christian Benvenuti (benve)
Subject: Re: [PATCH] drivers/net: enic: release rtnl_lock on error-path

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
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
