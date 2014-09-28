Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbaI1QaI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 12:30:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:57563 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459AbaI1QaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 12:30:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="392730216"
Date: Sun, 28 Sep 2014 21:30:41 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Mark Brown <broonie@linaro.org>,
        Dan Williams <dan.j.williams@intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma: imx-sdma: fix another incorrect __init annotation
Message-ID: <20140928160040.GI1638@intel.com>
References: <38530464.3ymIRX74DK@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38530464.3ymIRX74DK@wuerfel>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 11:24:00PM +0200, Arnd Bergmann wrote:
> In e34b731faa7d1 ("dma: imx-sdma: Remove spurious __init annotation on
> sdma_probe()"), Mark found an extraneous __init label and fixed it.
> 
> However, he missed another one, because now we get this other warning:
> 
> WARNING: drivers/dma/imx-sdma.o(.text+0x3bb4): Section mismatch in reference from the function sdma_probe() to the function .init.text:sdma_get_firmware()
> The function sdma_probe() references
> the function __init sdma_get_firmware().
> 
> Same reasoning as the last time, the function may get called at
> runtime, so it can't be __init.
> 
Applied, thanks

-- 
~Vinod

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> index 52ce1d21154c..88afc48c2ca7 100644
> --- a/drivers/dma/imx-sdma.c
> +++ b/drivers/dma/imx-sdma.c
> @@ -1334,7 +1334,7 @@ err_firmware:
>  	release_firmware(fw);
>  }
>  
> -static int __init sdma_get_firmware(struct sdma_engine *sdma,
> +static int sdma_get_firmware(struct sdma_engine *sdma,
>  		const char *fw_name)
>  {
>  	int ret;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe dmaengine" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
