Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161162AbaDQIdK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 04:33:10 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:42267 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161002AbaDQIdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 04:33:05 -0400
Date: Thu, 17 Apr 2014 09:32:58 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 2/2] mfd: sec-core: Update sec_pmic documentation
Message-ID: <20140417083258.GH28725@lee--X1>
References: <1397477015-13900-1-git-send-email-k.kozlowski@samsung.com>
 <1397477015-13900-2-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1397477015-13900-2-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Update the documentation for sec_pmic state container structure to
> reflect current code.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  include/linux/mfd/samsung/core.h | 29 +++++++++++++++++------------
>  1 file changed, 17 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/mfd/samsung/core.h b/include/linux/mfd/samsung/core.h
> index 2633083262ea..1923fe026c01 100644
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
> + * @dev:		Master device of the chip (can be used to access
> + *			platform data)

Please remove the part in ()'s.

a) There's no need for it - we know what's in 'struct device' and b)
if 'struct platform_data' is removed from 'struct device' this comment
will become incorrect. Easy maintainability and all that ...

> + * @pdata:		Platform data from DTS or board files

s/from/populated with data from

> + * @regmap_pmic:	Regmap associated with PMIC's I2C address
> + * @i2c:		I2C client of the main driver
> + * @device_type:	Type of device, matches enum sec_device_type
> + * @irq_base:		Base IRQ number for device, required for IRQs

Is there any reason for not using IRQ Domains?

> + * @irq:		Generic IRQ number for device
> + * @irq_data:		Runtime data structure for IRQ controller
> + * @ono:		Power onoff IRQ number for s5m87xx

Perhaps consider a better name for this in a future patch.

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
