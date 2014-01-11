Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbaAKDab (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 22:30:31 -0500
Received: from mga14.intel.com ([143.182.124.37]:7286 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbaAKDa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 22:30:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,642,1384329600"; 
   d="scan'208";a="457031241"
From: "Brown, Aaron F" <aaron.f.brown@intel.com>
To: Ding Tianhong <dingtianhong@huawei.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Wyborny, Carolyn" <carolyn.wyborny@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v2 06/20] net: igbvf: slight optimization of
 addr compare
Thread-Topic: [PATCH net-next v2 06/20] net: igbvf: slight optimization of
 addr compare
Thread-Index: AQHPA5VKU9u9ZB8fT0yA/gddQF8dq5p+81nw
Date: Sat, 11 Jan 2014 03:30:25 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B7312966C@ORSMSX101.amr.corp.intel.com>
References: <52BE6CF8.5030806@huawei.com>
In-Reply-To: <52BE6CF8.5030806@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0B3UdQ3013195

> From: netdev-owner@vger.kernel.org [mailto:netdev-owner@vger.kernel.org]
> On Behalf Of Ding Tianhong
> Sent: Friday, December 27, 2013 10:17 PM
> To: Kirsher, Jeffrey T; Brandeburg, Jesse; Wyborny, Carolyn; Skidmore,
> Donald C; David S. Miller; Netdev; linux-kernel@vger.kernel.org
> Subject: [PATCH net-next v2 06/20] net: igbvf: slight optimization of addr
> compare
> 
> Use possibly more efficient ether_addr_equal to instead of memcmp.
> 
> Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Cc: Carolyn Wyborny <carolyn.wyborny@intel.com>
> Cc: Don Skidmore <donald.c.skidmore@intel.com>
> Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>

Signed-off-by: Aaron Brown <aaron.f.brown@intel.com> 
Tested by: Aaron Brown <aaron.f.brown@intel.com>

> ---
>  drivers/net/ethernet/intel/igbvf/netdev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c
> b/drivers/net/ethernet/intel/igbvf/netdev.c
> index 04bf22e..675435f 100644
> --- a/drivers/net/ethernet/intel/igbvf/netdev.c
> +++ b/drivers/net/ethernet/intel/igbvf/netdev.c
> @@ -1745,7 +1745,7 @@ static int igbvf_set_mac(struct net_device *netdev,
> void *p)
> 
>  	hw->mac.ops.rar_set(hw, hw->mac.addr, 0);
> 
> -	if (memcmp(addr->sa_data, hw->mac.addr, 6))
> +	if (!ether_addr_equal(addr->sa_data, hw->mac.addr))
>  		return -EADDRNOTAVAIL;
> 
>  	memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
> --
> 1.8.0
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
