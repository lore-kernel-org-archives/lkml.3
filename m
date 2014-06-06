Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbaFFGyY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 02:54:24 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:53447 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbaFFGyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 02:54:23 -0400
Date: Fri, 6 Jun 2014 07:54:18 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/3] mfd: davinci voicecodec need regmap_mmio
Message-ID: <20140606065418.GM24240@lee--X1>
References: <1402003454-1989084-1-git-send-email-arnd@arndb.de>
 <1402003454-1989084-3-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1402003454-1989084-3-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Jun 2014, Arnd Bergmann wrote:

> Without REGMAP_MMIO, building that driver results in a link error:
> 
> drivers/built-in.o: In function `davinci_vc_probe':
> :(.init.text+0x3c1c): undefined reference to `devm_regmap_init_mmio_clk'
> 
> This adds a Kconfig 'select' statement as the usual way to ensure
> that REGMAP_MMIO is enabled.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/mfd/Kconfig | 1 +
>  1 file changed, 1 insertion(+)

Applied, thanks.

> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 4370692..2dd838f 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -760,6 +760,7 @@ config MFD_SYSCON
>  config MFD_DAVINCI_VOICECODEC
>  	tristate
>  	select MFD_CORE
> +	select REGMAP_MMIO
>  
>  config MFD_TI_AM335X_TSCADC
>  	tristate "TI ADC / Touch Screen chip support"

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
