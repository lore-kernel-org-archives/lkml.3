Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbaD1Jil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 05:38:41 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50526 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbaD1Jii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 05:38:38 -0400
Date: Mon, 28 Apr 2014 10:38:32 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mfd: sec-core: Update sec_pmic documentation
Message-ID: <20140428093832.GP6264@lee--X1>
References: <1398326738-17248-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398326738-17248-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2014, Krzysztof Kozlowski wrote:

> Update the documentation for sec_pmic state container structure to
> reflect current code.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> 
> ---
> Changes since v2:
>  - Rebased on lee/mfd.

You did? Which tree/branch? I still get:

Applying: mfd: sec-core: Update sec_pmic documentation
Using index info to reconstruct a base tree...
M	include/linux/mfd/samsung/core.h
Falling back to patching base and 3-way merge...
Auto-merging include/linux/mfd/samsung/core.h
CONFLICT (content): Merge conflict in include/linux/mfd/samsung/core.h
Recorded preimage for 'include/linux/mfd/samsung/core.h'
Failed to merge in the changes.
Patch failed at 0002 mfd: sec-core: Update sec_pmic documentation
The copy of the patch that failed is found in:
   /home/lee/projects/linux/.git/rebase-apply/patch
When you have resolved this problem, run "git am --resolved".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am -abort".

> Changes since v1:
>  - Update documentation after review from Lee Jones.
> ---
>  include/linux/mfd/samsung/core.h | 29 +++++++++++++++++------------
>  1 file changed, 17 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/mfd/samsung/core.h b/include/linux/mfd/samsung/core.h
> index e7e12ebacb9b..47d84242940b 100644
> --- a/include/linux/mfd/samsung/core.h
> +++ b/include/linux/mfd/samsung/core.h
> @@ -24,18 +24,23 @@ enum sec_device_type {
>  };
>  
>  /**
> - * struct sec_pmic_dev - s5m87xx master device for sub-drivers
> - * @dev: master device of the chip (can be used to access platform data)
> - * @pdata: pointer to private data used to pass platform data to child
> - * @i2c: i2c client private data for regulator
> - * @iolock: mutex for serializing io access
> - * @irqlock: mutex for buslock
> - * @irq_base: base IRQ number for sec-pmic, required for IRQs
> - * @irq: generic IRQ number for s5m87xx
> - * @ono: power onoff IRQ number for s5m87xx
> - * @irq_masks_cur: currently active value
> - * @irq_masks_cache: cached hardware value
> - * @type: indicate which s5m87xx "variant" is used
> + * struct sec_pmic_dev - s2m/s5m master device for sub-drivers
> + * @dev:		Master device of the chip
> + * @pdata:		Platform data populated with data from DTS
> + *			or board files
> + * @regmap_pmic:	Regmap associated with PMIC's I2C address
> + * @i2c:		I2C client of the main driver
> + * @device_type:	Type of device, matches enum sec_device_type
> + * @irq_base:		Base IRQ number for device, required for IRQs
> + * @irq:		Generic IRQ number for device
> + * @irq_data:		Runtime data structure for IRQ controller
> + * @ono:		Power onoff IRQ number for s5m87xx
> + * @wakeup:		Whether or not this is a wakeup device
> + * @wtsr_smpl:		Whether or not to enable in RTC driver the Watchdog
> + *			Timer Software Reset (registers set to default value
> + *			after PWRHOLD falling) and Sudden Momentary Power Loss
> + *			(PMIC will enter power on sequence after short drop in
> + *			VBATT voltage).
>   */
>  struct sec_pmic_dev {
>  	struct device *dev;

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
