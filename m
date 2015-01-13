Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbbAMQBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:01:46 -0500
Received: from smtprelay0209.hostedemail.com ([216.40.44.209]:56769 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751658AbbAMQBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:01:45 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3873:4250:4321:5007:6261:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12438:12517:12519:12740:13069:13311:13357:14096:14097:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rock18_833f630858a49
X-Filterd-Recvd-Size: 2016
Message-ID: <1421164899.9233.21.camel@perches.com>
Subject: Re: [PATCH] staging: ft1000: fix else style error
From: Joe Perches <joe@perches.com>
To: Bilel DRIRA <bilel.dr@gmail.com>
Cc: marek.belisko@gmail.com, gregkh@linuxfoundation.org,
        tapaswenipathak@gmail.com, gdonald@gmail.com, aybuke.147@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Tue, 13 Jan 2015 08:01:39 -0800
In-Reply-To: <1421150221-16028-1-git-send-email-bilel.dr@gmail.com>
References: <ft1000else_style>
	 <1421150221-16028-1-git-send-email-bilel.dr@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-13 at 12:57 +0100, Bilel DRIRA wrote:
> 	ERROR: else should follow close brace '}'
[]
> diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
[]
> @@ -572,8 +572,7 @@ static void ft1000_hbchk(u_long data)
>  		if (tempword != ho) {
>  			if (info->AsicID == ELECTRABUZZ_ID) {
>  				tempword = ft1000_read_dpram(dev, FT1000_HI_HO);
> -			}
> -			else {
> +			} else {
>  				tempword = ntohs(ft1000_read_dpram_mag_16(dev, FT1000_MAG_HI_HO, FT1000_MAG_HI_HO_INDX));
>  			}
>  		}

True, but you could instead remove all the braces
around both arms from all uses of

	if (test) {
		<single statement>;
	} else {
		<single statement>;
	}

> @@ -688,15 +687,13 @@ static void ft1000_hbchk(u_long data)
>  		if (tempword != hi) {
>  			if (info->AsicID == ELECTRABUZZ_ID) {
>  				ft1000_write_dpram(dev, FT1000_HI_HO, hi);
> -			}
> -			else {
> +			} else {
>  				ft1000_write_dpram_mag_16(dev, FT1000_MAG_HI_HO, hi_mag, FT1000_MAG_HI_HO_INDX);
>  			}

etc...


