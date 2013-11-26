Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973Ab3KZTOJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 14:14:09 -0500
Received: from smtprelay0253.hostedemail.com ([216.40.44.253]:55115 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753650Ab3KZTOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 14:14:06 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2689:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:4321:5007:7652:10004:10400:10848:11026:11232:11658:11914:12043:12296:12517:12519:12555:12740:13069:13311:13357:13870:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: frame45_2372cc92e7d62
X-Filterd-Recvd-Size: 1857
Message-ID: <1385493242.20100.71.camel@joe-AO722>
Subject: Re: [PATCH] gpio: pl061: print resource_size_t as %pa
From: Joe Perches <joe@perches.com>
To: Olof Johansson <olof@lixom.net>
Cc: linus.walleij@linaro.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 26 Nov 2013 11:14:02 -0800
In-Reply-To: <1385492161-27624-1-git-send-email-olof@lixom.net>
References: <1385492161-27624-1-git-send-email-olof@lixom.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-26 at 10:56 -0800, Olof Johansson wrote:
> commit 73675c8aa07 ('gpio: pl061: proper error messages') added a printout
> of a resource_size_t using %x, which produces an error for builds with
> 64-bit resources:

What tree is this?

> drivers/gpio/gpio-pl061.c:345:3: warning: format '%x' expects argument of
>     type 'unsigned int', but argument 3 has type 'resource_size_t'
> 
> Switch to %pa (and pass in a pointer to the resource instead).
> 
> Fixes: 73675c8aa07 ('gpio: pl061: proper error messages')
[]
> diff --git a/drivers/gpio/gpio-pl061.c b/drivers/gpio/gpio-pl061.c
[]
> @@ -341,8 +341,8 @@ static int pl061_probe(struct amba_device *adev, const struct amba_id *id)
>  	}
>  
>  	amba_set_drvdata(adev, chip);
> -	dev_err(&adev->dev, "PL061 GPIO chip @%08x registered\n",
> -		adev->res.start);
> +	dev_err(&adev->dev, "PL061 GPIO chip @%pa registered\n",
> +		&adev->res.start);

This looks as if this should not use dev_err, but maybe dev_info
and maybe it should use %pR, &adev->res


