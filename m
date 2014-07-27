Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbaG0RX6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 13:23:58 -0400
Received: from smtprelay0170.hostedemail.com ([216.40.44.170]:57597 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752186AbaG0RX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 13:23:57 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:960:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:7652:8603:9025:10004:10400:10848:11026:11232:11657:11658:11914:12043:12517:12519:12740:13069:13095:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pail49_7986806815d60
X-Filterd-Recvd-Size: 2159
Message-ID: <1406481833.5285.6.camel@joe-AO725>
Subject: Re: [PATCH] staging: ft1000: fix some checkpatch complaints
From: Joe Perches <joe@perches.com>
To: Nicolas Thery <nthery@gmail.com>
Cc: marek.belisko@gmail.com, gregkh@linuxfoundation.org, me@aldo.io,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Sun, 27 Jul 2014 10:23:53 -0700
In-Reply-To: <1406480913-31378-1-git-send-email-nthery@gmail.com>
References: <1406480913-31378-1-git-send-email-nthery@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-07-27 at 19:08 +0200, Nicolas Thery wrote:
> This patch fixes the following errors and warnings:
[]
> diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c
[]
> @@ -23,34 +23,38 @@
[]
> -#define seq_putx(m, message, size, var) \
> +#define seq_putx(m, message, size, var) do { \
>  	seq_printf(m, message);	\
>  	for (i = 0; i < (size - 1); i++) { \
>  		seq_printf(m, "%02x:", var[i]); \
>  	} \
> -	seq_printf(m, "%02x\n", var[i])
> +	seq_printf(m, "%02x\n", var[i]); \
> +} while (0)

Ideally, these wouldn't depend on an external
i variable.

Maybe something like:

#define seq_putx(m, message, size, var) \
do { \
	int _i; \
 	seq_printf(m, message);	\
 	for (_i = 0; _i < (size - 1); _i++) \
 		seq_printf(m, "%02x:", var[_i]); \
	seq_printf(m, "%02x\n", var[_i]); \
} while (0)
 
> -#define seq_putd(m, message, size, var) \
> +#define seq_putd(m, message, size, var) do { \
>  	seq_printf(m, message); \
>  	for (i = 0; i < (size - 1); i++) { \
>  		seq_printf(m, "%d.", var[i]); \
>  	} \
> -	seq_printf(m, "%d\n", var[i])
> +	seq_printf(m, "%d\n", var[i]); \
> +} while (0)

Maybe later change these to use the recently introduced
seq_hex_dump: https://lkml.org/lkml/2014/7/11/269


