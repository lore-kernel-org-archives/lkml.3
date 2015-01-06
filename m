Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbbAFRQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 12:16:08 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:21164 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755860AbbAFRQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 12:16:04 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18uRWKKXwVWmjZ94fxj52u5
Date: Tue, 6 Jan 2015 09:12:15 -0800
From: Tony Lindgren <tony@atomide.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 14/14] mfd: twl6040: Constify struct regmap_config and
 reg_default array
Message-ID: <20150106171215.GT4081@atomide.com>
References: <1420448493-9355-1-git-send-email-k.kozlowski@samsung.com>
 <1420448493-9355-14-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420448493-9355-14-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Krzysztof Kozlowski <k.kozlowski@samsung.com> [150105 01:04]:
> The regmap_config struct may be const because it is not modified by the
> driver and regmap_init() accepts pointer to const. Make array of
> struct reg_default const as well.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Acked-by: Tony Lindgren <tony@atomide.com>

> Cc: linux-omap@vger.kernel.org
> ---
>  drivers/mfd/twl6040.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
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
> -- 
> 1.9.1
> 
