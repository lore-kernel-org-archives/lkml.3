Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbaKJJHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 04:07:46 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:64364 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbaKJJHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 04:07:44 -0500
Date: Mon, 10 Nov 2014 09:07:38 +0000
From: Lee Jones <lee.jones@linaro.org>
To: NeilBrown <neilb@suse.de>
Cc: Tony Lindgren <tony@atomide.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, GTA04 owners <gta04-owner@goldelico.com>
Subject: Re: [PATCH] mfd: twl4030-power: Support compatible =
 "ti,twl4030-power" again.
Message-ID: <20141110090738.GA21424@x1>
References: <20141108112227.256f93ce@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141108112227.256f93ce@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 08 Nov 2014, NeilBrown wrote:
>
> commit e7cd1d1eb16fcdf53001b926187a82f1f3e1a7e6
>     mfd: twl4030-power: Add generic reset configuration
> 
> claims:
>     Let's add device tree support and configure things for warm reset
>     as the default when compatible = "ti,twl4030-power".
> and
>     Documentation/devicetree/bindings/mfd/twl4030-power.txt
> claims that "ti,twl4030-power" is still a valid "compatible" setting.
> 
> However the current driver fails to probe with that 'compatible'
> setting.
> Restore the old default.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>

Tony should take a look at this.

> diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
> index 4d3ff3771491..1a7794f6be15 100644
> --- a/drivers/mfd/twl4030-power.c
> +++ b/drivers/mfd/twl4030-power.c
> @@ -776,6 +776,10 @@ static struct twl4030_power_data osc_off_idle = {
>  
>  static struct of_device_id twl4030_power_of_match[] = {
>  	{
> +		.compatible = "ti,twl4030-power",
> +		.data = NULL,
> +	},
> +	{
>  		.compatible = "ti,twl4030-power-reset",
>  		.data = &omap3_reset,
>  	},



-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
