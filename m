Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503Ab3AOTG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 14:06:58 -0500
Received: from mga01.intel.com ([192.55.52.88]:64245 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755924Ab3AOTG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 14:06:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,475,1355126400"; 
   d="scan'208";a="277245807"
From: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
To: Cong Ding <dinggnu@gmail.com>
CC: Pablo Neira Ayuso <pablo@netfilter.org>, Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "netfilter@vger.kernel.org" <netfilter@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: netfilter/xt_CT.c: fix uninitialized variable
Thread-Topic: [PATCH] net: netfilter/xt_CT.c: fix uninitialized variable
Thread-Index: AQHN81LJ4ATuVKqWGki0nByDpOY8OJhLRlMA
Date: Tue, 15 Jan 2013 19:06:51 +0000
Message-ID: <1358276792.1991.121.camel@ppwaskie-mobl2>
References: <1358276314-9536-1-git-send-email-dinggnu@gmail.com>
In-Reply-To: <1358276314-9536-1-git-send-email-dinggnu@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.15.25]
Content-Type: text/plain; charset="utf-8"
Content-ID: <54B6BD695D25314E926B20A4E27867BC@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0FJ6x4B011691

On Tue, 2013-01-15 at 19:58 +0100, Cong Ding wrote:
> If CONFIG_NF_CONNTRACK_ZONES is not defined, the variable ret might be
> uninitialized when it goes to err1 through line 125 and 263 respectively.
> So I change these goto err1 to return -EINVAL directly.
> 
> Signed-off-by: Cong Ding <dinggnu@gmail.com>
> ---
>  net/netfilter/xt_CT.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
> index 2a08430..941f600 100644
> --- a/net/netfilter/xt_CT.c
> +++ b/net/netfilter/xt_CT.c
> @@ -122,7 +122,7 @@ static int xt_ct_tg_check_v0(const struct xt_tgchk_param *par)
>  
>  #ifndef CONFIG_NF_CONNTRACK_ZONES
>  	if (info->zone)
> -		goto err1;
> +		return -EINVAL;
>  #endif
>  
>  	ret = nf_ct_l3proto_try_module_get(par->family);
> @@ -260,7 +260,7 @@ static int xt_ct_tg_check_v1(const struct xt_tgchk_param *par)
>  
>  #ifndef CONFIG_NF_CONNTRACK_ZONES
>  	if (info->zone)
> -		goto err1;
> +		return -EINVAL;
>  #endif

In dropping both goto's, you left the err1 label unused.  Wouldn't just
initializing ret to -EINVAL be easier and cleaner?  Then you wouldn't be
messing with the flow of the function.

-PJ
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
