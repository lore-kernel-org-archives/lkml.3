Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760041AbaGYIjx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 04:39:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60086 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758404AbaGYIjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 04:39:51 -0400
Date: Fri, 25 Jul 2014 09:39:48 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, gg@slimlogic.co.uk, k.kozlowski@samsung.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Subject: Re: [PATCH] extcon: Add missing REGMAP_I2C/REGMAP_IRQ dependency
	on extcon driver
Message-ID: <20140725083948.GA2391@opensource.wolfsonmicro.com>
References: <y@samsung.com> <1406079640-28069-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406079640-28069-1-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 10:40:40AM +0900, Chanwoo Choi wrote:
> This patch add missing REGMAP_I2C/REGMAP_IRQ dependency on extcon provider
> driver to protect build break.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  drivers/extcon/Kconfig | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
> index 6f2f472..77577db 100644
> --- a/drivers/extcon/Kconfig
> +++ b/drivers/extcon/Kconfig
> @@ -23,6 +23,7 @@ config EXTCON_ADC_JACK
>  config EXTCON_ARIZONA
>  	tristate "Wolfson Arizona EXTCON support"
>  	depends on MFD_ARIZONA && INPUT && SND_SOC
> +	select REGMAP_I2C
>  	help
>  	  Say Y here to enable support for external accessory detection
>  	  with Wolfson Arizona devices. These are audio CODECs with

Could you be more specific about the config that causes the build
break? This seems problematic as REGMAP_I2C is only a dependancy
if I2C is being used otherwise REGMAP_SPI would be the
dependancy.

Thanks,
Charles
