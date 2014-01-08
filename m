Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbaAHAOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 19:14:53 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:56022 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbaAHAOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 19:14:42 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Naveen Krishna Ch <ch.naveen@samsung.com>
Cc: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/5] crypto:s5p-sss: Use platform_get_irq() instead of _byname()
Date: Wed, 08 Jan 2014 01:14:36 +0100
Message-ID: <3711506.y7zYNNW8hU@flatron>
User-Agent: KMail/4.12 (Linux/3.12.6-gentoo; KDE/4.12.0; x86_64; ; )
In-Reply-To: <1389095509-14357-2-git-send-email-ch.naveen@samsung.com>
References: <1389095509-14357-1-git-send-email-ch.naveen@samsung.com> <1389095509-14357-2-git-send-email-ch.naveen@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen,

Please see my comments inline.

On Tuesday 07 of January 2014 17:21:45 Naveen Krishna Ch wrote:
> This patch uses the platform_get_irq() instead of the
> platform_get_irq_byname(). Making feeder control interrupt
> as resource "0" and hash interrupt as "1".
> 
> reasons for this change.
> 1. Cannot find any Arch which is currently using this driver
> 2. Samsung Exynos5 SoCs only use the feeder control interrupt
> 3. Patches adding support for DT and H/W version are in pipeline
> 
> Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: David S. Miller <davem@davemloft.net>
> CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
> TO: <linux-crypto@vger.kernel.org>
> CC: <linux-samsung-soc@vger.kernel.org>
> ---
>  drivers/crypto/s5p-sss.c |   22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> index cf149b1..dda4551 100644
> --- a/drivers/crypto/s5p-sss.c
> +++ b/drivers/crypto/s5p-sss.c
> @@ -592,29 +592,29 @@ static int s5p_aes_probe(struct platform_device *pdev)
>  	pdata->ioaddr = devm_ioremap(dev, res->start,
>  				     resource_size(res));
>  
> -	pdata->irq_hash = platform_get_irq_byname(pdev, "hash");
> -	if (pdata->irq_hash < 0) {
> +	pdata->irq_fc = platform_get_irq(pdev, 0);
> +	if (pdata->irq_fc < 0) {
>  		err = pdata->irq_hash;

Shouldn't this be also changed to err = pdata->irq_fc; ?

Best regards,
Tomasz

