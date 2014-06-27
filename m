Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbaF0IX7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 04:23:59 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:34965 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbaF0IX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 04:23:57 -0400
Date: Fri, 27 Jun 2014 09:23:51 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Keerthy <j-keerthy@ti.com>
Cc: linux-omap@vger.kernel.org, lgirdwood@gmail.com, broonie@kernel.org,
        linux-kernel@vger.kernel.org, sameo@linux.intel.com
Subject: Re: [PATCH v2 8/9] regulator: palmas: add driver data and modularize
 the probe
Message-ID: <20140627082351.GE19645@lee--X1>
References: <1403085540-20014-1-git-send-email-j-keerthy@ti.com>
 <1403085540-20014-9-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403085540-20014-9-git-send-email-j-keerthy@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014, Keerthy wrote:
> add driver data and modularize the probe.

Nit: This is a sentence, it should start with a capital letter.

> Signed-off-by: Keerthy <j-keerthy@ti.com>
> ---
> 
> Changes in V2:
> 
>   * Fixed the order of variable declarations.
> 
>  drivers/mfd/palmas.c                 |   44 +--
>  drivers/regulator/palmas-regulator.c |  658 ++++++++++++++++++++--------------
>  2 files changed, 396 insertions(+), 306 deletions(-)
> 
> diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
> index c12759d..28cb048 100644
> --- a/drivers/mfd/palmas.c
> +++ b/drivers/mfd/palmas.c
> @@ -25,42 +25,6 @@
>  #include <linux/mfd/palmas.h>
>  #include <linux/of_device.h>
>  
> -#define EXTERNAL_REQUESTOR(_id, _offset, _pos)		\
> -	[PALMAS_EXTERNAL_REQSTR_ID_##_id] = {		\
> -		.id = PALMAS_EXTERNAL_REQSTR_ID_##_id,	\
> -		.reg_offset = _offset,			\
> -		.bit_pos = _pos,			\
> -	}
> -
> -static struct palmas_sleep_requestor_info sleep_req_info[] = {
> -	EXTERNAL_REQUESTOR(REGEN1, 0, 0),
> -	EXTERNAL_REQUESTOR(REGEN2, 0, 1),
> -	EXTERNAL_REQUESTOR(SYSEN1, 0, 2),
> -	EXTERNAL_REQUESTOR(SYSEN2, 0, 3),
> -	EXTERNAL_REQUESTOR(CLK32KG, 0, 4),
> -	EXTERNAL_REQUESTOR(CLK32KGAUDIO, 0, 5),
> -	EXTERNAL_REQUESTOR(REGEN3, 0, 6),
> -	EXTERNAL_REQUESTOR(SMPS12, 1, 0),
> -	EXTERNAL_REQUESTOR(SMPS3, 1, 1),
> -	EXTERNAL_REQUESTOR(SMPS45, 1, 2),
> -	EXTERNAL_REQUESTOR(SMPS6, 1, 3),
> -	EXTERNAL_REQUESTOR(SMPS7, 1, 4),
> -	EXTERNAL_REQUESTOR(SMPS8, 1, 5),
> -	EXTERNAL_REQUESTOR(SMPS9, 1, 6),
> -	EXTERNAL_REQUESTOR(SMPS10, 1, 7),
> -	EXTERNAL_REQUESTOR(LDO1, 2, 0),
> -	EXTERNAL_REQUESTOR(LDO2, 2, 1),
> -	EXTERNAL_REQUESTOR(LDO3, 2, 2),
> -	EXTERNAL_REQUESTOR(LDO4, 2, 3),
> -	EXTERNAL_REQUESTOR(LDO5, 2, 4),
> -	EXTERNAL_REQUESTOR(LDO6, 2, 5),
> -	EXTERNAL_REQUESTOR(LDO7, 2, 6),
> -	EXTERNAL_REQUESTOR(LDO8, 2, 7),
> -	EXTERNAL_REQUESTOR(LDO9, 3, 0),
> -	EXTERNAL_REQUESTOR(LDOLN, 3, 1),
> -	EXTERNAL_REQUESTOR(LDOUSB, 3, 2),
> -};
> -

Happy with this, good riddance.

>  static const struct regmap_config palmas_regmap_config[PALMAS_NUM_CLIENTS] = {
>  	{
>  		.reg_bits = 8,
> @@ -365,10 +329,10 @@ static struct regmap_irq_chip tps65917_irq_chip = {
>  int palmas_ext_control_req_config(struct palmas *palmas,
>  	enum palmas_external_requestor_id id,  int ext_ctrl, bool enable)
>  {
> +	struct palmas_pmic_driver_data *pmic_ddata = palmas->pmic_ddata;
>  	int preq_mask_bit = 0;
>  	int reg_add = 0;
> -	int bit_pos;
> -	int ret;
> +	int bit_pos, ret;

I don't like this change.

[...]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
