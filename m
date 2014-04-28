Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486AbaD1Onk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 10:43:40 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53882 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932335AbaD1Onh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:43:37 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-7e-535e6916630a
Message-id: <1398696213.12945.12.camel@AMDC1943>
Subject: Re: [PATCH 1/2] mfd: max77693: remove unnecessary wrapper functions
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, a.zummo@towertech.it,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        m.szyprowski@samsung.com
Date: Mon, 28 Apr 2014 16:43:33 +0200
In-reply-to: <1398694103-29320-2-git-send-email-r.baldyga@samsung.com>
References: <1398694103-29320-1-git-send-email-r.baldyga@samsung.com>
 <1398694103-29320-2-git-send-email-r.baldyga@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu1
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t/xK7pimXHBBj8OmVosuXiV3eL+16OM
	Fpd3zWGzWHvkLrvFg8M72S32d3YwWpzuZnVg99gz8SSbx51re9g85p0M9OjbsorRY/q8n0we
	nzfJBbBFcdmkpOZklqUW6dslcGWse9DJVDDfpuLN0mfsDYwrDLsYOTgkBEwkDi7y6mLkBDLF
	JC7cW8/WxcjFISSwlFHi+Jy5TCAJIYHPjBJ7L8SD2LwCBhLbDh9nAbGFBXwk3u2YxgxiswkY
	S2xevoQNxBYR0JK483E+O8ggZoG5jBI73n5mBEmwCKhKzPt4BGwop4CbRPviF4wQ2xoZJXZv
	3sIOkmAWUJeYNG8RM8RJyhLz9h9jgtgsKPFj8j0WiBp5ic1r3jJPYBSYhaRlFpKyWUjKFjAy
	r2IUTS1NLihOSs810itOzC0uzUvXS87P3cQICfavOxiXHrM6xCjAwajEwytoGBMsxJpYVlyZ
	e4hRgoNZSYRXNC0uWIg3JbGyKrUoP76oNCe1+BAjEwenVAPjUb6VDwLaizS0rZrs5kjO86yI
	/uJu/V2/KWiG1JQqu6+6k1OCbjrJz7jp+jWF69l5qZN8R+oqivb/ert+j314r4lRzPWCcIXY
	jUmK84znlicwGG34JPqWZar2k3XONh/jvyzuMzdeteuQqrSpenhU45woC08v0WDOPL/5xcvW
	vvOI2J8v/VaJpTgj0VCLuag4EQCBCcrCVAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2014-04-28 at 16:08 +0200, Robert Baldyga wrote:
> This patch removes wrapper functions used to access regmap, and
> make driver using regmap_*() functions instead.
> 
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> ---
>  drivers/extcon/extcon-max77693.c     | 30 +++++++++----------
>  drivers/mfd/max77693-irq.c           | 31 ++++++++++----------
>  drivers/mfd/max77693.c               | 56 ++----------------------------------
>  drivers/regulator/max77693.c         | 12 ++++----
>  include/linux/mfd/max77693-private.h |  8 ------
>  5 files changed, 39 insertions(+), 98 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
> index da268fb..efa105f 100644
> --- a/drivers/extcon/extcon-max77693.c
> +++ b/drivers/extcon/extcon-max77693.c
> @@ -255,10 +255,10 @@ static int max77693_muic_set_debounce_time(struct max77693_muic_info *info,
>  	case ADC_DEBOUNCE_TIME_10MS:
>  	case ADC_DEBOUNCE_TIME_25MS:
>  	case ADC_DEBOUNCE_TIME_38_62MS:
> -		ret = max77693_update_reg(info->max77693->regmap_muic,
> +		ret = regmap_update_bits(info->max77693->regmap_muic,
>  					  MAX77693_MUIC_REG_CTRL3,
> -					  time << CONTROL3_ADCDBSET_SHIFT,
> -					  CONTROL3_ADCDBSET_MASK);
> +					  CONTROL3_ADCDBSET_MASK,
> +					  time << CONTROL3_ADCDBSET_SHIFT);
>  		if (ret) {
>  			dev_err(info->dev, "failed to set ADC debounce time\n");
>  			return ret;
> @@ -293,8 +293,8 @@ static int max77693_muic_set_path(struct max77693_muic_info *info,
>  	else
>  		ctrl1 = CONTROL1_SW_OPEN;
>  
> -	ret = max77693_update_reg(info->max77693->regmap_muic,
> -			MAX77693_MUIC_REG_CTRL1, ctrl1, COMP_SW_MASK);
> +	ret = regmap_update_bits(info->max77693->regmap_muic,
> +			MAX77693_MUIC_REG_CTRL1, COMP_SW_MASK, ctrl1);

Change the  'ctrl1' and 'ctrl2' local variables to unsigned int. In this
context mixing u8 and unsigned int is not an error but it is not
consistent with regmap API.

Actually this applies to all places and all drivers, maybe except arrays
like max77693_muic_info.status[] where u8 makes sense.


>  	if (ret < 0) {
>  		dev_err(info->dev, "failed to update MUIC register\n");
>  		return ret;
> @@ -305,9 +305,9 @@ static int max77693_muic_set_path(struct max77693_muic_info *info,
>  	else
>  		ctrl2 |= CONTROL2_LOWPWR_MASK;	/* LowPwr=1, CPEn=0 */
>  
> -	ret = max77693_update_reg(info->max77693->regmap_muic,
> -			MAX77693_MUIC_REG_CTRL2, ctrl2,
> -			CONTROL2_LOWPWR_MASK | CONTROL2_CPEN_MASK);
> +	ret = regmap_update_bits(info->max77693->regmap_muic,
> +			MAX77693_MUIC_REG_CTRL2,
> +			CONTROL2_LOWPWR_MASK | CONTROL2_CPEN_MASK, ctrl2);
>  	if (ret < 0) {
>  		dev_err(info->dev, "failed to update MUIC register\n");
>  		return ret;
> @@ -969,8 +969,8 @@ static void max77693_muic_irq_work(struct work_struct *work)
>  		if (info->irq == muic_irqs[i].virq)
>  			irq_type = muic_irqs[i].irq;
>  
> -	ret = max77693_bulk_read(info->max77693->regmap_muic,
> -			MAX77693_MUIC_REG_STATUS1, 2, info->status);
> +	ret = regmap_bulk_read(info->max77693->regmap_muic,
> +			MAX77693_MUIC_REG_STATUS1, info->status, 2);
>  	if (ret) {
>  		dev_err(info->dev, "failed to read MUIC register\n");
>  		mutex_unlock(&info->mutex);
> @@ -1042,8 +1042,8 @@ static int max77693_muic_detect_accessory(struct max77693_muic_info *info)
>  	mutex_lock(&info->mutex);
>  
>  	/* Read STATUSx register to detect accessory */
> -	ret = max77693_bulk_read(info->max77693->regmap_muic,
> -			MAX77693_MUIC_REG_STATUS1, 2, info->status);
> +	ret = regmap_bulk_read(info->max77693->regmap_muic,
> +			MAX77693_MUIC_REG_STATUS1, info->status, 2);
>  	if (ret) {
>  		dev_err(info->dev, "failed to read MUIC register\n");
>  		mutex_unlock(&info->mutex);
> @@ -1095,7 +1095,7 @@ static int max77693_muic_probe(struct platform_device *pdev)
>  	int delay_jiffies;
>  	int ret;
>  	int i;
> -	u8 id;
> +	unsigned int id;
>  
>  	info = devm_kzalloc(&pdev->dev, sizeof(struct max77693_muic_info),
>  				   GFP_KERNEL);
> @@ -1205,7 +1205,7 @@ static int max77693_muic_probe(struct platform_device *pdev)
>  		enum max77693_irq_source irq_src
>  				= MAX77693_IRQ_GROUP_NR;
>  
> -		max77693_write_reg(info->max77693->regmap_muic,
> +		regmap_write(info->max77693->regmap_muic,
>  				init_data[i].addr,
>  				init_data[i].data);
>  
> @@ -1263,7 +1263,7 @@ static int max77693_muic_probe(struct platform_device *pdev)
>  	 max77693_muic_set_path(info, info->path_uart, true);
>  
>  	/* Check revision number of MUIC device*/
> -	ret = max77693_read_reg(info->max77693->regmap_muic,
> +	ret = regmap_read(info->max77693->regmap_muic,
>  			MAX77693_MUIC_REG_ID, &id);
>  	if (ret < 0) {
>  		dev_err(&pdev->dev, "failed to read revision number\n");
> diff --git a/drivers/mfd/max77693-irq.c b/drivers/mfd/max77693-irq.c
> index 66b58fe..1a89ec2 100644
> --- a/drivers/mfd/max77693-irq.c
> +++ b/drivers/mfd/max77693-irq.c
> @@ -30,8 +30,9 @@
>  #include <linux/irqdomain.h>
>  #include <linux/mfd/max77693.h>
>  #include <linux/mfd/max77693-private.h>
> +#include <linux/regmap.h>
>  
> -static const u8 max77693_mask_reg[] = {
> +static const unsigned int max77693_mask_reg[] = {
>  	[LED_INT] = MAX77693_LED_REG_FLASH_INT_MASK,
>  	[TOPSYS_INT] = MAX77693_PMIC_REG_TOPSYS_INT_MASK,
>  	[CHG_INT] = MAX77693_CHG_REG_CHG_INT_MASK,
> @@ -118,7 +119,7 @@ static void max77693_irq_sync_unlock(struct irq_data *data)
>  			continue;
>  		max77693->irq_masks_cache[i] = max77693->irq_masks_cur[i];
>  
> -		max77693_write_reg(map, max77693_mask_reg[i],
> +		regmap_write(map, max77693_mask_reg[i],
>  				max77693->irq_masks_cur[i]);
>  	}
>  
> @@ -177,12 +178,12 @@ static struct irq_chip max77693_irq_chip = {
>  static irqreturn_t max77693_irq_thread(int irq, void *data)
>  {
>  	struct max77693_dev *max77693 = data;
> -	u8 irq_reg[MAX77693_IRQ_GROUP_NR] = {};
> -	u8 irq_src;
> +	unsigned int irq_reg[MAX77693_IRQ_GROUP_NR] = {};
> +	unsigned int irq_src;
>  	int ret;
>  	int i, cur_irq;
>  
> -	ret = max77693_read_reg(max77693->regmap, MAX77693_PMIC_REG_INTSRC,
> +	ret = regmap_read(max77693->regmap, MAX77693_PMIC_REG_INTSRC,
>  				&irq_src);
>  	if (ret < 0) {
>  		dev_err(max77693->dev, "Failed to read interrupt source: %d\n",
> @@ -192,23 +193,23 @@ static irqreturn_t max77693_irq_thread(int irq, void *data)
>  
>  	if (irq_src & MAX77693_IRQSRC_CHG)
>  		/* CHG_INT */
> -		ret = max77693_read_reg(max77693->regmap, MAX77693_CHG_REG_CHG_INT,
> +		ret = regmap_read(max77693->regmap, MAX77693_CHG_REG_CHG_INT,
>  				&irq_reg[CHG_INT]);
>  
>  	if (irq_src & MAX77693_IRQSRC_TOP)
>  		/* TOPSYS_INT */
> -		ret = max77693_read_reg(max77693->regmap,
> +		ret = regmap_read(max77693->regmap,
>  			MAX77693_PMIC_REG_TOPSYS_INT, &irq_reg[TOPSYS_INT]);
>  
>  	if (irq_src & MAX77693_IRQSRC_FLASH)
>  		/* LED_INT */
> -		ret = max77693_read_reg(max77693->regmap,
> +		ret = regmap_read(max77693->regmap,
>  			MAX77693_LED_REG_FLASH_INT, &irq_reg[LED_INT]);
>  
>  	if (irq_src & MAX77693_IRQSRC_MUIC)
>  		/* MUIC INT1 ~ INT3 */
> -		max77693_bulk_read(max77693->regmap_muic, MAX77693_MUIC_REG_INT1,
> -			MAX77693_NUM_IRQ_MUIC_REGS, &irq_reg[MUIC_INT1]);
> +		regmap_bulk_read(max77693->regmap_muic, MAX77693_MUIC_REG_INT1,
> +			&irq_reg[MUIC_INT1], MAX77693_NUM_IRQ_MUIC_REGS);

The 'irq_reg' should be array of u8 to use the regmap_bulk_read (but
regmap_read uses unsigned int). I know that in next patch you want to
remove the max77693-irq completely but still the interim patch should
work OK (e.g. for bisecting).


Best regards,
Krzysztof

