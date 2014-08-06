Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbaHFDKD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 23:10:03 -0400
Received: from smtprelay0095.hostedemail.com ([216.40.44.95]:60953 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751085AbaHFDKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 23:10:02 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:968:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1515:1516:1518:1534:1541:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2689:2828:3138:3139:3140:3141:3142:3351:3622:3866:3867:3868:3870:4321:5007:7652:10004:10400:10450:10455:10848:11026:11658:11914:12043:12296:12517:12519:12740:13069:13311:13357:19904:19999:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: care06_5739be6a03133
X-Filterd-Recvd-Size: 1955
Message-ID: <1407294597.31231.2.camel@joe-AO725>
Subject: Re: [PATCH] i2c: i2c-imx: Fix format warning for dev_dbg
From: Joe Perches <joe@perches.com>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: wsa@the-dreams.de, linux-i2c@vger.kernel.org, s.hauer@pengutronix.de,
        jg1.han@samsung.com, u.kleine-koenig@pengutronix.de,
        linux-kernel@vger.kernel.org, b35083@freescale.com
Date: Tue, 05 Aug 2014 20:09:57 -0700
In-Reply-To: <1407293685-7003-1-git-send-email-Li.Xiubo@freescale.com>
References: <1407293685-7003-1-git-send-email-Li.Xiubo@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-08-06 at 10:54 +0800, Xiubo Li wrote:
> drivers/i2c/busses/i2c-imx.c: In function i2c_imx_probe()
> drivers/i2c/busses/i2c-imx.c:689:2: warning: format 0x%x expects argument
> of type unsigned int, but argument 4 has type resource_size_t [-Wformat=]
>   dev_dbg(&i2c_imx->adapter.dev, "device resources from 0x%x to 0x%x\n",
[]
> diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
[]
> @@ -687,9 +687,9 @@ static int i2c_imx_probe(struct platform_device *pdev)
>  
>  	dev_dbg(&i2c_imx->adapter.dev, "claimed irq %d\n", irq);
>  	dev_dbg(&i2c_imx->adapter.dev, "device resources from 0x%x to 0x%x\n",
> -		res->start, res->end);
> +		(unsigned int)res->start, (unsigned int)res->end);

Probably better to use:

	dev_dbg(&i2c_imx->adapter.dev, "device resources: %pR\n, res);

>  	dev_dbg(&i2c_imx->adapter.dev, "allocated %d bytes at 0x%x\n",
> -		resource_size(res), res->start);
> +		(unsigned int)resource_size(res), (unsigned int)res->start);

and remove this.


