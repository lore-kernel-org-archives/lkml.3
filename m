Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181AbaFSP7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 11:59:34 -0400
Received: from smtprelay0191.hostedemail.com ([216.40.44.191]:56165 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757567AbaFSP7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:59:32 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:4321:5007:7652:7903:10004:10400:10848:11026:11232:11473:11658:11914:12043:12517:12519:12740:13069:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,
X-HE-Tag: cart08_52c2440dc3a59
X-Filterd-Recvd-Size: 1950
Message-ID: <1403193567.7875.4.camel@joe-AO725>
Subject: Re: [PATCH 3/4] drivers/base: devres.c: use devm_kmemdup() from
 with devm_kstrdup()
From: Joe Perches <joe@perches.com>
To: Rob Jones <rob.jones@codethink.co.uk>
Cc: linus.walleij@linaro.org, gnurou@gmail.com, lgirdwood@gmail.com,
        broonie@kernel.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kernel@codethink.co.uk,
        ian.molton@codethink.co.uk, ben.dooks@codethink.co.uk, heiko@sntech.de
Date: Thu, 19 Jun 2014 08:59:27 -0700
In-Reply-To: <1403192765-3258-4-git-send-email-rob.jones@codethink.co.uk>
References: <1403192765-3258-1-git-send-email-rob.jones@codethink.co.uk>
	 <1403192765-3258-4-git-send-email-rob.jones@codethink.co.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-19 at 16:46 +0100, Rob Jones wrote:
> Avoid code duplication by using devm_kmemdup() to copy data instead
> of having a separate loop within devm_kstrdup().
> 
> Reviewed-by: Ian Molton <ian.molton@codethink.co.uk>
> Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
[]
> diff --git a/drivers/base/devres.c b/drivers/base/devres.c
[]
> @@ -802,17 +802,10 @@ EXPORT_SYMBOL_GPL(devm_kmalloc);
>   */
>  char *devm_kstrdup(struct device *dev, const char *s, gfp_t gfp)
>  {
[]
> +	return devm_kmemdup(dev, s, (strlen(s) + 1), gfp);
>  }
>  EXPORT_SYMBOL_GPL(devm_kstrdup);

Making this static inline in the header and dropping
EXPORT_SYMBOL_GPL might be smaller code.

static inline
char *devm_kstrdup(struct device *dev, const char *s, gfp_t gfp)
{
	return devm_kmemdup(dev, s, strlen(s) + 1, gfp);
}


