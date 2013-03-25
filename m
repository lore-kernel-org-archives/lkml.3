Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345Ab3CYIoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 04:44:21 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:48752 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757312Ab3CYIoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 04:44:20 -0400
Date: Mon, 25 Mar 2013 08:44:14 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] regulator: ab8500: Use regulator_list_voltage_linear
 for fixed voltage
Message-ID: <20130325084414.GA3568@gmail.com>
References: <1364194430.25717.1.camel@phoenix>
 <1364194740.27158.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1364194740.27158.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Mar 2013, Axel Lin wrote:

> 
> Both ab8500_regulator_mode_ops and ab8500_regulator_ops do not have volt_table
> setting, thus we can not use regulator_list_voltage_table for them.
> However, they have min_uV setting with n_voltages = 1, so use
> regulator_list_voltage_linear instead.
> 
> Also remove setting set_voltage_time_sel for ab8500_regulator_mode_ops.
> It is used only for fixed voltage, so it does not need to implement
> set_voltage_time_sel.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Looks good to me.

Acked-by: Lee Jones <lee.jones@linaro.org>

> ---
>  drivers/regulator/ab8500.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
> index a2d19c6..12e2740 100644
> --- a/drivers/regulator/ab8500.c
> +++ b/drivers/regulator/ab8500.c
> @@ -363,8 +363,7 @@ static struct regulator_ops ab8500_regulator_mode_ops = {
>  	.set_mode		= ab8500_regulator_set_mode,
>  	.get_mode		= ab8500_regulator_get_mode,
>  	.get_voltage_sel 	= ab8500_regulator_get_voltage_sel,
> -	.list_voltage		= regulator_list_voltage_table,
> -	.set_voltage_time_sel	= ab8500_regulator_set_voltage_time_sel,
> +	.list_voltage		= regulator_list_voltage_linear,
>  };
>  
>  static struct regulator_ops ab8500_regulator_ops = {
> @@ -372,7 +371,7 @@ static struct regulator_ops ab8500_regulator_ops = {
>  	.disable		= ab8500_regulator_disable,
>  	.is_enabled		= ab8500_regulator_is_enabled,
>  	.get_voltage_sel 	= ab8500_regulator_get_voltage_sel,
> -	.list_voltage		= regulator_list_voltage_table,
> +	.list_voltage		= regulator_list_voltage_linear,
>  };
>  
>  static struct ab8500_regulator_info

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
