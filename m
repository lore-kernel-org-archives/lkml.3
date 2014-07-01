Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424AbaGAHlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 03:41:15 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:46228 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757368AbaGAHlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 03:41:11 -0400
Date: Tue, 1 Jul 2014 08:41:05 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Nishanth Menon <nm@ti.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Keerthy J <j-keerthy@ti.com>,
        Tero Kristo <t-kristo@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH V2 2/6] regulator: palmas: Rename reg_info to
 palmas_reg_info
Message-ID: <20140701074105.GB27971@lee--X1>
References: <1404143859-8160-1-git-send-email-nm@ti.com>
 <1404143859-8160-3-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1404143859-8160-3-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2014, Nishanth Menon wrote:

> reg_info is a generic term which might cause conflict at a later point
> in time. To prevent such a thing from occuring in future, rename to
> palmas_reg_info.
> 
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
>  drivers/regulator/palmas-regulator.c |    4 ++--
>  include/linux/mfd/palmas.h           |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
> index 91f60fa..05f11b9 100644
> --- a/drivers/regulator/palmas-regulator.c
> +++ b/drivers/regulator/palmas-regulator.c
> @@ -41,7 +41,7 @@ static const struct regulator_linear_range smps_high_ranges[] = {
>  	REGULATOR_LINEAR_RANGE(3300000, 0x7A, 0x7f, 0),
>  };
>  
> -static struct regs_info palmas_regs_info[] = {
> +static struct palmas_regs_info palmas_regs_info[] = {
>  	{
>  		.name		= "SMPS12",
>  		.sname		= "smps1-in",
> @@ -227,7 +227,7 @@ static struct regs_info palmas_regs_info[] = {
>  	},
>  };
>  
> -static struct regs_info tps65917_regs_info[] = {
> +static struct palmas_regs_info tps65917_regs_info[] = {
>  	{
>  		.name		= "SMPS1",
>  		.sname		= "smps1-in",
> diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
> index 1a045ba..fb0390a 100644
> --- a/include/linux/mfd/palmas.h
> +++ b/include/linux/mfd/palmas.h
> @@ -102,7 +102,7 @@ struct palmas_sleep_requestor_info {
>  	int bit_pos;
>  };
>  
> -struct regs_info {
> +struct palmas_regs_info {
>  	char	*name;
>  	char	*sname;
>  	u8	vsel_addr;
> @@ -117,7 +117,7 @@ struct palmas_pmic_driver_data {
>  	int ldo_begin;
>  	int ldo_end;
>  	int max_reg;
> -	struct regs_info *palmas_regs_info;
> +	struct palmas_regs_info *palmas_regs_info;
>  	struct of_regulator_match *palmas_matches;
>  	struct palmas_sleep_requestor_info *sleep_req_info;
>  	int (*smps_register)(struct palmas_pmic *pmic,

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
