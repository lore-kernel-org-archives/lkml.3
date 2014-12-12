Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934756AbaLLJbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 04:31:18 -0500
Received: from smtprelay0209.hostedemail.com ([216.40.44.209]:42647 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934091AbaLLJbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 04:31:17 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2896:2899:3138:3139:3140:3141:3142:3352:3622:3865:4321:5007:6119:6261:6742:10004:10400:10848:11026:11232:11658:11914:12043:12296:12438:12517:12519:12740:13069:13095:13141:13230:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: unit14_6208ce1f73052
X-Filterd-Recvd-Size: 2400
Message-ID: <1418376671.18092.40.camel@perches.com>
Subject: Re: [PATCH v2 1/6] ASoC: dwc: Remove unnecessary debug messages and
 tests
From: Joe Perches <joe@perches.com>
To: Andrew Jackson <andrew.jackson@arm.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Date: Fri, 12 Dec 2014 01:31:11 -0800
In-Reply-To: <97f65b6037b9ac676f6ca7717a230a68cbe81fd1.1418372910.git.Andrew.Jackson@arm.com>
References: <cover.1418372910.git.Andrew.Jackson@arm.com>
	 <97f65b6037b9ac676f6ca7717a230a68cbe81fd1.1418372910.git.Andrew.Jackson@arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-12-12 at 09:25 +0000, Andrew Jackson wrote:
> The devm_XXX allocation functions print a message on failure,
> so additional messages are not required.
[]
> diff --git a/sound/soc/dwc/designware_i2s.c b/sound/soc/dwc/designware_i2s.c
[]
> @@ -345,26 +345,17 @@ static int dw_i2s_probe(struct platform_device *pdev)
>  	}
>  
>  	dw_i2s_dai = devm_kzalloc(&pdev->dev, sizeof(*dw_i2s_dai), GFP_KERNEL);
> -	if (!dw_i2s_dai) {
> -		dev_err(&pdev->dev, "mem allocation failed for dai driver\n");
> +	if (!dw_i2s_dai)
>  		return -ENOMEM;
> -	}

ok.
 
>  	dw_i2s_dai->ops = &dw_i2s_dai_ops;
>  	dw_i2s_dai->suspend = dw_i2s_suspend;
>  	dw_i2s_dai->resume = dw_i2s_resume;
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res) {
> -		dev_err(&pdev->dev, "no i2s resource defined\n");
> -		return -ENODEV;
> -	}
> -

Why delete this?

>  	dev->i2s_base = devm_ioremap_resource(&pdev->dev, res);
> -	if (IS_ERR(dev->i2s_base)) {
> -		dev_err(&pdev->dev, "ioremap fail for i2s_region\n");
> +	if (IS_ERR(dev->i2s_base))
>  		return PTR_ERR(dev->i2s_base);
> -	}

or this?


