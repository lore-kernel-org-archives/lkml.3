Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbbATL6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:58:42 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:44008 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbbATL6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:58:40 -0500
Date: Tue, 20 Jan 2015 11:58:35 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/14] mfd: mc13xxx: i2c/spi: Constify struct
 regmap_config
Message-ID: <20150120115835.GU13701@x1>
References: <1420448493-9355-1-git-send-email-k.kozlowski@samsung.com>
 <1420448493-9355-7-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1420448493-9355-7-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Jan 2015, Krzysztof Kozlowski wrote:

> The regmap_config struct may be const because it is not modified by the
> driver and regmap_init() accepts pointer to const.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/mfd/mc13xxx-i2c.c | 2 +-
>  drivers/mfd/mc13xxx-spi.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/mc13xxx-i2c.c b/drivers/mfd/mc13xxx-i2c.c
> index ae3addb153a2..68b844811566 100644
> --- a/drivers/mfd/mc13xxx-i2c.c
> +++ b/drivers/mfd/mc13xxx-i2c.c
> @@ -46,7 +46,7 @@ static const struct of_device_id mc13xxx_dt_ids[] = {
>  };
>  MODULE_DEVICE_TABLE(of, mc13xxx_dt_ids);
>  
> -static struct regmap_config mc13xxx_regmap_i2c_config = {
> +static const struct regmap_config mc13xxx_regmap_i2c_config = {
>  	.reg_bits = 8,
>  	.val_bits = 24,
>  
> diff --git a/drivers/mfd/mc13xxx-spi.c b/drivers/mfd/mc13xxx-spi.c
> index 702925e242c9..58a170e45d88 100644
> --- a/drivers/mfd/mc13xxx-spi.c
> +++ b/drivers/mfd/mc13xxx-spi.c
> @@ -48,7 +48,7 @@ static const struct of_device_id mc13xxx_dt_ids[] = {
>  };
>  MODULE_DEVICE_TABLE(of, mc13xxx_dt_ids);
>  
> -static struct regmap_config mc13xxx_regmap_spi_config = {
> +static const struct regmap_config mc13xxx_regmap_spi_config = {
>  	.reg_bits = 7,
>  	.pad_bits = 1,
>  	.val_bits = 24,

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
