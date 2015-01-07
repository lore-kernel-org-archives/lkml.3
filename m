Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbbAGQUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 11:20:24 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:41716 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbbAGQUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 11:20:22 -0500
Date: Wed, 7 Jan 2015 08:19:44 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: Nishanth Menon <nm@ti.com>, Grazvydas Ignotas <notasas@gmail.com>,
        Sebastian Reichel <sre@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        dt list <devicetree@vger.kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Tony Lindgren <tony@atomide.com>, Kumar Gala <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lm-sensors@lm-sensors.org, Rob Herring <robh+dt@kernel.org>,
        Jean Delvare <jdelvare@suse.de>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Pali Rohar <pali.rohar@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/3] hwmon: Driver for OMAP3 temperature sensor
Message-ID: <20150107161944.GB9012@roeck-us.net>
References: <20141226102933.GA28778@amd>
 <1419597294-21487-1-git-send-email-sre@kernel.org>
 <1419597294-21487-3-git-send-email-sre@kernel.org>
 <CANOLnON6rAQ2+jJEFDKseH2Htu6bqRkURDioGt7zp1Ze73f8Pw@mail.gmail.com>
 <CAGo_u6qO0ok+GBnm7SQtw6dJuwGN2OuP7CpKDEWawS3V2go4KA@mail.gmail.com>
 <20141229181556.GA26926@amd>
 <20141229190448.GA27124@roeck-us.net>
 <20150103091858.GA30538@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150103091858.GA30538@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020204.50F5A4FD.0387,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 16
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 03, 2015 at 10:18:58AM +0100, Pavel Machek wrote:
> On Mon 2014-12-29 11:04:48, Guenter Roeck wrote:
> > On Mon, Dec 29, 2014 at 07:15:56PM +0100, Pavel Machek wrote:
> > > On Mon 2014-12-29 12:01:03, Nishanth Menon wrote:
> > > > On Mon, Dec 29, 2014 at 11:52 AM, Grazvydas Ignotas <notasas@gmail.com> wrote:
> > > > > On Fri, Dec 26, 2014 at 2:34 PM, Sebastian Reichel <sre@kernel.org> wrote:
> > > > >> OMAP34xx and OMAP36xx processors contain a register in the syscon area,
> > > > >> which can be used to determine the SoCs temperature. This patch provides
> > > > >> a DT based driver for the temperature sensor based on an older driver
> > > > >> written by Peter De Schrijver for the Nokia N900 and N9.
> > > > >
> > > > > The sensor looks like an earlier iteration of sensors used in newer
> > > > > OMAPs, which are already supported by maybe
> > > > > drivers/thermal/ti-soc-thermal/ , maybe it would make sense to update
> > > > > that driver instead?
> > > > 
> > > > Just to be clear - OMAP4 is the first time that the sensors were
> > > > reliable enough to be used.
> > > 
> > > When testing initial version of the patch, they seem to work very well
> > > in the omap3 case.
> > > 
> > Pavel,
> > 
> > can you look into the omap4 thermal driver to see if it can be used ?
> 
> After some fixes... yes, it seems to be same hardware.
> 
So this should be the way to go, but then we have others claim that
it should not be done because the OMAP3 sensors are too unreliable
to use for thermal decisions. Not really sure where that leaves us.
I am kind of opposed to have similar drivers for similar chips
in two different subsystems.

Is it possible to add the patch below to the omap thermal driver
and not use it for thermal decisions ?

Guenter

> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> diff --git a/drivers/thermal/ti-soc-thermal/Kconfig b/drivers/thermal/ti-soc-thermal/Kconfig
> index bd4c7be..a49495f 100644
> --- a/drivers/thermal/ti-soc-thermal/Kconfig
> +++ b/drivers/thermal/ti-soc-thermal/Kconfig
> @@ -21,6 +21,15 @@ config TI_THERMAL
>  	  This includes trip points definitions, extrapolation rules and
>  	  CPU cooling device bindings.
>  
> +config OMAP3_THERMAL
> +	bool "Texas Instruments OMAP3 thermal support"
> +	depends on TI_SOC_THERMAL
> +	depends on ARCH_OMAP3
> +	help
> +	  If you say yes here you get thermal support for the Texas Instruments
> +	  OMAP3 SoC family. The current chip supported are:
> +	   - OMAP3430
> +
>  config OMAP4_THERMAL
>  	bool "Texas Instruments OMAP4 thermal support"
>  	depends on TI_SOC_THERMAL
> diff --git a/drivers/thermal/ti-soc-thermal/Makefile b/drivers/thermal/ti-soc-thermal/Makefile
> index 1226b24..2b5b220 100644
> --- a/drivers/thermal/ti-soc-thermal/Makefile
> +++ b/drivers/thermal/ti-soc-thermal/Makefile
> @@ -2,5 +2,6 @@ obj-$(CONFIG_TI_SOC_THERMAL)		+= ti-soc-thermal.o
>  ti-soc-thermal-y			:= ti-bandgap.o
>  ti-soc-thermal-$(CONFIG_TI_THERMAL)	+= ti-thermal-common.o
>  ti-soc-thermal-$(CONFIG_DRA752_THERMAL)	+= dra752-thermal-data.o
> +ti-soc-thermal-$(CONFIG_OMAP3_THERMAL)  += omap3-thermal-data.o
>  ti-soc-thermal-$(CONFIG_OMAP4_THERMAL)	+= omap4-thermal-data.o
>  ti-soc-thermal-$(CONFIG_OMAP5_THERMAL)	+= omap5-thermal-data.o
> diff --git a/drivers/thermal/ti-soc-thermal/omap3-thermal-data.c b/drivers/thermal/ti-soc-thermal/omap3-thermal-data.c
> new file mode 100644
> index 0000000..a79ebf2
> --- /dev/null
> +++ b/drivers/thermal/ti-soc-thermal/omap3-thermal-data.c
> @@ -0,0 +1,99 @@
> +/*
> + * OMAP3 thermal driver.
> + *
> + * Copyright (C) 2011-2012 Texas Instruments Inc.
> + * Copyright (C) 2014 Pavel Machek <pavel@ucw.cz>
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#include "ti-thermal.h"
> +#include "ti-bandgap.h"
> +
> +/*
> + * OMAP34XX has one instance of thermal sensor for MPU
> + * need to describe the individual bit fields
> + */
> +static struct temp_sensor_registers
> +omap34xx_mpu_temp_sensor_registers = {
> +	.temp_sensor_ctrl = 0,
> +	.bgap_tempsoff_mask = 0, /* Unused, we don't have POWER_SWITCH */
> +	.bgap_soc_mask = BIT(8),
> +	.bgap_eocz_mask = BIT(7),
> +	.bgap_dtemp_mask = 0x7f,
> +
> +	.bgap_mode_ctrl = 0,
> +	.mode_ctrl_mask = 0,	/* Unused, no MODE_CONFIG */
> +
> +	.bgap_efuse = 0,
> +};
> +
> +/* Thresholds and limits for OMAP34XX MPU temperature sensor */
> +static struct temp_sensor_data omap34xx_mpu_temp_sensor_data = {
> +	.min_freq = 32768,
> +	.max_freq = 32768,
> +	.max_temp = -99000,
> +	.min_temp = 99000,
> +	.hyst_val = 5000,
> +};
> +
> +/*
> + * Temperature values in milli degree celsius
> + * ADC code values from 530 to 923
> + */
> +static const int
> +omap34xx_adc_to_temp[] = {
> +	-40000, -40000, -40000, -40000, -40000, -39000, -38000, -36000,
> +	-34000, -32000, -31000,	-29000, -28000, -26000, -25000, -24000,
> +	-22000, -21000, -19000, -18000, -17000, -15000,	-14000, -12000,
> +	-11000, -9000, -8000, -7000, -5000, -4000, -2000, -1000, 0000,
> +	1000, 3000, 4000, 5000, 7000, 8000, 10000, 11000, 13000, 14000,
> +	15000, 17000, 18000, 20000, 21000, 22000, 24000, 25000, 27000,
> +	28000, 30000, 31000, 32000, 34000, 35000, 37000, 38000, 39000,
> +	41000, 42000, 44000, 45000, 47000, 48000, 49000, 51000, 52000,
> +	53000, 55000, 56000, 58000, 59000, 60000, 62000, 63000, 65000,
> +	66000, 67000, 69000, 70000, 72000, 73000, 74000, 76000, 77000,
> +	79000, 80000, 81000, 83000, 84000, 85000, 87000, 88000, 89000,
> +	91000, 92000, 94000, 95000, 96000, 98000, 99000, 100000,
> +	102000, 103000, 105000, 106000, 107000, 109000, 110000, 111000,
> +	113000, 114000, 116000, 117000, 118000, 120000, 121000, 122000,
> +	124000, 124000, 125000, 125000, 125000, 125000,	125000
> +};
> +
> +/* OMAP34XX data */
> +const struct ti_bandgap_data omap34xx_data = {
> +	.features = TI_BANDGAP_FEATURE_CLK_CTRL,
> +	.fclock_name = "ts_fck",
> +	.div_ck_name = "ts_fck",
> +	.conv_table = omap34xx_adc_to_temp,
> +	.adc_start_val = 0,
> +	.adc_end_val = 127,
> +	.expose_sensor = ti_thermal_expose_sensor,
> +	.remove_sensor = ti_thermal_remove_sensor,
> +
> +	.sensors = {
> +		{
> +		.registers = &omap34xx_mpu_temp_sensor_registers,
> +		.ts_data = &omap34xx_mpu_temp_sensor_data,
> +		.domain = "cpu",
> +		.slope = 0,
> +		.constant = 20000,
> +		.slope_pcb = 0,
> +		.constant_pcb = 20000,
> +		.register_cooling = NULL,
> +		.unregister_cooling = NULL,
> +		},
> +	},
> +	.sensor_count = 1,
> +
> +//	.sensor_count = 0,
> +};
> +
> diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.c b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
> index 634b6ce..a4180a5 100644
> --- a/drivers/thermal/ti-soc-thermal/ti-bandgap.c
> +++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
> @@ -40,6 +40,7 @@
>  #include <linux/of_irq.h>
>  #include <linux/of_gpio.h>
>  #include <linux/io.h>
> +#include <linux/delay.h>
>  
>  #include "ti-bandgap.h"
>  
> @@ -103,19 +104,15 @@ do {								\
>   */
>  static int ti_bandgap_power(struct ti_bandgap *bgp, bool on)
>  {
> -	int i, ret = 0;
> +	int i;
>  
> -	if (!TI_BANDGAP_HAS(bgp, POWER_SWITCH)) {
> -		ret = -ENOTSUPP;
> -		goto exit;
> -	}
> +	if (!TI_BANDGAP_HAS(bgp, POWER_SWITCH))
> +		return -ENOTSUPP;
>  
>  	for (i = 0; i < bgp->conf->sensor_count; i++)
>  		/* active on 0 */
>  		RMW_BITS(bgp, i, temp_sensor_ctrl, bgap_tempsoff_mask, !on);
> -
> -exit:
> -	return ret;
> +	return 0;
>  }
>  
>  /**
> @@ -154,6 +151,7 @@ static u32 ti_bandgap_read_temp(struct ti_bandgap *bgp, int id)
>  	if (TI_BANDGAP_HAS(bgp, FREEZE_BIT))
>  		RMW_BITS(bgp, id, bgap_mask_ctrl, mask_freeze_mask, 0);
>  
> +	printk("Bandgap: ADC is %d\n", temp);
>  	return temp;
>  }
>  
> @@ -263,18 +261,13 @@ static
>  int ti_bandgap_adc_to_mcelsius(struct ti_bandgap *bgp, int adc_val, int *t)
>  {
>  	const struct ti_bandgap_data *conf = bgp->conf;
> -	int ret = 0;
>  
>  	/* look up for temperature in the table and return the temperature */
> -	if (adc_val < conf->adc_start_val || adc_val > conf->adc_end_val) {
> -		ret = -ERANGE;
> -		goto exit;
> -	}
> +	if (adc_val < conf->adc_start_val || adc_val > conf->adc_end_val)
> +		return -ERANGE;
>  
>  	*t = bgp->conf->conv_table[adc_val - conf->adc_start_val];
> -
> -exit:
> -	return ret;
> +	return 0;
>  }
>  
>  /**
> @@ -295,16 +288,14 @@ int ti_bandgap_mcelsius_to_adc(struct ti_bandgap *bgp, long temp, int *adc)
>  {
>  	const struct ti_bandgap_data *conf = bgp->conf;
>  	const int *conv_table = bgp->conf->conv_table;
> -	int high, low, mid, ret = 0;
> +	int high, low, mid;
>  
>  	low = 0;
>  	high = conf->adc_end_val - conf->adc_start_val;
>  	mid = (high + low) / 2;
>  
> -	if (temp < conv_table[low] || temp > conv_table[high]) {
> -		ret = -ERANGE;
> -		goto exit;
> -	}
> +	if (temp < conv_table[low] || temp > conv_table[high])
> +		return -ERANGE;
>  
>  	while (low < high) {
>  		if (temp < conv_table[mid])
> @@ -315,9 +306,7 @@ int ti_bandgap_mcelsius_to_adc(struct ti_bandgap *bgp, long temp, int *adc)
>  	}
>  
>  	*adc = conf->adc_start_val + low;
> -
> -exit:
> -	return ret;
> +	return 0;
>  }
>  
>  /**
> @@ -343,13 +332,11 @@ int ti_bandgap_add_hyst(struct ti_bandgap *bgp, int adc_val, int hyst_val,
>  	 */
>  	ret = ti_bandgap_adc_to_mcelsius(bgp, adc_val, &temp);
>  	if (ret < 0)
> -		goto exit;
> +		return ret;
>  
>  	temp += hyst_val;
>  
>  	ret = ti_bandgap_mcelsius_to_adc(bgp, temp, sum);
> -
> -exit:
>  	return ret;
>  }
>  
> @@ -468,22 +455,18 @@ exit:
>   */
>  static inline int ti_bandgap_validate(struct ti_bandgap *bgp, int id)
>  {
> -	int ret = 0;
> -
>  	if (!bgp || IS_ERR(bgp)) {
>  		pr_err("%s: invalid bandgap pointer\n", __func__);
> -		ret = -EINVAL;
> -		goto exit;
> +		return -EINVAL;
>  	}
>  
>  	if ((id < 0) || (id >= bgp->conf->sensor_count)) {
>  		dev_err(bgp->dev, "%s: sensor id out of range (%d)\n",
>  			__func__, id);
> -		ret = -ERANGE;
> +		return -ERANGE;
>  	}
>  
> -exit:
> -	return ret;
> +	return 0;
>  }
>  
>  /**
> @@ -511,12 +494,10 @@ static int _ti_bandgap_write_threshold(struct ti_bandgap *bgp, int id, int val,
>  
>  	ret = ti_bandgap_validate(bgp, id);
>  	if (ret)
> -		goto exit;
> +		return ret;
>  
> -	if (!TI_BANDGAP_HAS(bgp, TALERT)) {
> -		ret = -ENOTSUPP;
> -		goto exit;
> -	}
> +	if (!TI_BANDGAP_HAS(bgp, TALERT))
> +		return -ENOTSUPP;
>  
>  	ts_data = bgp->conf->sensors[id].ts_data;
>  	tsr = bgp->conf->sensors[id].registers;
> @@ -529,17 +510,15 @@ static int _ti_bandgap_write_threshold(struct ti_bandgap *bgp, int id, int val,
>  	}
>  
>  	if (ret)
> -		goto exit;
> -
> +		return ret;
> +	
>  	ret = ti_bandgap_mcelsius_to_adc(bgp, val, &adc_val);
>  	if (ret < 0)
> -		goto exit;
> +		return ret;		
>  
>  	spin_lock(&bgp->lock);
>  	ret = ti_bandgap_update_alert_threshold(bgp, id, adc_val, hot);
>  	spin_unlock(&bgp->lock);
> -
> -exit:
>  	return ret;
>  }
>  
> @@ -582,7 +561,7 @@ static int _ti_bandgap_read_threshold(struct ti_bandgap *bgp, int id,
>  
>  	temp = ti_bandgap_readl(bgp, tsr->bgap_threshold);
>  	temp = (temp & mask) >> __ffs(mask);
> -	ret |= ti_bandgap_adc_to_mcelsius(bgp, temp, &temp);
> +	ret = ti_bandgap_adc_to_mcelsius(bgp, temp, &temp);
>  	if (ret) {
>  		dev_err(bgp->dev, "failed to read thot\n");
>  		ret = -EIO;
> @@ -856,10 +835,11 @@ int ti_bandgap_read_temperature(struct ti_bandgap *bgp, int id,
>  	temp = ti_bandgap_read_temp(bgp, id);
>  	spin_unlock(&bgp->lock);
>  
> -	ret |= ti_bandgap_adc_to_mcelsius(bgp, temp, &temp);
> +	ret = ti_bandgap_adc_to_mcelsius(bgp, temp, &temp);
>  	if (ret)
>  		return -EIO;
>  
> +	printk("Bandgap: temperature is %d\n", temp);
>  	*temperature = temp;
>  
>  	return 0;
> @@ -918,6 +898,7 @@ static int
>  ti_bandgap_force_single_read(struct ti_bandgap *bgp, int id)
>  {
>  	u32 temp = 0, counter = 1000;
> +	struct temp_sensor_registers *tsr;
>  
>  	/* Select single conversion mode */
>  	if (TI_BANDGAP_HAS(bgp, MODE_CONFIG))
> @@ -925,16 +906,26 @@ ti_bandgap_force_single_read(struct ti_bandgap *bgp, int id)
>  
>  	/* Start of Conversion = 1 */
>  	RMW_BITS(bgp, id, temp_sensor_ctrl, bgap_soc_mask, 1);
> -	/* Wait until DTEMP is updated */
> -	temp = ti_bandgap_read_temp(bgp, id);
>  
> -	while ((temp == 0) && --counter)
> -		temp = ti_bandgap_read_temp(bgp, id);
> -	/* REVISIT: Check correct condition for end of conversion */
> +	/* Wait for EOCZ going up */
> +	tsr = bgp->conf->sensors[id].registers;
> +	
> +	while (--counter) {
> +		if (ti_bandgap_readl(bgp, tsr->temp_sensor_ctrl) & tsr->bgap_eocz_mask)
> +			break;
> +		printk("@");
> +	}
>  
>  	/* Start of Conversion = 0 */
>  	RMW_BITS(bgp, id, temp_sensor_ctrl, bgap_soc_mask, 0);
>  
> +	counter = 1000;
> +	while (--counter) {
> +		if (!(ti_bandgap_readl(bgp, tsr->temp_sensor_ctrl) & tsr->bgap_eocz_mask))
> +			break;
> +		printk("#");
> +	}
> +
>  	return 0;
>  }
>  
> @@ -1196,6 +1187,8 @@ int ti_bandgap_probe(struct platform_device *pdev)
>  	struct ti_bandgap *bgp;
>  	int clk_rate, ret = 0, i;
>  
> +	printk("ti_bandgap: probe\n");
> +
>  	bgp = ti_bandgap_build(pdev);
>  	if (IS_ERR(bgp)) {
>  		dev_err(&pdev->dev, "failed to fetch platform data\n");
> @@ -1220,11 +1213,10 @@ int ti_bandgap_probe(struct platform_device *pdev)
>  		goto free_irqs;
>  	}
>  
> -	bgp->div_clk = clk_get(NULL,  bgp->conf->div_ck_name);
> +	bgp->div_clk = clk_get(NULL, bgp->conf->div_ck_name);
>  	ret = IS_ERR(bgp->div_clk);
>  	if (ret) {
> -		dev_err(&pdev->dev,
> -			"failed to request div_ts_ck clock ref\n");
> +		dev_err(&pdev->dev, "failed to request div_ts_ck clock ref\n");
>  		ret = PTR_ERR(bgp->div_clk);
>  		goto free_irqs;
>  	}
> @@ -1312,6 +1304,8 @@ int ti_bandgap_probe(struct platform_device *pdev)
>  	/* Every thing is good? Then expose the sensors */
>  	for (i = 0; i < bgp->conf->sensor_count; i++) {
>  		char *domain;
> +		extern int ti_thermal_expose_sensor(struct ti_bandgap *bgp, int id,
> +					     char *domain);
>  
>  		if (bgp->conf->sensors[i].register_cooling) {
>  			ret = bgp->conf->sensors[i].register_cooling(bgp, i);
> @@ -1319,12 +1313,29 @@ int ti_bandgap_probe(struct platform_device *pdev)
>  				goto remove_sensors;
>  		}
>  
> +		printk("bandgap: exposing sensor: %p\n", bgp->conf->expose_sensor);
> +		
>  		if (bgp->conf->expose_sensor) {
> +			printk("bandgap: calling %p %p\n", bgp->conf->expose_sensor, ti_thermal_expose_sensor);
>  			domain = bgp->conf->sensors[i].domain;
>  			ret = bgp->conf->expose_sensor(bgp, i, domain);
> +			printk("bandgap: done\n");
>  			if (ret)
>  				goto remove_last_cooling;
>  		}
> +
> +		printk("bandgap: exposing sensor\n");
> +		{
> +			int t;
> +
> +			ti_bandgap_force_single_read(bgp, 0);
> +
> +			t = ti_bandgap_read_temp(bgp, 0);
> +			printk("Temperature ADC: %d\n", t);			
> +			ti_bandgap_read_temperature(bgp, 0, &t);
> +			printk("Temperature: %d\n", t);
> +			mdelay(1000);
> +		}
>  	}
>  
>  	/*
> @@ -1365,6 +1376,8 @@ free_irqs:
>  		free_irq(gpio_to_irq(bgp->tshut_gpio), NULL);
>  		gpio_free(bgp->tshut_gpio);
>  	}
> +	printk("ti_bandgap: probe: something failed\n");
> +	mdelay(10000);
>  
>  	return ret;
>  }
> @@ -1509,6 +1522,12 @@ static SIMPLE_DEV_PM_OPS(ti_bandgap_dev_pm_ops, ti_bandgap_suspend,
>  #endif
>  
>  static const struct of_device_id of_ti_bandgap_match[] = {
> +#ifdef CONFIG_OMAP3_THERMAL
> +	{
> +		.compatible = "ti,omap34xx-bandgap",
> +		.data = (void *)&omap34xx_data,
> +	},
> +#endif
>  #ifdef CONFIG_OMAP4_THERMAL
>  	{
>  		.compatible = "ti,omap4430-bandgap",
> diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.h b/drivers/thermal/ti-soc-thermal/ti-bandgap.h
> index b3adf72..3f05386 100644
> --- a/drivers/thermal/ti-soc-thermal/ti-bandgap.h
> +++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.h
> @@ -384,6 +384,8 @@ int ti_bandgap_set_sensor_data(struct ti_bandgap *bgp, int id, void *data);
>  void *ti_bandgap_get_sensor_data(struct ti_bandgap *bgp, int id);
>  int ti_bandgap_get_trend(struct ti_bandgap *bgp, int id, int *trend);
>  
> +extern const struct ti_bandgap_data omap34xx_data;
> +
>  #ifdef CONFIG_OMAP4_THERMAL
>  extern const struct ti_bandgap_data omap4430_data;
>  extern const struct ti_bandgap_data omap4460_data;
> diff --git a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
> index 5fd0386..f91655f 100644
> --- a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
> +++ b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
> @@ -328,18 +328,23 @@ int ti_thermal_expose_sensor(struct ti_bandgap *bgp, int id,
>  {
>  	struct ti_thermal_data *data;
>  
> +	printk("expose_sensor\n");
> +
>  	data = ti_bandgap_get_sensor_data(bgp, id);
>  
>  	if (!data || IS_ERR(data))
>  		data = ti_thermal_build_data(bgp, id);
>  
> -	if (!data)
> +	if (!data) {
> +		printk("no data\n");	
>  		return -EINVAL;
> +	}
>  
>  	/* in case this is specified by DT */
>  	data->ti_thermal = thermal_zone_of_sensor_register(bgp->dev, id,
>  					data, &ti_of_thermal_ops);
>  	if (IS_ERR(data->ti_thermal)) {
> +		printk("of_sensor_register failed\n");
>  		/* Create thermal zone */
>  		data->ti_thermal = thermal_zone_device_register(domain,
>  				OMAP_TRIP_NUMBER, 0, data, &ti_thermal_ops,
> 
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
