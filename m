Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809AbaCECR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 21:17:59 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:48958 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958AbaCECR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 21:17:58 -0500
Message-Id: <201403050217.s252HoVa004730@userz7021.oracle.com>
Date: Tue, 04 Mar 2014 21:17:46 -0500
Subject: Re: [Xen-devel] [PATCH net-next v6 8/10] xen-netback: Add stat
 counters for frag_list skbs
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
Cc: netdev@vger.kernel.org, xen-devel@lists.xenproject.org,
        wei.liu2@citrix.com, ian.campbell@citrix.com,
        jonathan.davies@citrix.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s252I6R0011275


On Mar 4, 2014 5:32 PM, Zoltan Kiss <zoltan.kiss@citrix.com> wrote:
>
> These counters help determine how often the guest sends a packet with more 
> than MAX_SKB_FRAGS frags. 
>
> NOTE: if bisect brought you here, you should apply the series up until #9,

s/#9/"the name of the patch.."

> otherwise malicious guests can block other guests by not releasing their sent 
> packets. 
>
> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com> 
> --- 
> drivers/net/xen-netback/common.hÂ Â Â  |Â Â Â  1 + 
> drivers/net/xen-netback/interface.c |Â Â Â  7 +++++++ 
> drivers/net/xen-netback/netback.cÂ Â  |Â Â Â  1 + 
> 3 files changed, 9 insertions(+) 
>
> diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h 
> index eac171e..d8a2298 100644 
> --- a/drivers/net/xen-netback/common.h 
> +++ b/drivers/net/xen-netback/common.h 
> @@ -170,6 +170,7 @@ struct xenvif { 
> unsigned long tx_zerocopy_sent; 
> unsigned long tx_zerocopy_success; 
> unsigned long tx_zerocopy_fail; 
> + unsigned long tx_frag_overflow; 
>
> /* Miscellaneous private stuff. */ 
> struct net_device *dev; 
> diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c 
> index adfed30..ba5be2f 100644 
> --- a/drivers/net/xen-netback/interface.c 
> +++ b/drivers/net/xen-netback/interface.c 
> @@ -252,6 +252,13 @@ static const struct xenvif_stat { 
> "tx_zerocopy_fail", 
> offsetof(struct xenvif, tx_zerocopy_fail) 
> }, 
> + /* Number of packets exceeding MAX_SKB_FRAG slots. You should use 
> + * a guest with the same MAX_SKB_FRAG 
> + */ 
> + { 
> + "tx_frag_overflow", 
> + offsetof(struct xenvif, tx_frag_overflow) 
> + }, 
> }; 
>
> static int xenvif_get_sset_count(struct net_device *dev, int string_set) 
>
>
> _______________________________________________ 
> Xen-devel mailing list 
> Xen-devel@lists.xen.org 
> http://lists.xen.org/xen-devel 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
