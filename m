Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbaFCICv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 04:02:51 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:47305 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541AbaFCICs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 04:02:48 -0400
Date: Tue, 3 Jun 2014 09:02:41 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
Cc: linus.walleij@linaro.org, broonie@kernel.org, sameo@linux.intel.com,
        mika.westerberg@linux.intel.com, gnurou@gmail.com,
        linux-kernel@vger.kernel.org, jacob.jun.pan@linux.intel.com,
        bin.yang@intel.com
Subject: Re: [PATCH v5 1/3] mfd: intel_soc_pmic: Core driver
Message-ID: <20140603080241.GA3060@lee--X1>
References: <1401773164-30326-1-git-send-email-lejun.zhu@linux.intel.com>
 <1401773164-30326-2-git-send-email-lejun.zhu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401773164-30326-2-git-send-email-lejun.zhu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch provides the common I2C driver code for Intel SoC PMICs.
> 
> Signed-off-by: Yang, Bin <bin.yang@intel.com>
> Signed-off-by: Zhu, Lejun <lejun.zhu@linux.intel.com>
> ---
> v2:
> - Use regmap instead of creating our own I2C read/write callbacks.
> - Add one missing EXPORT_SYMBOL.
> - Remove duplicate code and put them into pmic_regmap_load_from_hw.
> v3:
> - Use regmap-irq. Remove our own pmic_regmap_* and IRQ handling code.
> - Remove intel_soc_pmic_dev() and intel_soc_pmic_set_pdata().
> - Use EXPORT_SYMBOL_GPL for exposed APIs.
> - Use gpiod interface instead of gpio numbers.
> - Remove redundant I2C IDs.
> - Use managed allocations.
> v4:
> - Remove all exported APIs which are wrappers of regmap API, export
>   the regmap in data structure instead.
> - Combine I2C and core .c files.
> - Clean up include files.
> - Use intel_soc_pmic_ prefix to replace pmic_ and intel_pmic_.
> - Fix various coding style issues.
> v5:
> - Add comment to describe what is done in _find_gpio_irq().
> - Remove i2c id. Only keep ACPI id and match it in _probe().
> - Further fix of coding style issues.
> ---
>  drivers/mfd/intel_soc_pmic_core.c  | 168 +++++++++++++++++++++++++++++++++++++
>  drivers/mfd/intel_soc_pmic_core.h  |  32 +++++++
>  include/linux/mfd/intel_soc_pmic.h |  30 +++++++
>  3 files changed, 230 insertions(+)
>  create mode 100644 drivers/mfd/intel_soc_pmic_core.c
>  create mode 100644 drivers/mfd/intel_soc_pmic_core.h
>  create mode 100644 include/linux/mfd/intel_soc_pmic.h

Looks good to me now, but the merge window is immenent.  If there are
no more comments in 2 weeks time I will apply for v3.17.

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
