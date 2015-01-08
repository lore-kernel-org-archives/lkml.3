Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbbAHBFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 20:05:05 -0500
Received: from mga14.intel.com ([192.55.52.115]:40344 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708AbbAHBFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 20:05:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="437795990"
Date: Wed, 7 Jan 2015 17:05:00 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: todd.e.brandt@linux.intel.com
Cc: linux-pm@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        lee.jones@linaro.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, david.woodhouse@intel.com,
        todd.e.brandt@intel.com
Subject: Re: [PATCH 2/3] mfd/axp20x: add support for fuel gauge cell driver
Message-ID: <20150107170500.321d0e8f@ultegra>
In-Reply-To: <20150107212552.GC3440@linux.intel.com>
References: <20150107212552.GC3440@linux.intel.com>
Organization: OTC
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2015 13:25:52 -0800
Todd E Brandt <todd.e.brandt@linux.intel.com> wrote:

> mfd/axp20x: add support for fuel gauge cell
> 
Acked-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Register definitions and platform data structure 
> for fuel gauge cell devices.
> 
> Signed-off-by: Todd Brandt <todd.e.brandt@intel.com>
> ----
>  include/linux/mfd/axp20x.h | 43
> +++++++++++++++++++++++++++++++++++++++++-- 1 file changed, 41
> insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mfd/axp20x.h b/include/linux/mfd/axp20x.h
> index 81589d1..dfabd6d 100644
> --- a/include/linux/mfd/axp20x.h
> +++ b/include/linux/mfd/axp20x.h
> @@ -124,10 +124,27 @@ enum {
>  #define AXP288_PMIC_ADC_H               0x56
>  #define AXP288_PMIC_ADC_L               0x57
>  #define AXP288_ADC_TS_PIN_CTRL          0x84
> -
>  #define AXP288_PMIC_ADC_EN              0x84
> -#define AXP288_FG_TUNE5			0xed
>  
> +/* Fuel Gauge */
> +#define AXP288_FG_RDC1_REG          0xba
> +#define AXP288_FG_RDC0_REG          0xbb
> +#define AXP288_FG_OCVH_REG          0xbc
> +#define AXP288_FG_OCVL_REG          0xbd
> +#define AXP288_FG_OCV_CURVE_REG     0xc0
> +#define AXP288_FG_DES_CAP1_REG      0xe0
> +#define AXP288_FG_DES_CAP0_REG      0xe1
> +#define AXP288_FG_CC_MTR1_REG       0xe2
> +#define AXP288_FG_CC_MTR0_REG       0xe3
> +#define AXP288_FG_OCV_CAP_REG       0xe4
> +#define AXP288_FG_CC_CAP_REG        0xe5
> +#define AXP288_FG_LOW_CAP_REG       0xe6
> +#define AXP288_FG_TUNE0             0xe8
> +#define AXP288_FG_TUNE1             0xe9
> +#define AXP288_FG_TUNE2             0xea
> +#define AXP288_FG_TUNE3             0xeb
> +#define AXP288_FG_TUNE4             0xec
> +#define AXP288_FG_TUNE5             0xed
>  
>  /* Regulators IDs */
>  enum {
> @@ -236,4 +253,26 @@ struct axp20x_dev {
>  	const struct regmap_irq_chip	*regmap_irq_chip;
>  };
>  
> +#define BATTID_LEN				64
> +#define OCV_CURVE_SIZE			32
> +#define MAX_THERM_CURVE_SIZE	25
> +#define PD_DEF_MIN_TEMP			0
> +#define PD_DEF_MAX_TEMP			55
> +
> +struct axp20x_fg_pdata {
> +	char battid[BATTID_LEN + 1];
> +	int design_cap;
> +	int min_volt;
> +	int max_volt;
> +	int max_temp;
> +	int min_temp;
> +	int cap1;
> +	int cap0;
> +	int rdc1;
> +	int rdc0;
> +	int ocv_curve[OCV_CURVE_SIZE];
> +	int tcsz;
> +	int thermistor_curve[MAX_THERM_CURVE_SIZE][2];
> +};
> +
>  #endif /* __LINUX_MFD_AXP20X_H */

[Jacob Pan]
