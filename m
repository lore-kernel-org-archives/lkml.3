Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbaA2ESt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 23:18:49 -0500
Received: from smtprelay0092.hostedemail.com ([216.40.44.92]:44945 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751112AbaA2ESs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 23:18:48 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3871:3872:3874:4321:4605:5007:6119:7652:7875:7903:8603:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: crown52_1253cf44c3d2d
X-Filterd-Recvd-Size: 1855
Message-ID: <1390969124.11756.43.camel@joe-AO722>
Subject: Re: [PATCH V3 1/2] devres: introduce API "devm_kstrdup"
From: Joe Perches <joe@perches.com>
To: Manish Badarkhe <badarkhe.manish@gmail.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        broonie@kernel.org, lgirdwood@gmail.com
Date: Tue, 28 Jan 2014 20:18:44 -0800
In-Reply-To: <1390968181-31800-2-git-send-email-badarkhe.manish@gmail.com>
References: <1390968181-31800-1-git-send-email-badarkhe.manish@gmail.com>
	 <1390968181-31800-2-git-send-email-badarkhe.manish@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-29 at 09:33 +0530, Manish Badarkhe wrote:
> This patch introduces "devm_kstrdup" API so that the
> device's driver can allocate memory and copy string.
[]
> diff --git a/drivers/base/devres.c b/drivers/base/devres.c
[]
> @@ -791,6 +791,32 @@ void * devm_kmalloc(struct device *dev, size_t size, gfp_t gfp)
>  EXPORT_SYMBOL_GPL(devm_kmalloc);
>  
>  /**
> + * devm_kstrdup - Allocate resource managed space and
> + *                and copy an existing string
> + * @dev: Device to allocate memory for
> + * @s: the string to duplicate
> + * @size: Allocation size

Why is size necessary at all?
I think it should be calculated by strlen

> +char *devm_kstrdup(struct device *dev,
> +		   const char *s, size_t size, gfp_t gfp)
> +{
> +	char *buf;
> +
> +	if (!s)
> +		return NULL;
> +
> +	buf = devm_kzalloc(dev, size, gfp);

If this is really necessary, please use devm_kmalloc


