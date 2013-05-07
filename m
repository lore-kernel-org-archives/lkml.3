Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759276Ab3EGD42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 23:56:28 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46621 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758818Ab3EGD40 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:56:26 -0400
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: Grant Likely <grant.likely@linaro.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] spi/omap2: Let device core handle pinctrl
Thread-Topic: [PATCH] spi/omap2: Let device core handle pinctrl
Thread-Index: AQHOSpEtMssOEU4sAUGUr3i0BAEdV5j5FsQg
Date: Tue, 7 May 2013 03:56:09 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EBE473A@DBDE04.ent.ti.com>
References: <1367868998-12667-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1367868998-12667-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 01:06:38, Mark Brown wrote:
> Since commit ab78029 (drivers/pinctrl: grab default handles from device
> core) we can rely on device core for handling pinctrl so remove
> devm_pinctrl_get_select_default() from the driver.

NACK.

There are cases where driver('s) needs to place pin-mux's to sleep on suspend
& default/idle on resume. For such cases Pinctrl needs to be handled inside 
the driver. Example [1].

I will be submitting a patch to enhance the existing pinctrl support for 
spi omap2 shortly which does above work.

Regards
Gururaja


[1]
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/spi/spi-pl022.c

pl022_suspend_resources() & pl022_resume_resources()


> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/spi/spi-omap2-mcspi.c |    7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
> index 893c3d7..3777bd5 100644
> --- a/drivers/spi/spi-omap2-mcspi.c
> +++ b/drivers/spi/spi-omap2-mcspi.c
> @@ -38,7 +38,6 @@
>  #include <linux/pm_runtime.h>
>  #include <linux/of.h>
>  #include <linux/of_device.h>
> -#include <linux/pinctrl/consumer.h>
>  
>  #include <linux/spi/spi.h>
>  
> @@ -1170,7 +1169,6 @@ static int omap2_mcspi_probe(struct platform_device *pdev)
>  	static int		bus_num = 1;
>  	struct device_node	*node = pdev->dev.of_node;
>  	const struct of_device_id *match;
> -	struct pinctrl *pinctrl;
>  
>  	master = spi_alloc_master(&pdev->dev, sizeof *mcspi);
>  	if (master == NULL) {
> @@ -1268,11 +1266,6 @@ static int omap2_mcspi_probe(struct platform_device *pdev)
>  	if (status < 0)
>  		goto dma_chnl_free;
>  
> -	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
> -	if (IS_ERR(pinctrl))
> -		dev_warn(&pdev->dev,
> -				"pins are not configured from the driver\n");
> -
>  	pm_runtime_use_autosuspend(&pdev->dev);
>  	pm_runtime_set_autosuspend_delay(&pdev->dev, SPI_AUTOSUSPEND_TIMEOUT);
>  	pm_runtime_enable(&pdev->dev);
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


Regards, 
Gururaja
