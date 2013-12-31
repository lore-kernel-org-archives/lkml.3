Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab3LaNsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 08:48:24 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:57583 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab3LaNsX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 08:48:23 -0500
X-Auth-Info: NJm0fqCv3dnqj5V3kH3hsQp56k4RYLgWmslwfp0zNwU=
Date: Tue, 31 Dec 2013 14:48:20 +0100
From: Gerhard Sittig <gsi@denx.de>
To: Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Christian Hohnstaedt <chohnstaedt@innominate.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [ARM] Fix kernel compile error: drivers/crypto/ixp4xx_crypto.c.
Message-ID: <20131231134820.GS8064@book.gsilab.sittig.org>
Mail-Followup-To: Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>,
	lkml <linux-kernel@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	Christian Hohnstaedt <chohnstaedt@innominate.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
References: <m3d2kduwd7.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <m3d2kduwd7.fsf@t19.piap.pl>
Organization: DENX Software Engineering GmbH
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 31, 2013 at 11:51 +0100, Krzysztof Hałasa wrote:
> 
> drivers/crypto/ixp4xx_crypto.c: In function 'ixp_module_init':
> drivers/crypto/ixp4xx_crypto.c:1419:2: error: 'dev' undeclared (first use in this function)
> 
> Now builds. Not tested on real hw.
> 
> Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>

I understood that a 'Fixes: <hash> <subject>' line is suggested when
you can clearly identify what broke what you fix.  Is it 27c1789ca6a6
"DMA-API: crypto: remove last references to 'static struct device *dev'"?
Then v3.13-rc1 would have been affected.

> --- a/drivers/crypto/ixp4xx_crypto.c
> +++ b/drivers/crypto/ixp4xx_crypto.c
> @@ -1410,14 +1410,12 @@ static const struct platform_device_info ixp_dev_info __initdata = {
>  static int __init ixp_module_init(void)
>  {
>  	int num = ARRAY_SIZE(ixp4xx_algos);
> -	int i, err ;
> +	int i, err;
>  
>  	pdev = platform_device_register_full(&ixp_dev_info);
>  	if (IS_ERR(pdev))
>  		return PTR_ERR(pdev);
>  
> -	dev = &pdev->dev;
> -
>  	spin_lock_init(&desc_lock);
>  	spin_lock_init(&emerg_lock);


virtually yours
Gerhard Sittig
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
