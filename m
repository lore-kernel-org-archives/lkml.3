Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780AbaBLHq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 02:46:26 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:38036 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaBLHqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 02:46:24 -0500
From: Peter Korsgaard <peter@korsgaard.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Herbert Xu'" <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
        "'Nicolas Ferre'" <nicolas.ferre@atmel.com>,
        "'Peter Korsgaard'" <jacmet@sunsite.dk>
Subject: Re: [PATCH 1/2] hwrng: atmel - Use devm_ioremap_resource()
References: <000001cf27b1$acf29f30$06d7dd90$%han@samsung.com>
Date: Wed, 12 Feb 2014 08:46:20 +0100
In-Reply-To: <000001cf27b1$acf29f30$06d7dd90$%han@samsung.com> (Jingoo Han's
	message of "Wed, 12 Feb 2014 14:17:08 +0900")
Message-ID: <87vbwku62b.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jingoo" == Jingoo Han <jg1.han@samsung.com> writes:

 > Use devm_ioremap_resource() in order to make the code simpler,
 > and remove redundant return value check of platform_get_resource()
 > because the value is checked by devm_ioremap_resource().

 > Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Peter Korsgaard <jacmet@sunsite.dk>



 > ---
 >  drivers/char/hw_random/atmel-rng.c |   15 ++++-----------
 >  1 file changed, 4 insertions(+), 11 deletions(-)

 > diff --git a/drivers/char/hw_random/atmel-rng.c b/drivers/char/hw_random/atmel-rng.c
 > index bf9fc6b..dfeddf2 100644
 > --- a/drivers/char/hw_random/atmel-rng.c
 > +++ b/drivers/char/hw_random/atmel-rng.c
 > @@ -54,21 +54,14 @@ static int atmel_trng_probe(struct platform_device *pdev)
 >  	struct resource *res;
 >  	int ret;
 
 > -	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 > -	if (!res)
 > -		return -EINVAL;
 > -
 >  	trng = devm_kzalloc(&pdev->dev, sizeof(*trng), GFP_KERNEL);
 >  	if (!trng)
 >  		return -ENOMEM;
 
 > -	if (!devm_request_mem_region(&pdev->dev, res->start,
 > -				     resource_size(res), pdev->name))
 > -		return -EBUSY;
 > -
 > -	trng->base = devm_ioremap(&pdev->dev, res->start, resource_size(res));
 > -	if (!trng->base)
 > -		return -EBUSY;
 > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 > +	trng->base = devm_ioremap_resource(&pdev->dev, res);
 > +	if (IS_ERR(trng->base))
 > +		return PTR_ERR(trng->base);
 
 trng-> clk = clk_get(&pdev->dev, NULL);
 >  	if (IS_ERR(trng->clk))
 > -- 
 > 1.7.10.4




-- 
Bye, Peter Korsgaard
