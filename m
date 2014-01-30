Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbaA3TE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 14:04:59 -0500
Received: from smtprelay0043.hostedemail.com ([216.40.44.43]:33144 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753145AbaA3TE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 14:04:58 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2892:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3872:3874:4250:4321:5007:7576:7652:7901:7903:10004:10400:10848:11026:11232:11658:11914:12043:12438:12517:12519:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: offer84_6551e3ad70749
X-Filterd-Recvd-Size: 1812
Message-ID: <1391108694.2422.59.camel@joe-AO722>
Subject: Re: [PATCH] pinctrl: Quiet logging about missing DT nodes when not
 using DT
From: Joe Perches <joe@perches.com>
To: Mark Brown <broonie@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Thu, 30 Jan 2014 11:04:54 -0800
In-Reply-To: <1391108240-16161-1-git-send-email-broonie@kernel.org>
References: <1391108240-16161-1-git-send-email-broonie@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-30 at 18:57 +0000, Mark Brown wrote:
> From: Mark Brown <broonie@linaro.org>
> 
> On systems which were not booted using DT it is entirely unsurprising that
> device nodes don't have any DT information and this is going to happen for
> every single device in the system. Make pinctrl be less chatty about this
> situation by only logging in the case where we have DT.

trivia:

> diff --git a/drivers/pinctrl/devicetree.c b/drivers/pinctrl/devicetree.c
[]
> @@ -186,7 +186,9 @@ int pinctrl_dt_to_map(struct pinctrl *p)
>  
>  	/* CONFIG_OF enabled, p->dev not instantiated from DT */
>  	if (!np) {
> -		dev_dbg(p->dev, "no of_node; not parsing pinctrl DT\n");
> +		if (of_have_populated_dt())
> +			dev_dbg(p->dev,
> +				"no of_node; not parsing pinctrl DT\n");

There are 80 columns.  It's OK to use them all.

			dev_dbg(p->dev, "no of_node; not parsing pinctrl DT\n");


