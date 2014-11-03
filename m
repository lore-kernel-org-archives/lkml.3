Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbaKCQDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:03:17 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:61860 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbaKCQDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 11:03:15 -0500
Date: Mon, 3 Nov 2014 16:03:09 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] mfd: twl4030-power: Fix regression with missing
 compatible flag
Message-ID: <20141103160309.GC10544@x1>
References: <20141102180938.GI31454@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141102180938.GI31454@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 02 Nov 2014, Tony Lindgren wrote:

> Commit e7cd1d1eb16f ("mfd: twl4030-power: Add generic reset
> configuration") accidentally removed the compatible flag for
> "ti,twl4030-power" that should be there as documented in the
> binding.
> 
> If "ti,twl4030-power" only the poweroff configuration is done
> by the driver.
> 
> Fixes: e7cd1d1eb16f ("mfd: twl4030-power: Add generic reset configuration")
> Cc: stable@vger.kernel.org # v3.16+
> Reported-by: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
> Signed-off-by: Tony Lindgren <tony@atomide.com>

Applied, thanks.

> --- a/drivers/mfd/twl4030-power.c
> +++ b/drivers/mfd/twl4030-power.c
> @@ -831,6 +831,9 @@ static struct twl4030_power_data osc_off_idle = {
>  
>  static struct of_device_id twl4030_power_of_match[] = {
>  	{
> +		.compatible = "ti,twl4030-power",
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
