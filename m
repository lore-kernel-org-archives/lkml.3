Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaI3QzO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 12:55:14 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:46171 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbaI3QzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 12:55:11 -0400
From: Peter Korsgaard <peter@korsgaard.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Peter Korsgaard <jacmet@sunsite.dk>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] hwrng: atmel: use clk_prepapre_enable/_disable_unprepare
References: <1412093987-30241-1-git-send-email-boris.brezillon@free-electrons.com>
	<1412093987-30241-3-git-send-email-boris.brezillon@free-electrons.com>
Date: Tue, 30 Sep 2014 18:55:05 +0200
In-Reply-To: <1412093987-30241-3-git-send-email-boris.brezillon@free-electrons.com>
	(Boris Brezillon's message of "Tue, 30 Sep 2014 18:19:43 +0200")
Message-ID: <87k34loxp2.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Boris" == Boris Brezillon <boris.brezillon@free-electrons.com> writes:

 > Use clk_prepapre_enable/_disable_unprepare instead of clk_enable/disable
 > to work properly with the CCF.

s/prepapre/prepare/

Other than that, looks fine to me.

Acked-by: Peter Korsgaard <peter@korsgaard.com>

 > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
 > ---
 >  drivers/char/hw_random/atmel-rng.c | 8 ++++----
 >  1 file changed, 4 insertions(+), 4 deletions(-)

 > diff --git a/drivers/char/hw_random/atmel-rng.c b/drivers/char/hw_random/atmel-rng.c
 > index 851bc7e..644ec48 100644
 > --- a/drivers/char/hw_random/atmel-rng.c
 > +++ b/drivers/char/hw_random/atmel-rng.c
 > @@ -67,7 +67,7 @@ static int atmel_trng_probe(struct platform_device *pdev)
 >  	if (IS_ERR(trng->clk))
 >  		return PTR_ERR(trng->clk);
 
 > -	ret = clk_enable(trng->clk);
 > +	ret = clk_prepare_enable(trng->clk);
 >  	if (ret)
 >  		return ret;
 
 > @@ -95,7 +95,7 @@ static int atmel_trng_remove(struct platform_device *pdev)
 >  	hwrng_unregister(&trng->rng);
 
 >  	writel(TRNG_KEY, trng->base + TRNG_CR);
 > -	clk_disable(trng->clk);
 > +	clk_disable_unprepare(trng->clk);
 
 >  	return 0;
 >  }
 > @@ -105,7 +105,7 @@ static int atmel_trng_suspend(struct device *dev)
 >  {
 >  	struct atmel_trng *trng = dev_get_drvdata(dev);
 
 > -	clk_disable(trng->clk);
 > +	clk_disable_unprepare(trng->clk);
 
 >  	return 0;
 >  }
 > @@ -114,7 +114,7 @@ static int atmel_trng_resume(struct device *dev)
 >  {
 >  	struct atmel_trng *trng = dev_get_drvdata(dev);
 
 > -	return clk_enable(trng->clk);
 > +	return clk_prepare_enable(trng->clk);
 >  }
 
 >  static const struct dev_pm_ops atmel_trng_pm_ops = {
 > -- 
 > 1.9.1



-- 
Bye, Peter Korsgaard
