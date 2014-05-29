Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052AbaE2Lt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 07:49:28 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:41100 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaE2Lt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 07:49:26 -0400
Date: Thu, 29 May 2014 12:49:21 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
Cc: broonie@kernel.org, sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        jacob.jun.pan@linux.intel.com, bin.yang@intel.com
Subject: Re: [PATCH v4 2/3] mfd: intel_soc_pmic: Crystal Cove support
Message-ID: <20140529114921.GK1954@lee--X1>
References: <1401347968-24410-1-git-send-email-lejun.zhu@linux.intel.com>
 <1401347968-24410-3-git-send-email-lejun.zhu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401347968-24410-3-git-send-email-lejun.zhu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2014, Zhu, Lejun wrote:

> This patch provides chip-specific support for Crystal Cove. Crystal
> Cove is the PMIC in Baytrail-T platform.
> 
> Signed-off-by: Yang, Bin <bin.yang@intel.com>
> Signed-off-by: Zhu, Lejun <lejun.zhu@linux.intel.com>
> ---
> v2:
> - Add regmap_config for Crystal Cove.
> v3:
> - Convert IRQ config to regmap_irq_chip.
> v4:
> - Cleanup include files.
> - Remove useless init() function.
> - Remove useless .label and .init from struct intel_soc_pmic_config.
> - Fix various coding style issues.
> ---
>  drivers/mfd/intel_soc_pmic_crc.c | 160 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 160 insertions(+)
>  create mode 100644 drivers/mfd/intel_soc_pmic_crc.c
> 
> diff --git a/drivers/mfd/intel_soc_pmic_crc.c b/drivers/mfd/intel_soc_pmic_crc.c
> new file mode 100644
> index 0000000..43dbfcd
> --- /dev/null
> +++ b/drivers/mfd/intel_soc_pmic_crc.c
> @@ -0,0 +1,160 @@
> +/*
> + * intel_soc_pmic_crc.c - Device access for Crystal Cove PMIC
> + *
> + * Copyright (C) 2013, 2014 Intel Corporation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version
> + * 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * Author: Yang, Bin <bin.yang@intel.com>
> + * Author: Zhu, Lejun <lejun.zhu@linux.intel.com>
> + */
> +
> +#include <linux/mfd/core.h>
> +#include <linux/interrupt.h>
> +#include <linux/regmap.h>
> +#include <linux/mfd/intel_soc_pmic.h>
> +#include "intel_soc_pmic_core.h"
> +
> +#define CRYSTAL_COVE_MAX_REGISTER	0xC6
> +
> +#define REG_IRQLVL1			0x02
> +#define REG_MIRQLVL1			0x0E
> +
> +enum crystal_cove_irq {
> +	PWRSRC_IRQ = 0,
> +	THRM_IRQ,
> +	BCU_IRQ,
> +	ADC_IRQ,
> +	CHGR_IRQ,
> +	GPIO_IRQ,
> +	VHDMIOCP_IRQ
> +};

I can't help thinking that these should be nice clear #defines

#define CRYSTAL_COVE_IRQ_PWSRC 		0
...
#define CRYSTAL_COVE_IRQ_VHDMIOCP	6

[...]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
