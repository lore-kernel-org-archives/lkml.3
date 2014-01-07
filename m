Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbaAGHPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 02:15:12 -0500
Received: from smtprelay0174.hostedemail.com ([216.40.44.174]:56968 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753283AbaAGHPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 02:15:09 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:960:966:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2196:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3866:3867:3868:3871:3872:4321:4385:5007:6117:7652:10004:10400:10848:11232:11658:11914:12296:12517:12519:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: vest36_7edc0e68eeb33
X-Filterd-Recvd-Size: 1406
Message-ID: <1389078870.32137.5.camel@joe-AO722>
Subject: Re: [PATCH] pwm: core: Use devm_kzalloc instead of kzalloc
From: Joe Perches <joe@perches.com>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: thierry.reding@gmail.com, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 06 Jan 2014 23:14:30 -0800
In-Reply-To: <1389074700-1825-1-git-send-email-Li.Xiubo@freescale.com>
References: <1389074700-1825-1-git-send-email-Li.Xiubo@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-07 at 14:05 +0800, Xiubo Li wrote:
> Use devm_kzalloc instead of kzalloc to free automatically and make
> the cleanup paths simpler and the code slightly shorter.
[]
> diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
[]
> @@ -245,7 +244,9 @@ int pwmchip_add(struct pwm_chip *chip)
>  	if (ret < 0)
>  		goto out;
>  
> -	chip->pwms = kzalloc(chip->npwm * sizeof(*pwm), GFP_KERNEL);
> +	chip->pwms = devm_kzalloc(chip->dev,
> +				  chip->npwm * sizeof(*pwm),
> +				  GFP_KERNEL);

There is a devm_kcalloc and this should likely use it.


