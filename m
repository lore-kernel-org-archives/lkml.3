Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbbAAJLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 04:11:41 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35173 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbbAAJLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 04:11:37 -0500
Date: Thu, 1 Jan 2015 10:11:32 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Guenter Roeck <linux@roeck-us.net>
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
Message-ID: <20150101091132.GB8759@amd>
References: <20141226102933.GA28778@amd>
 <1419597294-21487-1-git-send-email-sre@kernel.org>
 <1419597294-21487-3-git-send-email-sre@kernel.org>
 <CANOLnON6rAQ2+jJEFDKseH2Htu6bqRkURDioGt7zp1Ze73f8Pw@mail.gmail.com>
 <CAGo_u6qO0ok+GBnm7SQtw6dJuwGN2OuP7CpKDEWawS3V2go4KA@mail.gmail.com>
 <20141229181556.GA26926@amd>
 <20141229190448.GA27124@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141229190448.GA27124@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-12-29 11:04:48, Guenter Roeck wrote:
> On Mon, Dec 29, 2014 at 07:15:56PM +0100, Pavel Machek wrote:
> > On Mon 2014-12-29 12:01:03, Nishanth Menon wrote:
> > > On Mon, Dec 29, 2014 at 11:52 AM, Grazvydas Ignotas <notasas@gmail.com> wrote:
> > > > On Fri, Dec 26, 2014 at 2:34 PM, Sebastian Reichel <sre@kernel.org> wrote:
> > > >> OMAP34xx and OMAP36xx processors contain a register in the syscon area,
> > > >> which can be used to determine the SoCs temperature. This patch provides
> > > >> a DT based driver for the temperature sensor based on an older driver
> > > >> written by Peter De Schrijver for the Nokia N900 and N9.
> > > >
> > > > The sensor looks like an earlier iteration of sensors used in newer
> > > > OMAPs, which are already supported by maybe
> > > > drivers/thermal/ti-soc-thermal/ , maybe it would make sense to update
> > > > that driver instead?
> > > 
> > > Just to be clear - OMAP4 is the first time that the sensors were
> > > reliable enough to be used.
> > 
> > When testing initial version of the patch, they seem to work very well
> > in the omap3 case.
> > 
> Pavel,
> 
> can you look into the omap4 thermal driver to see if it can be used ?

The hardware seems similar, but omap4 has a lot more
features... Here's a test patch. It compiles and boots, but I'm too
far away from my working userland at this moment.

Best regards,
								Pavel

commit 116612364f93b165b22166f0043117059eb3118f
Author: Pavel <pavel@ucw.cz>
Date:   Wed Dec 31 00:36:40 2014 +0100

    Configure ti-soc-thermal to handle n900's thermal sensor.

diff --git a/.config b/.config
index b031e7f..4a79672 100644
--- a/.config
+++ b/.config
@@ -1671,7 +1671,23 @@ CONFIG_SENSORS_TWL4030_MADC=y
 # CONFIG_SENSORS_W83L786NG is not set
 # CONFIG_SENSORS_W83627HF is not set
 # CONFIG_SENSORS_W83627EHF is not set
-# CONFIG_THERMAL is not set
+CONFIG_THERMAL=y
+CONFIG_THERMAL_HWMON=y
+CONFIG_THERMAL_OF=y
+CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
+# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
+# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
+# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
+CONFIG_THERMAL_GOV_STEP_WISE=y
+# CONFIG_THERMAL_GOV_BANG_BANG is not set
+# CONFIG_THERMAL_GOV_USER_SPACE is not set
+# CONFIG_CLOCK_THERMAL is not set
+# CONFIG_THERMAL_EMULATION is not set
+
+#
+# Texas Instruments thermal drivers
+#
+CONFIG_TI_SOC_THERMAL=y
 CONFIG_WATCHDOG=y
 CONFIG_WATCHDOG_CORE=y
 # CONFIG_WATCHDOG_NOWAYOUT is not set
diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
index 55e4928..dcbcaa9 100644
--- a/arch/arm/boot/dts/omap3-n900.dts
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -29,6 +29,13 @@
 		};
 	};
 
+	bandgap: bandgap {
+			reg = <0x4a002524 0x4>;
+			compatible = "ti,omap34xx-bandgap";
+
+			#thermal-sensor-cells = <0>;
+	};
+
 	leds {
 		compatible = "gpio-leds";
 		heartbeat {
diff --git a/drivers/thermal/ti-soc-thermal/Makefile b/drivers/thermal/ti-soc-thermal/Makefile
index 1226b24..27ff2ed 100644
--- a/drivers/thermal/ti-soc-thermal/Makefile
+++ b/drivers/thermal/ti-soc-thermal/Makefile
@@ -2,5 +2,6 @@ obj-$(CONFIG_TI_SOC_THERMAL)		+= ti-soc-thermal.o
 ti-soc-thermal-y			:= ti-bandgap.o
 ti-soc-thermal-$(CONFIG_TI_THERMAL)	+= ti-thermal-common.o
 ti-soc-thermal-$(CONFIG_DRA752_THERMAL)	+= dra752-thermal-data.o
+ti-soc-thermal-y			+= omap3-thermal-data.o
 ti-soc-thermal-$(CONFIG_OMAP4_THERMAL)	+= omap4-thermal-data.o
 ti-soc-thermal-$(CONFIG_OMAP5_THERMAL)	+= omap5-thermal-data.o
diff --git a/drivers/thermal/ti-soc-thermal/omap3-thermal-data.c b/drivers/thermal/ti-soc-thermal/omap3-thermal-data.c
new file mode 100644
index 0000000..7e25ccd
--- /dev/null
+++ b/drivers/thermal/ti-soc-thermal/omap3-thermal-data.c
@@ -0,0 +1,94 @@
+/*
+ * OMAP4 thermal driver.
+ *
+ * Copyright (C) 2011-2012 Texas Instruments Inc.
+ * Copyright (C) 2014 Pavel Machek <pavel@ucw.cz>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include "ti-thermal.h"
+#include "ti-bandgap.h"
+
+/*
+ * OMAP34XX has one instance of thermal sensor for MPU
+ * need to describe the individual bit fields
+ */
+static struct temp_sensor_registers
+omap34xx_mpu_temp_sensor_registers = {
+	.temp_sensor_ctrl = 0,
+	.bgap_tempsoff_mask = 0, /* Unused, we don't have POWER_SWITCH */
+	.bgap_soc_mask = BIT(8),
+	.bgap_eocz_mask = BIT(7),
+	.bgap_dtemp_mask = 0x7f,
+
+	.bgap_mode_ctrl = 0,
+	.mode_ctrl_mask = 0,	/* Unused, no MODE_CONFIG */
+
+	.bgap_efuse = 0,
+};
+
+/* Thresholds and limits for OMAP34XX MPU temperature sensor */
+static struct temp_sensor_data omap34xx_mpu_temp_sensor_data = {
+	.min_freq = 100000,
+	.max_freq = 1000000,
+	.max_temp = -99000,
+	.min_temp = 99000,
+	.hyst_val = 5000,
+};
+
+/*
+ * Temperature values in milli degree celsius
+ * ADC code values from 530 to 923
+ */
+static const int
+omap34xx_adc_to_temp[] = {
+	-38000, -35000, -34000, -32000, -30000, -28000, -26000, -24000, -22000,
+	-20000, -18000, -17000, -15000, -13000, -12000, -10000, -8000, -6000,
+	-5000, -3000, -1000, 0, 2000, 3000, 5000, 6000, 8000, 10000, 12000,
+	13000, 15000, 17000, 19000, 21000, 23000, 25000, 27000, 28000, 30000,
+	32000, 33000, 35000, 37000, 38000, 40000, 42000, 43000, 45000, 47000,
+	48000, 50000, 52000, 53000, 55000, 57000, 58000, 60000, 62000, 64000,
+	66000, 68000, 70000, 71000, 73000, 75000, 77000, 78000, 80000, 82000,
+	83000, 85000, 87000, 88000, 90000, 92000, 93000, 95000, 97000, 98000,
+	100000, 102000, 103000, 105000, 107000, 109000, 111000, 113000, 115000,
+	117000, 118000, 120000, 122000, 123000,
+};
+
+/* OMAP34XX data */
+const struct ti_bandgap_data omap34xx_data = {
+	.features = TI_BANDGAP_FEATURE_CLK_CTRL,
+	.fclock_name = "ts_fclk",
+	.div_ck_name = "ts_fclk",
+	.conv_table = omap34xx_adc_to_temp,
+	.adc_start_val = 0,
+	.adc_end_val = 127,
+	.expose_sensor = ti_thermal_expose_sensor,
+	.remove_sensor = ti_thermal_remove_sensor,
+
+	.sensors = {
+		{
+		.registers = &omap34xx_mpu_temp_sensor_registers,
+		.ts_data = &omap34xx_mpu_temp_sensor_data,
+		.domain = "cpu",
+		.slope = 0,
+		.constant = 20000,
+		.slope_pcb = 0,
+		.constant_pcb = 20000,
+		.register_cooling = NULL,
+		.unregister_cooling = NULL,
+		},
+	},
+	.sensor_count = 1,
+
+	.sensor_count = 0,
+};
+
diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.c b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
index 634b6ce..2a72adc 100644
--- a/drivers/thermal/ti-soc-thermal/ti-bandgap.c
+++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
@@ -856,7 +856,7 @@ int ti_bandgap_read_temperature(struct ti_bandgap *bgp, int id,
 	temp = ti_bandgap_read_temp(bgp, id);
 	spin_unlock(&bgp->lock);
 
-	ret |= ti_bandgap_adc_to_mcelsius(bgp, temp, &temp);
+	ret = ti_bandgap_adc_to_mcelsius(bgp, temp, &temp);
 	if (ret)
 		return -EIO;
 
@@ -1509,6 +1509,10 @@ static SIMPLE_DEV_PM_OPS(ti_bandgap_dev_pm_ops, ti_bandgap_suspend,
 #endif
 
 static const struct of_device_id of_ti_bandgap_match[] = {
+	{
+		.compatible = "ti,omap34xx-bandgap",
+		.data = (void *)&omap34xx_data,
+	},
 #ifdef CONFIG_OMAP4_THERMAL
 	{
 		.compatible = "ti,omap4430-bandgap",
diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.h b/drivers/thermal/ti-soc-thermal/ti-bandgap.h
index b3adf72..3f05386 100644
--- a/drivers/thermal/ti-soc-thermal/ti-bandgap.h
+++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.h
@@ -384,6 +384,8 @@ int ti_bandgap_set_sensor_data(struct ti_bandgap *bgp, int id, void *data);
 void *ti_bandgap_get_sensor_data(struct ti_bandgap *bgp, int id);
 int ti_bandgap_get_trend(struct ti_bandgap *bgp, int id, int *trend);
 
+extern const struct ti_bandgap_data omap34xx_data;
+
 #ifdef CONFIG_OMAP4_THERMAL
 extern const struct ti_bandgap_data omap4430_data;
 extern const struct ti_bandgap_data omap4460_data;


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
