Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbbAVHlB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 02:41:01 -0500
Received: from smtprelay0024.hostedemail.com ([216.40.44.24]:39542 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750820AbbAVHk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 02:40:56 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2895:3138:3139:3140:3141:3142:3150:3352:3622:3867:3868:3872:4321:4384:5007:6261:10004:10400:10848:11026:11658:11914:12296:12438:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: guide17_42135b311973e
X-Filterd-Recvd-Size: 1928
Message-ID: <1421912452.18480.4.camel@perches.com>
Subject: Re: [RESEND PATCH v2 4/9] mfd: rtsx: update driving settings
From: Joe Perches <joe@perches.com>
To: micky_ching@realsil.com.cn
Cc: sameo@linux.intel.com, lee.jones@linaro.org, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        rogerable@realtek.com, wei_wang@realsil.com.cn
Date: Wed, 21 Jan 2015 23:40:52 -0800
In-Reply-To: <382f3e7b2285ffd06931b43d015cc8a6967a19eb.1421911636.git.micky_ching@realsil.com.cn>
References: <cover.1421911636.git.micky_ching@realsil.com.cn>
	 <382f3e7b2285ffd06931b43d015cc8a6967a19eb.1421911636.git.micky_ching@realsil.com.cn>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-22 at 15:30 +0800, micky_ching@realsil.com.cn wrote:
> update card drive settings, This setting can be used for rts5249
> rts524A and rts525A.
[]
> diff --git a/drivers/mfd/rts5249.c b/drivers/mfd/rts5249.c

> @@ -36,16 +36,16 @@ static u8 rts5249_get_ic_version(struct rtsx_pcr *pcr)
>  static void rts5249_fill_driving(struct rtsx_pcr *pcr, u8 voltage)
>  {
>  	u8 driving_3v3[4][3] = {

It'd be nice to make these arrays static const

> -		{0x11, 0x11, 0x11},
> +		{0x11, 0x11, 0x18},
>  		{0x55, 0x55, 0x5C},
> -		{0x99, 0x99, 0x92},
> -		{0x99, 0x99, 0x92},
> +		{0xFF, 0xFF, 0xFF},
> +		{0x96, 0x96, 0x96},
>  	};
>  	u8 driving_1v8[4][3] = {
> +		{0xC4, 0xC4, 0xC4},
>  		{0x3C, 0x3C, 0x3C},
> -		{0xB3, 0xB3, 0xB3},
>  		{0xFE, 0xFE, 0xFE},
> -		{0xC4, 0xC4, 0xC4},
> +		{0xB3, 0xB3, 0xB3},
>  	};
>  	u8 (*driving)[3], drive_sel;


