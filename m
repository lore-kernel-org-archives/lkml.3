Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab3JNKDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 06:03:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54113 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab3JNKDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 06:03:19 -0400
Date: Mon, 14 Oct 2013 12:03:11 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
cc: m.chehab@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] sh_mobile_ceu_camera: remove deprecated
 IRQF_DISABLED
In-Reply-To: <1381644106-9086-1-git-send-email-michael.opdenacker@free-electrons.com>
Message-ID: <Pine.LNX.4.64.1310141200530.25852@axis700.grange>
References: <1381644106-9086-1-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:PsTN3Hau3QLeUQbIoUm7JMfqS5DEe9t2RMJZTnnGBZo
 TC8Ar7ONJuKsVzWczghI/5Y38U1xYQxEyPruevirET5qAA3Vc0
 leZi3As+xPZaT3ngZ0UIrwIJ90KKkrT/dAGw0D4b20RpIgrWfs
 uh51fNzT5+PJu7+uH4uXbXz4JB/NO//XYU6bW4yqvlTh9eS49s
 SAtNnp8CMpPRj/1b2l/K0ZeLwcZ2lf3aiijUuIFEQo5qQGq7Fr
 HZIIumIdkFmJqaOT3PYQn5/N6ery01zu+V28M5bmGP5SSBN78C
 wxcEaLJwh8eNrgQY1BnLqCFI0csdvCy+xsXK5uQ+MEyxjviYSk
 DRDoC2OAjdtJzfNdsWREJgPvHEst+lOxXONs3WbDmGl2kbNniy
 0Bfug38uq2yrg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

Thanks for the patch. Since patches in the series are independent from 
each other, I can take this one via my tree, which would be preferred. 
Otherwise I can ack it and we can push it via another tree.

Thanks
Guennadi

On Sun, 13 Oct 2013, Michael Opdenacker wrote:

> This patch proposes to remove the use of the IRQF_DISABLED flag
> 
> It's a NOOP since 2.6.35 and it will be removed one day.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
> index 8df22f7..150bd4d 100644
> --- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
> +++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
> @@ -1800,7 +1800,7 @@ static int sh_mobile_ceu_probe(struct platform_device *pdev)
>  
>  	/* request irq */
>  	err = devm_request_irq(&pdev->dev, pcdev->irq, sh_mobile_ceu_irq,
> -			       IRQF_DISABLED, dev_name(&pdev->dev), pcdev);
> +			       0, dev_name(&pdev->dev), pcdev);
>  	if (err) {
>  		dev_err(&pdev->dev, "Unable to register CEU interrupt.\n");
>  		goto exit_release_mem;
> -- 
> 1.8.1.2
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
