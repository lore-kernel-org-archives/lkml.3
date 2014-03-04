Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbaCDDY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 22:24:59 -0500
Received: from smtprelay0206.hostedemail.com ([216.40.44.206]:54620 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756049AbaCDDY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 22:24:58 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3867:4321:4605:5007:7652:7807:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12517:12519:12740:13101:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: ducks53_482d411b4165c
X-Filterd-Recvd-Size: 3044
Message-ID: <1393903494.20435.13.camel@joe-AO722>
Subject: Re: [PATCH 3/7] staging: cxt1e1: Fix line length over 80 characters
 in linux.c
From: Joe Perches <joe@perches.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: gregkh@linuxfoundation.org, sachin.kamat@linaro.org, shaun@xresource.ca,
        dulshani.gunawardhana89@gmail.com, ying.xue@windriver.com,
        davem@davemloft.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Mon, 03 Mar 2014 19:24:54 -0800
In-Reply-To: <2825545.2YpN0JuVSn@daeseok-laptop.cloud.net>
References: <2825545.2YpN0JuVSn@daeseok-laptop.cloud.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-04 at 11:08 +0900, Daeseok Youn wrote:
> clean up checkpatch.pl warnings:
>  WARNING: Line length over 80 characters

Please run your patches through checkpatch.

> diff --git a/drivers/staging/cxt1e1/linux.c b/drivers/staging/cxt1e1/linux.c

> @@ -431,13 +432,15 @@ create_chan(struct net_device *ndev, ci_t *ci,
>  		priv = OS_kmalloc(sizeof(struct c4_priv));
>  		if (!priv)
>  		{
> -			pr_warning("%s: no memory for net_device !\n", ci->devname);
> +			pr_warning("%s: no memory for net_device !\n",
> +				   ci->devname);

pr_warn would be nice

> @@ -458,10 +461,12 @@ create_chan(struct net_device *ndev, ci_t *ci,
>  		switch (hi->promfmt)
>  		{
>  		case PROM_FORMAT_TYPE1:
> -			memcpy(dev->dev_addr, (FLD_TYPE1 *) (hi->mfg_info.pft1.Serial), 6);
> +			memcpy(dev->dev_addr,
> +			       (FLD_TYPE1 *) (hi->mfg_info.pft1.Serial), 6);

Likely better to remove the (FLD_TYPE1 *) altogether.

>  			break;
>  		case PROM_FORMAT_TYPE2:
> -			memcpy(dev->dev_addr, (FLD_TYPE2 *) (hi->mfg_info.pft2.Serial), 6);
> +			memcpy(dev->dev_addr,
> +			       (FLD_TYPE2 *) (hi->mfg_info.pft2.Serial), 6);

Likely better to remove the (FLD_TYPE2 *) too.
Maybe consolidate the blocks too.


> @@ -1053,13 +1065,15 @@ c4_add_dev(hdw_info_t *hi, int brdno, unsigned long f0, unsigned long f1,
>  		switch (hi->promfmt)
>  		{
>  		case PROM_FORMAT_TYPE1:
> -			memcpy(ndev->dev_addr, (FLD_TYPE1 *) (hi->mfg_info.pft1.Serial), 6);
> +			memcpy(ndev->dev_addr,
> +			       (FLD_TYPE1 *) (hi->mfg_info.pft1.Serial), 6);

unnecessary casts?

>  			/* unaligned data acquisition */
>  			memcpy(&tmp, (FLD_TYPE1 *) (hi->mfg_info.pft1.Id), 4);

here too.

>  			ci->brd_id = cpu_to_be32(tmp);
>  			break;
>  		case PROM_FORMAT_TYPE2:
> -			memcpy(ndev->dev_addr, (FLD_TYPE2 *) (hi->mfg_info.pft2.Serial), 6);
> +			memcpy(ndev->dev_addr,
> +			       (FLD_TYPE2 *) (hi->mfg_info.pft2.Serial), 6);
>  			/* unaligned data acquisition */
>  			memcpy(&tmp, (FLD_TYPE2 *) (hi->mfg_info.pft2.Id), 4);

etc.


