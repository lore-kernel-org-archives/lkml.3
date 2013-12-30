Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781Ab3L3IVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 03:21:52 -0500
Received: from bgl-iport-3.cisco.com ([72.163.197.27]:27732 "EHLO
	bgl-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab3L3IVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 03:21:50 -0500
X-Greylist: delayed 610 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Dec 2013 03:21:49 EST
X-IronPort-AV: E=Sophos;i="4.95,572,1384300800"; 
   d="scan'208";a="3065859"
Date: Mon, 30 Dec 2013 13:42:18 +0530 (IST)
From: Govindarajulu Varadarajan <gvaradar@cisco.com>
X-X-Sender: hydrogen@as-rtp-infra-nw.cisco.com
To: Ding Tianhong <dingtianhong@huawei.com>
cc: Christian Benvenuti <benve@cisco.com>, Sujith Sankar <ssujith@cisco.com>,
        Govindarajulu Varadarajan <govindarajulu90@gmail.com>,
        Neel Patel <neepatel@cisco.com>, Nishank Trivedi <nistrive@cisco.com>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3 04/19] net: enic: slight optimization of addr
 compare
In-Reply-To: <52C12378.7030801@huawei.com>
Message-ID: <alpine.LNX.2.03.1312301341050.2286@cisco.com>
References: <52C12378.7030801@huawei.com>
User-Agent: Alpine 2.03 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Authenticated-User: gvaradar@cisco.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Dec 2013, Ding Tianhong wrote:

> Use possibly more efficient ether_addr_equal
> to instead of memcmp.
>
> Cc: Christian Benvenuti <benve@cisco.com>
> Cc: Sujith Sankar <ssujith@cisco.com>
> Cc: Govindarajulu Varadarajan <govindarajulu90@gmail.com>
> Cc: Neel Patel <neepatel@cisco.com>
> Cc: Nishank Trivedi <nistrive@cisco.com>
> Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
> ---
> drivers/net/ethernet/cisco/enic/enic_pp.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/cisco/enic/enic_pp.c b/drivers/net/ethernet/cisco/enic/enic_pp.c
> index 43464f0..e6a8319 100644
> --- a/drivers/net/ethernet/cisco/enic/enic_pp.c
> +++ b/drivers/net/ethernet/cisco/enic/enic_pp.c
> @@ -162,7 +162,7 @@ static int enic_are_pp_different(struct enic_port_profile *pp1,
> 	return strcmp(pp1->name, pp2->name) | !!memcmp(pp1->instance_uuid,
> 		pp2->instance_uuid, PORT_UUID_MAX) |
> 		!!memcmp(pp1->host_uuid, pp2->host_uuid, PORT_UUID_MAX) |
> -		!!memcmp(pp1->mac_addr, pp2->mac_addr, ETH_ALEN);
> +		!ether_addr_equal(pp1->mac_addr, pp2->mac_addr);
> }
>
> static int enic_pp_preassociate(struct enic *enic, int vf,
> -- 
> 1.8.0
>

looks good for me

Acked-by: Govindarajulu Varadarajan <govindarajulu90@gmail.com>
