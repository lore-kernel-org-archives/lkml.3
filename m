Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbbATMAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 07:00:34 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:40611 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbbATMAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 07:00:30 -0500
Date: Tue, 20 Jan 2015 12:00:20 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH 14/14] mfd: twl6040: Constify struct regmap_config and
 reg_default array
Message-ID: <20150120120020.GZ13701@x1>
References: <1420448493-9355-1-git-send-email-k.kozlowski@samsung.com>
 <1420448493-9355-14-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1420448493-9355-14-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Jan 2015, Krzysztof Kozlowski wrote:

> The regmap_config struct may be const because it is not modified by the
> driver and regmap_init() accepts pointer to const. Make array of
> struct reg_default const as well.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: linux-omap@vger.kernel.org
> ---
>  drivers/mfd/twl6040.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Applied with Tony's Ack, thanks.

> diff --git a/drivers/mfd/twl6040.c b/drivers/mfd/twl6040.c
> index 9687645162ae..f71ee3dbc2a2 100644
> --- a/drivers/mfd/twl6040.c
> +++ b/drivers/mfd/twl6040.c
> @@ -44,7 +44,7 @@
>  #define VIBRACTRL_MEMBER(reg) ((reg == TWL6040_REG_VIBCTLL) ? 0 : 1)
>  #define TWL6040_NUM_SUPPLIES	(2)
>  
> -static struct reg_default twl6040_defaults[] = {
> +static const struct reg_default twl6040_defaults[] = {
>  	{ 0x01, 0x4B }, /* REG_ASICID	(ro) */
>  	{ 0x02, 0x00 }, /* REG_ASICREV	(ro) */
>  	{ 0x03, 0x00 }, /* REG_INTID	*/
> @@ -580,7 +580,7 @@ static bool twl6040_writeable_reg(struct device *dev, unsigned int reg)
>  	}
>  }
>  
> -static struct regmap_config twl6040_regmap_config = {
> +static const struct regmap_config twl6040_regmap_config = {
>  	.reg_bits = 8,
>  	.val_bits = 8,
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
