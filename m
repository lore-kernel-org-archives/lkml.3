Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab3DPGyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 02:54:43 -0400
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:19141
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752936Ab3DPGym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 02:54:42 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zzc89bh542I1432I4015Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839h8e2h8e3h941hd25hf0ah1269h1288h12a5h12a9h12bdh12e1h137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ahbe9i1155h)
From: Tang Yuantian-B29983 <B29983@freescale.com>
To: Tang Yuantian-B29983 <B29983@freescale.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
CC: "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: RE: [PATCH v2] of/base: release the node correctly in
 of_parse_phandle_with_args()
Thread-Topic: [PATCH v2] of/base: release the node correctly in
 of_parse_phandle_with_args()
Thread-Index: AQHONaImIE34onvqCEuo3S6bpDZbgJjYcqPA
Date: Tue, 16 Apr 2013 06:54:40 +0000
Message-ID: <D07C73A334FF604B95B3CBD2A545D07B0B144FD3@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1365564999-24427-1-git-send-email-Yuantian.Tang@freescale.com>
In-Reply-To: <1365564999-24427-1-git-send-email-Yuantian.Tang@freescale.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.128]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3G6slrD000913

Hi Grant.likely,

I really preciate if you can spend some times to review this patch.

Thanks,
Yuantian

> -----Original Message-----
> From: Tang Yuantian-B29983
> Sent: 2013Äê4ÔÂ10ÈÕ 11:37
> To: grant.likely@secretlab.ca
> Cc: rob.herring@calxeda.com; devicetree-discuss@lists.ozlabs.org; linux-
> kernel@vger.kernel.org; linuxppc-dev@lists.ozlabs.org; Tang Yuantian-
> B29983; Tang Yuantian-B29983
> Subject: [PATCH v2] of/base: release the node correctly in
> of_parse_phandle_with_args()
> 
> From: Tang Yuantian <yuantian.tang@freescale.com>
> 
> Call of_node_put() only when the out_args is NULL on success, or the
> node's reference count will not be correct because the caller will call
> of_node_put() again.
> 
> Signed-off-by: Tang Yuantian <Yuantian.Tang@freescale.com>
> ---
> v2:
> 	- modified the title and description. the 1st patch title is:
> 	  of: remove the unnecessary of_node_put for
> of_parse_phandle_with_args()
> 	  the 1st patch is not good enough.
> 
>  drivers/of/base.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c index 321d3ef..ee94f64
> 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -1158,6 +1158,7 @@ static int __of_parse_phandle_with_args(const
> struct device_node *np,
>  			if (!phandle)
>  				goto err;
> 
> +			/* Found it! return success */
>  			if (out_args) {
>  				int i;
>  				if (WARN_ON(count > MAX_PHANDLE_ARGS)) @@ -
> 1166,11 +1167,10 @@ static int __of_parse_phandle_with_args(const struct
> device_node *np,
>  				out_args->args_count = count;
>  				for (i = 0; i < count; i++)
>  					out_args->args[i] = be32_to_cpup(list++);
> +			} else if (node) {
> +				of_node_put(node);
>  			}
> 
> -			/* Found it! return success */
> -			if (node)
> -				of_node_put(node);
>  			return 0;
>  		}
> 
> --
> 1.8.0

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
