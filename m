Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449Ab3GMKdW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 06:33:22 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45915 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823Ab3GMKdT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 06:33:19 -0400
From: "Kozaruk, Oleksandr" <oleksandr.kozaruk@ti.com>
To: Lee Jones <lee.jones@linaro.org>
CC: "rob@landley.net" <rob@landley.net>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "Krishnamoorthy, Balaji T" <balajitk@ti.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: RE: [PATCH v1 2/2] mfd: twl6030-gpadc: TWL6030, TWL6032 GPADC driver
Thread-Topic: [PATCH v1 2/2] mfd: twl6030-gpadc: TWL6030, TWL6032 GPADC
 driver
Thread-Index: AQHOf7AyG3vlNQ1kfUyHmQ99RHCDFpliZ0ce
Date: Sat, 13 Jul 2013 10:33:04 +0000
Message-ID: <2A7ABDFCE21540479A5AEB0244A684D5E3CE71@DNCE04.ent.ti.com>
References: <1372329818-12384-1-git-send-email-oleksandr.kozaruk@ti.com>
 <1372329818-12384-3-git-send-email-oleksandr.kozaruk@ti.com>,<20130713100307.GO25601@gmail.com>
In-Reply-To: <20130713100307.GO25601@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.92]
x-exclaimer-md-config: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

Thank you for the review. There is v3 of this patch. My bad I didn't put
it in reply to v1.
I'll address you comments in v4. Would you care to review v3, please.

Regards,
OK.

>> The GPADC is general purpose ADC found on TWL6030,
>> and TWL6032 PMIC, known also as Phoenix and PhoenixLite.
>>
>> The TWL6030 and TWL6032 have GPADC with 17 and 19
>> channels respectively. Some channels have current
>> source and are used for measuring voltage drop
>> on resistive load for detecting battery ID resistance,
>> or measuring voltage drop on NTC resistors for external
>> temperature measurements. Some channels measure voltage,
>> (i.e. battery voltage), and have voltage dividers,
>> thus, capable to scale voltage. Some channels are dedicated
>> for measuring die temperature.
>
>Can you use the full available width of the buffer please, either 72
>or 80 chars is normally fine.
>
>> Some channels are calibrated in 2 points, having
>> offsets from ideal values kept in trim registers. This
>> is used to correct measurements.
>>
>> The differences between GPADC in TWL6030 and TWL6032:
>> - 10 bit vs 12 bit ADC;
>> - 17 vs 19 channels;
>> - channels have different purpose(i. e. battery voltage
>
>Nit:                   No space here -^
>
>>   channel 8 vs channel 18);
>> - trim values are interpreted differently.
>>
>> The driver exports function returning converted value for
>> requested channels.
>>
>> Based on the driver patched from Balaji TK, Graeme Gregory, Ambresh K,
>> Girish S Ghongdemath.
>>
>> Signed-off-by: Balaji T K <balajitk@ti.com>
>> Graeme Gregory <gg@slimlogic.co.uk>
>
>SOB? RB? AB?
>
>> Signed-off-by: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>
>> ---
>>  .../testing/sysfs-devices-platform-twl6030_gpadc   |    5 +
>>  drivers/mfd/Kconfig                                |    8 +
>>  drivers/mfd/Makefile                               |    1 +
>>  drivers/mfd/twl6030-gpadc.c                        | 1053 ++++++++++++++++++++
>>  include/linux/i2c/twl6030-gpadc.h                  |   51 +
>
>Why here instead of include/linux/mfd?
>
>>  5 files changed, 1118 insertions(+)
>>  create mode 100644 Documentation/ABI/testing/sysfs-devices-platform-twl6030_gpadc
>>  create mode 100644 drivers/mfd/twl6030-gpadc.c
>>  create mode 100644 include/linux/i2c/twl6030-gpadc.h
>>
>> diff --git a/Documentation/ABI/testing/sysfs-devices-platform-twl6030_gpadc b/Documentation/ABI/testing/sysfs-devices-platform-twl6030_gpadc
>> new file mode 100644
>> index 0000000..e9c5812
>> --- /dev/null
>> +++ b/Documentation/ABI/testing/sysfs-devices-platform-twl6030_gpadc
>> @@ -0,0 +1,5 @@
>> +What:                /sys/bus/platform/devices/twl603X_gpadc.26/inX_channel
>
>Are you sure this is where they will be created?
>
>What's with the .26?
>
>> +Date:                June 2013
>> +Contact:     Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>
>> +Description: Start GPADC conversion for chosen channel X and report the result.
>> +             The result is returned in millivolts.
>
>Does this require Greg's Ack?
>
>> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
>> index d54e985..8eb7494 100644
>> --- a/drivers/mfd/Kconfig
>> +++ b/drivers/mfd/Kconfig
>> @@ -970,6 +970,14 @@ config MFD_TC3589X
>>         additional drivers must be enabled in order to use the
>>         functionality of the device.
>>
>> +config TWL6030_GPADC
>
>As this supports the TWL6030 and TWL6032, wouldn't it be better to use
>TWL603X. Same goes for the driver/header filenames.
>
>> +     tristate "TWL6030 GPADC (General Purpose A/D Convertor) Support"
>> +     depends on TWL4030_CORE
>> +     default n
>> +     help
>> +       Say yes here if you want support for the TWL6030 General Purpose
>> +       A/D Convertor.
>> +
>
>Any chance you can bundle this with the other TWL* variants instead of
>dumping it in an arbitrary location within the Kconfig file?
>
>>  config MFD_TMIO
>>       bool
>>       default n
>> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
>> index 718e94a..59f504f 100644
>> --- a/drivers/mfd/Makefile
>> +++ b/drivers/mfd/Makefile
>> @@ -70,6 +70,7 @@ obj-$(CONFIG_MENELAUS)              += menelaus.o
>>  obj-$(CONFIG_TWL4030_CORE)   += twl-core.o twl4030-irq.o twl6030-irq.o
>>  obj-$(CONFIG_TWL4030_MADC)      += twl4030-madc.o
>>  obj-$(CONFIG_TWL4030_POWER)    += twl4030-power.o
>> +obj-$(CONFIG_TWL6030_GPADC)    += twl6030-gpadc.o
>>  obj-$(CONFIG_MFD_TWL4030_AUDIO)      += twl4030-audio.o
>>  obj-$(CONFIG_TWL6040_CORE)   += twl6040.o
>>
>> diff --git a/drivers/mfd/twl6030-gpadc.c b/drivers/mfd/twl6030-gpadc.c
>> new file mode 100644
>> index 0000000..1868bc0
>> --- /dev/null
>> +++ b/drivers/mfd/twl6030-gpadc.c
>> @@ -0,0 +1,1053 @@
>> +/*
>> + * TWL6030 GPADC module driver
>> + *
>> + * Copyright (C) 2009-2013 Texas Instruments Inc.
>> + * Nishant Kamat <nskamat@ti.com>
>> + * Balaji T K <balajitk@ti.com>
>> + * Graeme Gregory <gg@slimlogic.co.uk>
>> + * Girish S Ghongdemath <girishsg@ti.com>
>> + * Ambresh K <ambresh@ti.com>
>> + * Oleksandr Kozaruk <oleksandr.kozaruk@ti.com
>> + *
>> + * Based on twl4030-madc.c
>> + * Copyright (C) 2008 Nokia Corporation
>> + * Mikko Ylinen <mikko.k.ylinen@nokia.com>
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License
>> + * version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but
>> + * WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> + * General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
>> + * 02110-1301 USA
>> + *
>> + */
>> +#include <linux/init.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/kernel.h>
>> +#include <linux/types.h>
>> +#include <linux/module.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/slab.h>
>> +#include <linux/hwmon-sysfs.h>
>> +#include <linux/of_platform.h>
>> +#include <linux/i2c/twl.h>
>> +#include <linux/i2c/twl6030-gpadc.h>
>> +
>> +#define DRIVER_NAME          "twl6030_gpadc"
>> +
>> +#define TWL6030_GPADC_MAX_CHANNELS 17
>> +#define TWL6032_GPADC_MAX_CHANNELS 19
>> +/* Define this as the biggest of all chips using this driver */
>> +#define GPADC_MAX_CHANNELS TWL6032_GPADC_MAX_CHANNELS
>> +
>> +#define TWL6030_GPADC_CTRL                   0x00    /* 0x2e */
>> +#define TWL6030_GPADC_CTRL2                  0x01    /* 0x2f */
>> +
>> +#define TWL6030_GPADC_RTSELECT_LSB           0x02    /* 0x30 */
>> +#define TWL6030_GPADC_RTSELECT_ISB           0x03
>> +#define TWL6030_GPADC_RTSELECT_MSB           0x04
>> +
>> +#define TWL6032_GPADC_RTSELECT_LSB           0x04    /* 0x32 */
>> +#define TWL6032_GPADC_RTSELECT_ISB           0x05
>> +#define TWL6032_GPADC_RTSELECT_MSB           0x06
>> +
>> +#define TWL6030_GPADC_CTRL_P1                        0x05
>> +#define TWL6030_GPADC_CTRL_P2                        0x06
>> +
>> +#define TWL6032_GPADC_GPSELECT_ISB           0x07
>> +#define TWL6032_GPADC_CTRL_P1                        0x08
>> +
>> +#define TWL6032_GPADC_RTCH0_LSB                      0x09
>> +#define TWL6032_GPADC_RTCH0_MSB                      0x0a
>> +#define TWL6032_GPADC_RTCH1_LSB                      0x0b
>> +#define TWL6032_GPADC_RTCH1_MSB                      0x0c
>> +#define TWL6032_GPADC_GPCH0_LSB                      0x0d
>> +#define TWL6032_GPADC_GPCH0_MSB                      0x0e
>> +
>> +#define TWL6030_GPADC_CTRL_P1_SP1            BIT(3)
>> +#define TWL6030_GPADC_CTRL_P1_EOCRT          BIT(2)
>> +#define TWL6030_GPADC_CTRL_P1_EOCP1          BIT(1)
>> +#define TWL6030_GPADC_CTRL_P1_BUSY           BIT(0)
>> +
>> +#define TWL6030_GPADC_CTRL_P2_SP2            BIT(2)
>> +#define TWL6030_GPADC_CTRL_P2_EOCP2          BIT(1)
>> +#define TWL6030_GPADC_CTRL_P1_BUSY           BIT(0)
>> +
>> +#define TWL6030_GPADC_EOC_SW                 BIT(1)
>> +#define TWL6030_GPADC_BUSY                   BIT(0)
>> +
>> +#define TWL6030_GPADC_RTCH0_LSB                      (0x07)
>> +#define TWL6030_GPADC_GPCH0_LSB                      (0x29)
>> +
>> +/* Fixed channels */
>> +#define TWL6030_GPADC_CTRL_TEMP1_EN          BIT(0)    /* input ch 1 */
>> +#define TWL6030_GPADC_CTRL_TEMP2_EN          BIT(1)    /* input ch 4 */
>> +#define TWL6030_GPADC_CTRL_SCALER_EN         BIT(2)    /* input ch 2 */
>> +#define TWL6030_GPADC_CTRL_SCALER_DIV4               BIT(3)
>> +#define TWL6030_GPADC_CTRL_SCALER_EN_CH11    BIT(4)    /* input ch 11 */
>> +#define TWL6030_GPADC_CTRL_TEMP1_EN_MONITOR  BIT(5)
>> +#define TWL6030_GPADC_CTRL_TEMP2_EN_MONITOR  BIT(6)
>> +#define TWL6030_GPADC_CTRL_ISOURCE_EN                BIT(7)
>> +
>> +#define TWL6030_GPADC_CTRL2_REMSENSE_0               BIT(0)
>> +#define TWL6030_GPADC_CTRL2_REMSENSE_1               BIT(1)
>> +#define TWL6030_GPADC_CTRL2_SCALER_EN_CH18   BIT(2)
>> +#define TWL6030_GPADC_CTRL2_VBAT_SCALER_DIV4 BIT(3)
>> +
>> +#define TWL6030_GPADC_RT_SW1_EOC_MASK                BIT(5)
>> +#define TWL6030_GPADC_SW2_EOC_MASK           BIT(6)
>> +
>> +#define TWL6032_GPADC_RT_EOC_MASK            BIT(4)
>> +#define TWL6032_GPADC_SW_EOC_MASK            BIT(5)
>> +
>> +#define TWL6030_GPADC_TRIM1                  0xCD
>> +
>> +#define TWL6030_REG_TOGGLE1                  0x90
>> +#define TWL6030_GPADCS                               BIT(1)
>> +#define TWL6030_GPADCR                               BIT(0)
>
>Any chance we can rid this lot into a header file somewhere?
>
>> +/**
>> + * struct twl6030_chnl_calib - channel calibration
>> + * @gain:            slope coefficient for ideal curve
>> + * @gain_error:              gain error
>> + * @offset_error:    offset of the real curve
>> + */
>> +struct twl6030_chnl_calib {
>> +     s32 gain;
>> +     s32 gain_error;
>> +     s32 offset_error;
>> +};
>> +
>> +/**
>> + * struct twl6030_ideal_code - GPADC calibration parameters
>> + * GPADC is calibrated in two points: at the beginning and
>> + * at the and of the measurable input range
>> + *
>> + * @code1:   ideal code for the input at the beginning
>> + * @code2:   ideal code for at the end of the range
>> + * @v1:              voltage input at the beginning(low voltage)
>> + * @v2:              voltage input at the end(high voltage)
>> + */
>> +struct twl6030_ideal_code {
>> +     s16 code1;
>> +     s16 code2;
>> +     s16 v1;
>> +     s16 v2;
>> +};
>
>The variable name choices used throughout this driver make it
>incredibly hard to read. Variable names like; d, x, v1, v2 etc are
>undecipherable when read in as function arguments, then used in some
>random equation. I'll provide examples later.
>
>Perhaps 'code' would be better read as '[raw|read|register]_value', if
>that's what it actually is. 'v' would be better understood if it was
>'voltage', or at least 'volt'. The '1' and '2' here should be replaced
>by 'start' and 'end' or similar too.
>
>> +struct twl6030_gpadc_data;
>> +
>> +/**
>> + * struct twl6030_gpadc_platform_data - platform specific data
>> + * @nchannels:               number of GPADC channels
>> + * @twl6030_ideal:   pointer to calibration parameters
>> + * @convert:         pointer to ADC conversion function
>> + * @calibrate:               pointer to calibration function
>> + */
>> +struct twl6030_gpadc_platform_data {
>> +     const int nchannels;
>> +     const struct twl6030_ideal_code *ideal;
>> +     int (*convert)(u32 channels, struct twl6030_gpadc_result *res);
>> +     int (*calibrate)(struct twl6030_gpadc_data *gpadc);
>> +};
>
>Is this actually platform data, or is it really device data?
>
>> +/**
>> + * struct twl6030_gpadc_data - GPADC data
>> + * @dev:             device pointer
>> + * @lock:            mutual exclusion lock for the structure
>> + * @irq_complete:    completion to signal end of conversion
>> + * @twl6030_cal_tbl: pointer to calibration data for each
>> + *                   channel with gain error and offset
>> + * @pdata:           pointer to device specific data
>
>... ah, so it's device data then? Calling it pdata, is misleading.
>
>> + */
>> +struct twl6030_gpadc_data {
>> +     struct device   *dev;
>> +     struct mutex    lock;
>> +     struct completion       irq_complete;
>> +     struct twl6030_chnl_calib       *twl6030_cal_tbl;
>> +     const struct twl6030_gpadc_platform_data *pdata;
>> +};
>> +
>> +static struct twl6030_gpadc_data *the_gpadc;
>
>This doesn't need to be global - see below.
>
>> +/*
>> + * channels 11, 12, 13, 15 and 16 have no calibration data
>> + * calibration offset is same for channels 1, 3, 4, 5
>> + */
>> +static const struct twl6030_ideal_code
>> +     twl6030_ideal[TWL6030_GPADC_MAX_CHANNELS] = {
>> +     { /* ch 0, external, battery type, resistor value */
>> +             .code1 = 116,
>> +             .code2 = 745,
>> +             .v1 = 141,
>> +             .v2 = 910,
>> +     },
>
>Care to elaborate on where these figures came from?
>
>> +     { /* ch 1, external, battery temperature, NTC resistor value */
>> +             .code1 = 82,
>> +             .code2 = 900,
>> +             .v1 = 100,
>> +             .v2 = 1100,
>> +     },
>> +     { /* ch 2, external, audio accessory/general purpose */
>> +             .code1 = 55,
>> +             .code2 = 818,
>> +             .v1 = 101,
>> +             .v2 = 1499,
>> +     },
>> +     { /* ch 3, external, general purpose */
>> +             .code1 = 82,
>> +             .code2 = 900,
>> +             .v1 = 100,
>> +             .v2 = 1100,
>> +     },
>> +     { /* ch 4, external, temperature measurement/general purpose */
>> +             .code1 = 82,
>> +             .code2 = 900,
>> +             .v1 = 100,
>> +             .v2 = 1100,
>> +     },
>> +     { /* ch 5, external, general purpose */
>> +             .code1 = 82,
>> +             .code2 = 900,
>> +             .v1 = 100,
>> +             .v2 = 1100,
>> +     },
>> +     { /* ch 6, external, general purpose */
>> +             .code1 = 82,
>> +             .code2 = 900,
>> +             .v1 = 100,
>> +             .v2 = 1100,
>> +     },
>> +     { /* ch 7, internal, main battery */
>> +             .code1 = 614,
>> +             .code2 = 941,
>> +             .v1 = 3001,
>> +             .v2 = 4599,
>> +     },
>> +     { /* ch 8, internal, backup battery */
>> +             .code1 = 82,
>> +             .code2 = 688,
>> +             .v1 = 501,
>> +             .v2 = 4203,
>> +     },
>> +     { /* ch 9, internal, external charger input */
>> +             .code1 = 182,
>> +             .code2 = 818,
>> +             .v1 = 2001,
>> +             .v2 = 8996,
>> +     },
>> +     { /* ch 10, internal, VBUS */
>> +             .code1 = 149,
>> +             .code2 = 818,
>> +             .v1 = 1001,
>> +             .v2 = 5497,
>> +     },
>> +     {},     /* ch 11, internal, VBUS charging current */
>> +     {},     /* ch 12, internal, Die temperature */
>> +     {},     /* ch 13, internal, Die temperature */
>> +     { /* ch 14, internal, USB ID line */
>> +             .code1 = 48,
>> +             .code2 = 714,
>> +             .v1 = 323,
>> +             .v2 = 4800,
>> +     },
>> +     {},     /* ch 15, internal, test network */
>> +     {},     /* ch 16, internal, test network */
>> +};
>> +
>> +static const struct twl6030_ideal_code
>> +                     twl6032_ideal[TWL6032_GPADC_MAX_CHANNELS] = {
>> +     { /* ch 0, external, battery type, resistor value */
>> +             .code1 = 1441,
>> +             .code2 = 3276,
>> +             .v1 = 440,
>> +             .v2 = 1000,
>> +     },
>> +     { /* ch 1, external, battery temperature, NTC resistor value */
>> +             .code1 = 1441,
>> +             .code2 = 3276,
>> +             .v1 = 440,
>> +             .v2 = 1000,
>> +     },
>> +     { /* ch 2, external, audio accessory/general purpose */
>> +             .code1 = 1441,
>> +             .code2 = 3276,
>> +             .v1 = 660,
>> +             .v2 = 1500,
>> +     },
>> +     { /* ch 3, external, temperature with external diode/general purpose */
>> +             .code1 = 1441,
>> +             .code2 = 3276,
>> +             .v1 = 440,
>> +             .v2 = 1000,
>> +     },
>> +     { /* ch 4, external, temperature measurement/general purpose */
>> +             .code1 = 1441,
>> +             .code2 = 3276,
>> +             .v1 = 440,
>> +             .v2 = 1000,
>> +     },
>> +     { /* ch 5, external, general purpose */
>> +             .code1 = 1441,
>> +             .code2 = 3276,
>> +             .v1 = 440,
>> +             .v2 = 1000,
>> +     },
>> +     { /* ch 6, external, general purpose */
>> +             .code1 = 1441,
>> +             .code2 = 3276,
>> +             .v1 = 440,
>> +             .v2 = 1000,
>> +     },
>> +     { /* ch7, internal, system supply */
>> +             .code1 = 1441,
>> +             .code2 = 3276,
>> +             .v1 = 2200,
>> +             .v2 = 5000,
>> +     },
>> +     { /* ch8, internal, backup battery */
>> +             .code1 = 1441,
>> +             .code2 = 3276,
>> +             .v1 = 2200,
>> +             .v2 = 5000,
>> +     },
>> +     { /* ch 9, internal, external charger input */
>> +             .code1 = 1441,
>> +             .code2 = 3276,
>> +             .v1 = 3960,
>> +             .v2 = 9000,
>> +     },
>> +     { /* ch10, internal, VBUS */
>> +             .code1 = 150,
>> +             .code2 = 751,
>> +             .v1 = 1000,
>> +             .v2 = 5000,
>> +     },
>> +     { /* ch 11, internal, VBUS DC-DC output current */
>> +             .code1 = 1441,
>> +             .code2 = 3276,
>> +             .v1 = 660,
>> +             .v2 = 1500,
>> +     },
>> +     { /* ch 12, internal, Die temperature */
>> +             .code1 = 1441,
>> +             .code2 = 3276,
>> +             .v1 = 440,
>> +             .v2 = 1000,
>> +     },
>> +     { /* ch 13, internal, Die temperature */
>> +             .code1 = 1441,
>> +             .code2 = 3276,
>> +             .v1 = 440,
>> +             .v2 = 1000,
>> +     },
>> +     { /* ch 14, internal, USB ID line */
>> +             .code1 = 1441,
>> +             .code2 = 3276,
>> +             .v1 = 2420,
>> +             .v2 = 5500,
>> +     },
>> +     {},     /* ch 15, internal, test network */
>> +     {},     /* ch 16, internal, test network */
>> +     {},     /* ch 17, internal, battery charging current */
>> +     { /* ch 18, internal, battery voltage */
>> +             .code1 = 1441,
>> +             .code2 = 3276,
>> +             .v1 = 2200,
>> +             .v2 = 5000,
>> +     },
>> +};
>> +
>> +static int twl6030_gpadc_read(struct twl6030_gpadc_data *gpadc, u8 reg)
>> +{
>> +     int ret;
>> +     u8 val = 0;
>> +
>> +     ret = twl_i2c_read_u8(TWL6030_MODULE_GPADC, &val, reg);
>> +     if (ret) {
>> +             dev_dbg(gpadc->dev, "unable to read register 0x%X\n", reg);
>> +             return ret;
>> +     }
>> +
>> +     return val;
>> +}
>> +
>> +static int twl6030_gpadc_write(u8 reg, u8 val)
>> +{
>> +     return twl_i2c_write_u8(TWL6030_MODULE_GPADC, val, reg);
>> +}
>> +
>> +static int twl6030_gpadc_channel_raw_read(struct twl6030_gpadc_data *gpadc,
>> +                                       u8 reg)
>> +{
>> +     u8 msb, lsb;
>> +
>> +     msb = twl6030_gpadc_read(gpadc, reg + 1);
>> +     lsb = twl6030_gpadc_read(gpadc, reg);
>> +
>> +     return (msb << 8) | lsb;
>> +}
>> +
>> +static int twl6030_gpadc_enable_irq(u8 mask)
>> +{
>> +     int ret;
>> +
>> +     ret = twl6030_interrupt_unmask(mask, REG_INT_MSK_LINE_B);
>> +     ret |= twl6030_interrupt_unmask(mask, REG_INT_MSK_STS_B);
>> +
>> +     return ret;
>> +}
>> +
>> +static void twl6030_gpadc_disable_irq(u8 mask)
>> +{
>> +     twl6030_interrupt_mask(mask, REG_INT_MSK_LINE_B);
>> +     twl6030_interrupt_mask(mask, REG_INT_MSK_STS_B);
>> +}
>> +
>> +static irqreturn_t twl6030_gpadc_irq_handler(int irq, void *_gpadc)
>> +{
>> +     struct twl6030_gpadc_data *gpadc = _gpadc;
>> +
>> +     complete(&gpadc->irq_complete);
>> +
>> +     return IRQ_HANDLED;
>> +}
>> +
>> +static int twl6030_channel_calibrated(const struct twl6030_gpadc_platform_data
>> +                                     *pdata, int channel)
>> +{
>> +     /* not calibrated channels have 0 in all structure members */
>> +     return pdata->ideal[channel].code2;
>> +}
>> +
>> +static void twl6030_gpadc_read_channel(struct twl6030_gpadc_data *gpadc,
>> +             int channel, u8 reg, struct twl6030_gpadc_result *res)
>> +{
>> +     s32 raw_code;
>> +     s32 corrected_code;
>> +     int channel_value;
>> +
>> +     raw_code = twl6030_gpadc_channel_raw_read(gpadc, reg);
>> +
>> +     res->raw_code = raw_code;
>> +
>> +     if (!twl6030_channel_calibrated(gpadc->pdata, channel)) {
>> +             corrected_code = raw_code;
>> +             channel_value = raw_code;
>> +     } else {
>> +             corrected_code = ((raw_code * 1000) -
>> +                     gpadc->twl6030_cal_tbl[channel].offset_error) /
>> +                     gpadc->twl6030_cal_tbl[channel].gain_error;
>
>Can you add a small comment to describe what you're doing here?
>
>> +
>> +             channel_value = corrected_code *
>> +                             gpadc->twl6030_cal_tbl[channel].gain;
>
>... and here.
>
>> +             /* Shift back into mV range */
>> +             channel_value /= 1000;
>> +     }
>> +
>> +     dev_dbg(gpadc->dev, "GPADC raw: %d", raw_code);
>> +     dev_dbg(gpadc->dev, "GPADC cor: %d", corrected_code);
>> +     dev_dbg(gpadc->dev, "GPADC val: %d", channel_value);
>
>Odd that the debug prints are _less_ verbose than the variable names.
>
>> +     res->corrected_code = corrected_code;
>> +     res->result = channel_value;
>> +}
>> +
>> +static void twl6030_gpadc_get_results(u8 reg, u32 channels,
>> +                             struct twl6030_gpadc_result *res)
>> +{
>> +     int i;
>> +
>> +     for (i = 0; i < TWL6030_GPADC_MAX_CHANNELS; i++) {
>> +
>> +             if (!(channels & BIT(i)))
>> +                     continue;
>> +
>> +             reg += 2 * i;
>> +             twl6030_gpadc_read_channel(the_gpadc, i, reg, &res[i]);
>> +     }
>> +}
>> +
>> +/* locks held by caller */
>> +static int _twl6030_gpadc_conversion(u32 channels,
>> +                             struct twl6030_gpadc_result *res)
>> +{
>> +     int ret;
>> +
>> +     /* start conversion */
>> +     ret = twl6030_gpadc_write(TWL6030_GPADC_CTRL_P1,
>> +                                     TWL6030_GPADC_CTRL_P1_SP1);
>> +     if (ret) {
>> +             pr_err("%s: failed to write\n", __func__);
>> +             return ret;
>> +     }
>> +
>> +     /* wait for conversion to complete */
>> +     wait_for_completion_interruptible_timeout(&the_gpadc->irq_complete,
>> +                                             msecs_to_jiffies(5000));
>> +
>> +     /* get the results */
>> +     twl6030_gpadc_get_results(TWL6030_GPADC_GPCH0_LSB, channels, res);
>> +
>> +     return ret;
>> +}
>
>Why do the two *_gpadc_conversion() functions vastly differ semantically?
>
>> +/* locks held by caller */
>> +static int _twl6032_gpadc_conversion(u32 channels,
>> +                             struct twl6030_gpadc_result *res)
>> +{
>> +     int i;
>> +     int ret;
>> +
>> +     for (i = 0; i < TWL6032_GPADC_MAX_CHANNELS; i++) {
>> +             if (!(channels & BIT(i)))
>> +                     continue;
>> +
>> +             /* select the ADC channel to read */
>> +             ret = twl6030_gpadc_write(TWL6032_GPADC_GPSELECT_ISB, i);
>> +             if (ret)
>> +                     goto out;
>> +
>> +             /* start conversion */
>> +             ret = twl6030_gpadc_write(TWL6032_GPADC_CTRL_P1,
>> +                                             TWL6030_GPADC_CTRL_P1_SP1);
>> +             if (ret)
>> +                     goto out;
>> +
>> +             /* wait for conversion to complete */
>> +             wait_for_completion_interruptible_timeout(
>> +                     &the_gpadc->irq_complete, msecs_to_jiffies(5000));
>> +
>> +             twl6030_gpadc_read_channel(the_gpadc, i,
>> +                                     TWL6032_GPADC_GPCH0_LSB, &res[i]);
>> +     }
>> +
>> +     return ret;
>> +out:
>> +     pr_err("%s: failed to write\n", __func__);
>> +     return ret;
>> +}
>> +
>> +int twl6030_gpadc_conversion(u32 channels, struct twl6030_gpadc_result *buf)
>> +{
>> +     struct twl6030_gpadc_data *gpadc = the_gpadc;
>> +     int ret;
>> +
>> +     if (!gpadc)
>> +             return -EAGAIN;
>
>Why EAGAIN? Will 'the_gpadc' appear _later_?
>
>> +     mutex_lock(&gpadc->lock);
>> +
>> +     ret = gpadc->pdata->convert(channels, buf);
>> +
>> +     mutex_unlock(&the_gpadc->lock);
>> +
>> +     return ret;
>> +}
>> +EXPORT_SYMBOL(twl6030_gpadc_conversion);
>> +
>> +static ssize_t show_channel(struct device *dev,
>> +             struct device_attribute *devattr, char *buf)
>> +{
>> +     struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
>> +     struct twl6030_gpadc_result res[GPADC_MAX_CHANNELS];
>> +     u32 channel = (1 << attr->index);
>
>Can we use BIT() again for the sake of consistency?
>
>> +     int ret;
>> +
>> +     ret = twl6030_gpadc_conversion(channel, res);
>> +     if (ret)
>> +             return ret;
>> +
>> +     return sprintf(buf, "%d\n", res[attr->index].result);
>> +}
>> +
>> +#define in_channel(index) \
>> +static SENSOR_DEVICE_ATTR(in##index##_channel, S_IRUGO, show_channel, \
>> +     NULL, index);
>> +
>> +in_channel(0);
>> +in_channel(1);
>> +in_channel(2);
>> +in_channel(3);
>> +in_channel(4);
>> +in_channel(5);
>> +in_channel(6);
>> +in_channel(7);
>> +in_channel(8);
>> +in_channel(9);
>> +in_channel(10);
>> +in_channel(11);
>> +in_channel(12);
>> +in_channel(13);
>> +in_channel(14);
>> +in_channel(15);
>> +in_channel(16);
>> +in_channel(17);
>> +in_channel(18);
>> +
>> +#define IN_ATTRS_CHANNEL(X) (&sensor_dev_attr_in##X##_channel.dev_attr.attr)
>> +
>> +/*
>> + * the number of attributes is chosen as for a device with
>> + * max number of channels. It will be truncated before sysfs entries
>> + * are created on probe.
>> + */
>> +static struct attribute *twl6030_gpadc_attributes[] = {
>> +     IN_ATTRS_CHANNEL(0),
>> +     IN_ATTRS_CHANNEL(1),
>> +     IN_ATTRS_CHANNEL(2),
>> +     IN_ATTRS_CHANNEL(3),
>> +     IN_ATTRS_CHANNEL(4),
>> +     IN_ATTRS_CHANNEL(5),
>> +     IN_ATTRS_CHANNEL(6),
>> +     IN_ATTRS_CHANNEL(7),
>> +     IN_ATTRS_CHANNEL(8),
>> +     IN_ATTRS_CHANNEL(9),
>> +     IN_ATTRS_CHANNEL(10),
>> +     IN_ATTRS_CHANNEL(11),
>> +     IN_ATTRS_CHANNEL(12),
>> +     IN_ATTRS_CHANNEL(13),
>> +     IN_ATTRS_CHANNEL(14),
>> +     IN_ATTRS_CHANNEL(15),
>> +     IN_ATTRS_CHANNEL(16),
>> +     IN_ATTRS_CHANNEL(17),
>> +     IN_ATTRS_CHANNEL(18),
>> +     NULL
>> +};
>> +
>> +static const struct attribute_group twl6030_gpadc_group = {
>> +     .attrs = twl6030_gpadc_attributes,
>> +};
>> +
>> +static void twl6030_calibrate_channel(struct twl6030_gpadc_data *gpadc,
>> +                                     int channel, int d1, int d2)
>> +{
>> +     int b, k, gain, x1, x2;
>> +     const struct twl6030_ideal_code *ideal = gpadc->pdata->ideal;
>> +
>> +     /* Gain */
>> +     gain = ((ideal[channel].v2 - ideal[channel].v1) * 1000) /
>> +             (ideal[channel].code2 - ideal[channel].code1);
>> +
>> +     x1 = ideal[channel].code1;
>> +     x2 = ideal[channel].code2;
>> +
>> +     /* k */
>> +     k = 1000 + (((d2 - d1) * 1000) / (x2 - x1));
>> +
>> +     /* b */
>> +     b = (d1 * 1000) - (k - 1000) * x1;
>
>This function is pure craziness. A viewer should be able to decipher
>what a function is doing without tracing back the source of each
>variable. Better variable naming conventions and/or more verbose
>commenting is required here. The equations also need better (or at
>least some) explanation.
>
>> +     gpadc->twl6030_cal_tbl[channel].gain = gain;
>> +     gpadc->twl6030_cal_tbl[channel].gain_error = k;
>> +     gpadc->twl6030_cal_tbl[channel].offset_error = b;
>> +
>> +     dev_dbg(gpadc->dev, "GPADC d1   for Chn: %d = %d\n", channel, d1);
>> +     dev_dbg(gpadc->dev, "GPADC d2   for Chn: %d = %d\n", channel, d2);
>> +     dev_dbg(gpadc->dev, "GPADC x1   for Chn: %d = %d\n", channel, x1);
>> +     dev_dbg(gpadc->dev, "GPADC x2   for Chn: %d = %d\n", channel, x2);
>> +     dev_dbg(gpadc->dev, "GPADC Gain for Chn: %d = %d\n", channel, gain);
>> +     dev_dbg(gpadc->dev, "GPADC k    for Chn: %d = %d\n", channel, k);
>> +     dev_dbg(gpadc->dev, "GPADC b    for Chn: %d = %d\n", channel, b);
>> +}
>> +
>> +static inline int twl6030_gpadc_get_trim_offset(s8 d)
>> +{
>> +     int sign;
>> +
>> +     /*
>> +      * XXX NOTE!
>> +      * bit 0 - sign, bit 7 - reserved, 6..1 - trim value
>> +      * though, the documentation states that trim value
>> +      * is absolute value, the correct conversion results are
>> +      * obtained if the value is interpreted as 2's complement.
>> +      */
>> +     sign = d & 1;
>> +     d = (d & 0x7f) >> 1;
>> +
>> +     return sign ? (d | 0xc0) : d;
>> +}
>> +
>> +static int twl6030_calibration(struct twl6030_gpadc_data *gpadc)
>> +{
>> +     int ret;
>> +     int chn;
>> +     u8 trim_regs[TWL6030_GPADC_MAX_CHANNELS];
>> +     s8 d1, d2;
>> +
>> +     /*
>> +      * for calibration two measurements have been performed at
>> +      * factory, for some channels, during the production test and
>> +      * have been stored in registers. This two stored values are
>> +      * used to correct the measurements. The values represent
>> +      * offsets for the given input from the output on ideal curve.
>> +      */
>> +     ret = twl_i2c_read(TWL6030_MODULE_ID2, trim_regs,
>> +                     TWL6030_GPADC_TRIM1, 16);
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     for (chn = 0; chn < TWL6030_GPADC_MAX_CHANNELS; chn++) {
>> +
>> +             switch (chn) {
>> +             case 0:
>> +                     d1 = trim_regs[0];
>> +                     d2 = trim_regs[1];
>> +                     break;
>> +             case 1:
>> +                     d1 = trim_regs[4];
>> +                     d2 = trim_regs[5];
>> +                     break;
>> +             case 2:
>> +                     d1 = trim_regs[12];
>> +                     d2 = trim_regs[13];
>> +                     break;
>> +             case 3:
>> +             case 4:
>> +             case 5:
>> +             case 6:
>> +                     d1 = trim_regs[4];
>> +                     d2 = trim_regs[5];
>> +                     break;
>> +             case 7:
>> +                     d1 = trim_regs[6];
>> +                     d2 = trim_regs[7];
>> +                     break;
>> +             case 8:
>> +                     d1 = trim_regs[2];
>> +                     d2 = trim_regs[3];
>> +                     break;
>> +             case 9:
>> +                     d1 = trim_regs[8];
>> +                     d2 = trim_regs[9];
>> +                     break;
>> +             case 10:
>> +                     d1 = trim_regs[10];
>> +                     d2 = trim_regs[11];
>> +                     break;
>> +             case 14:
>> +                     d1 = trim_regs[14];
>> +                     d2 = trim_regs[15];
>> +                     break;
>> +             default:
>> +                     continue;
>> +             }
>> +
>> +             d1 = twl6030_gpadc_get_trim_offset(d1);
>> +             d2 = twl6030_gpadc_get_trim_offset(d2);
>> +
>> +             twl6030_calibrate_channel(gpadc, chn, d1, d2);
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +static int twl6032_calibration(struct twl6030_gpadc_data *gpadc)
>> +{
>> +     int chn, d1 = 0, d2 = 0, temp;
>> +     u8 trim_regs[17];
>> +     int ret;
>> +
>> +     ret = twl_i2c_read(TWL6030_MODULE_ID2, trim_regs + 1,
>> +                     TWL6030_GPADC_TRIM1, 16);
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     /* Loop to calculate the value needed for returning voltages from
>> +      * GPADC not values.
>> +      *
>> +      * gain is calculated to 3 decimal places fixed point.
>> +      */
>
>Please read:
>
>"The preferred style for long (multi-line) comments is:"
>
>in Documentation/CodingStyle.
>
>> +     for (chn = 0; chn < TWL6032_GPADC_MAX_CHANNELS; chn++) {
>> +
>> +             switch (chn) {
>> +             case 0:
>> +             case 1:
>> +             case 2:
>> +             case 3:
>> +             case 4:
>> +             case 5:
>> +             case 6:
>> +             case 11:
>> +             case 12:
>> +             case 13:
>> +             case 14:
>> +                     /* D1 */
>> +                     d1 = (trim_regs[3] & 0x1F) << 2;
>> +                     d1 |= (trim_regs[1] & 0x06) >> 1;
>> +                     if (trim_regs[1] & 0x01)
>> +                             d1 = -d1;
>> +
>> +                     /* D2 */
>> +                     d2 = (trim_regs[4] & 0x3F) << 2;
>> +                     d2 |= (trim_regs[2] & 0x06) >> 1;
>> +                     if (trim_regs[2] & 0x01)
>> +                             d2 = -d2;
>> +                     break;
>> +             case 8:
>> +                     /* D1 */
>> +                     temp = (trim_regs[3] & 0x1F) << 2;
>> +                     temp |= (trim_regs[1] & 0x06) >> 1;
>> +                     if (trim_regs[1] & 0x01)
>> +                             temp = -temp;
>> +
>> +                     d1 = (trim_regs[8] & 0x18) << 1;
>> +                     d1 |= (trim_regs[7] & 0x1E) >> 1;
>> +                     if (trim_regs[7] & 0x01)
>> +                             d1 = -d1;
>> +
>> +                     d1 += temp;
>> +
>> +                     /* D2 */
>> +                     temp = (trim_regs[4] & 0x3F) << 2;
>> +                     temp |= (trim_regs[2] & 0x06) >> 1;
>> +                     if (trim_regs[2] & 0x01)
>> +                             temp = -temp;
>> +
>> +                     d2 = (trim_regs[10] & 0x1F) << 2;
>> +                     d2 |= (trim_regs[8] & 0x06) >> 1;
>> +                     if (trim_regs[8] & 0x01)
>> +                             d2 = -d2;
>> +
>> +                     d2 += temp;
>> +                     break;
>> +             case 9:
>> +                     /* D1 */
>> +                     temp = (trim_regs[3] & 0x1F) << 2;
>> +                     temp |= (trim_regs[1] & 0x06) >> 1;
>> +                     if (trim_regs[1] & 0x01)
>> +                             temp = -temp;
>> +
>> +                     d1 = (trim_regs[14] & 0x18) << 1;
>> +                     d1 |= (trim_regs[12] & 0x1E) >> 1;
>> +                     if (trim_regs[12] & 0x01)
>> +                             d1 = -d1;
>> +
>> +                     d1 += temp;
>> +
>> +                     /* D2 */
>> +                     temp = (trim_regs[4] & 0x3F) << 2;
>> +                     temp |= (trim_regs[2] & 0x06) >> 1;
>> +                     if (trim_regs[2] & 0x01)
>> +                             temp = -temp;
>> +
>> +                     d2 = (trim_regs[16] & 0x1F) << 2;
>> +                     d2 |= (trim_regs[14] & 0x06) >> 1;
>> +                     if (trim_regs[14] & 0x01)
>> +                             d2 = -d2;
>> +
>> +                     d2 += temp;
>> +             case 10:
>> +                     /* D1 */
>> +                     d1 = (trim_regs[11] & 0x0F) << 3;
>> +                     d1 |= (trim_regs[9] & 0x0E) >> 1;
>> +                     if (trim_regs[9] & 0x01)
>> +                             d1 = -d1;
>> +
>> +                     /* D2 */
>> +                     d2 = (trim_regs[15] & 0x0F) << 3;
>> +                     d2 |= (trim_regs[13] & 0x0E) >> 1;
>> +                     if (trim_regs[13] & 0x01)
>> +                             d2 = -d2;
>> +                     break;
>> +             case 7:
>> +             case 18:
>> +                     /* D1 */
>> +                     temp = (trim_regs[3] & 0x1F) << 2;
>> +                     temp |= (trim_regs[1] & 0x06) >> 1;
>> +                     if (trim_regs[1] & 0x01)
>> +                             temp = -temp;
>> +
>> +                     d1 = (trim_regs[5] & 0x7E) >> 1;
>> +                     if (trim_regs[5] & 0x01)
>> +                             d1 = -d1;
>> +
>> +                     d1 += temp;
>> +
>> +                     /* D2 */
>> +                     temp = (trim_regs[4] & 0x3F) << 2;
>> +                     temp |= (trim_regs[2] & 0x06) >> 1;
>> +                     if (trim_regs[2] & 0x01)
>> +                             temp = -temp;
>> +
>> +                     d2 = (trim_regs[6] & 0xFE) >> 1;
>> +                     if (trim_regs[6] & 0x01)
>> +                             d2 = -d2;
>> +
>> +                     d2 += temp;
>> +                     break;
>
>I think more explanation surrounding the equation(s) is required.
>
>> +             default:
>> +                     /* No data for other channels */
>> +                     continue;
>> +             }
>> +
>> +             twl6030_calibrate_channel(gpadc, chn, d1, d2);
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +static const struct twl6030_gpadc_platform_data twl6030_pdata = {
>> +     .nchannels = TWL6030_GPADC_MAX_CHANNELS,
>> +     .ideal = twl6030_ideal,
>> +     .convert = _twl6030_gpadc_conversion,
>> +     .calibrate = twl6030_calibration,
>> +};
>> +
>> +static const struct twl6030_gpadc_platform_data twl6032_pdata = {
>> +     .nchannels = TWL6032_GPADC_MAX_CHANNELS,
>> +     .ideal = twl6032_ideal,
>> +     .convert = _twl6032_gpadc_conversion,
>> +     .calibrate = twl6032_calibration,
>> +};
>> +
>> +static struct of_device_id of_twl6030_match_tbl[] = {
>> +     {
>> +             .compatible = "ti,twl6030_gpadc",
>> +             .data = &twl6030_pdata,
>> +     },
>> +     {
>> +             .compatible = "ti,twl6032_gpadc",
>> +             .data = &twl6032_pdata,
>> +     },
>> +     { /* end */ }
>> +};
>> +
>> +static int twl6030_gpadc_probe(struct platform_device *pdev)
>> +{
>> +     struct device *dev = &pdev->dev;
>> +     struct twl6030_gpadc_data *gpadc;
>> +     const struct twl6030_gpadc_platform_data *pdata;
>> +     const struct of_device_id *match;
>> +     int irq;
>> +     int ret = 0;
>
>There's no requirement to initialise ret here.
>
>> +     match = of_match_device(of_match_ptr(of_twl6030_match_tbl), dev);
>> +     pdata = match ? match->data : dev->platform_data;
>
>The twl6040 just went DT only. Is this the case for the twl6030x too?
>
>If so, can you remove pdata support.
>
>
>> +     if (!pdata)
>> +             return -EINVAL;
>> +
>> +     gpadc = devm_kzalloc(dev, sizeof(struct twl6030_gpadc_data),
>> +                             GFP_KERNEL);
>> +     if (!gpadc)
>> +             return -ENOMEM;
>> +
>> +     gpadc->twl6030_cal_tbl = devm_kzalloc(dev,
>> +                                     sizeof(struct twl6030_chnl_calib) *
>> +                                     pdata->nchannels, GFP_KERNEL);
>> +     if (!gpadc->twl6030_cal_tbl)
>> +             return -ENOMEM;
>> +
>> +     the_gpadc = gpadc;
>
>What's the point in this? Why not use 'the_gpadc' immediately?
>
>> +     gpadc->dev = dev;
>> +     gpadc->pdata = pdata;
>> +
>> +     platform_set_drvdata(pdev, gpadc);
>
>So you've made 'the_gpadc' global to maintain access to your core
>information, then set it as drvdata in any case? Why not remove the
>needlessly global and weirdly named 'the_gpadc' and use
>platform_get_drvdata to fetch the information when you require it?
>
>> +     mutex_init(&gpadc->lock);
>> +     init_completion(&gpadc->irq_complete);
>> +
>> +     ret = pdata->calibrate(gpadc);
>> +     if (ret < 0) {
>> +             dev_err(&pdev->dev, "Failed to read calibration registers\n");
>> +             return ret;
>> +     }
>> +
>> +     irq = platform_get_irq(pdev, 0);
>> +     if (irq < 0) {
>> +             dev_err(&pdev->dev, "failed to get irq\n");
>> +             return ret;
>> +     }
>> +
>> +     ret = devm_request_threaded_irq(dev, irq, NULL,
>> +                                     twl6030_gpadc_irq_handler,
>> +                                     IRQF_ONESHOT, "twl6030_gpadc", gpadc);
>> +     if (ret) {
>> +             dev_dbg(&pdev->dev, "could not request irq\n");
>> +             return ret;
>> +     }
>> +
>> +     ret = twl6030_gpadc_enable_irq(TWL6030_GPADC_RT_SW1_EOC_MASK);
>> +     if (ret < 0) {
>> +             dev_err(&pdev->dev, "Failed to enable GPADC interrupt\n");
>> +             return ret;
>> +     }
>
>New line here please.
>
>> +     ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, TWL6030_GPADCS,
>> +                                     TWL6030_REG_TOGGLE1);
>> +     if (ret < 0) {
>> +             dev_err(&pdev->dev, "Failed to enable GPADC module\n");
>> +             return ret;
>> +     }
>> +
>> +     /* create as many sysfs entries as it really exists on the device */
>> +     twl6030_gpadc_group.attrs[pdata->nchannels] = NULL;
>> +     ret = sysfs_create_group(&pdev->dev.kobj, &twl6030_gpadc_group);
>> +     if (ret)
>> +             dev_err(&pdev->dev, "could not create sysfs files\n");
>> +
>> +     return ret;
>> +}
>> +
>> +static int twl6030_gpadc_remove(struct platform_device *pdev)
>> +{
>> +     twl6030_gpadc_disable_irq(TWL6030_GPADC_RT_SW1_EOC_MASK);
>> +     sysfs_remove_group(&pdev->dev.kobj, &twl6030_gpadc_group);
>> +
>> +     return 0;
>> +}
>> +
>> +static int twl6030_gpadc_suspend(struct device *pdev)
>> +{
>> +     int ret;
>> +
>> +     ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, TWL6030_GPADCR,
>> +                             TWL6030_REG_TOGGLE1);
>> +     if (ret)
>> +             pr_err("%s: Error reseting GPADC (%d)!\n", __func__, ret);
>> +
>> +     return 0;
>> +};
>> +
>> +static int twl6030_gpadc_resume(struct device *pdev)
>> +{
>> +     int ret;
>> +
>> +     ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, TWL6030_GPADCS,
>> +                             TWL6030_REG_TOGGLE1);
>> +     if (ret)
>> +             pr_err("%s: Error setting GPADC (%d)!\n", __func__, ret);
>> +
>> +     return 0;
>> +};
>> +
>> +static const struct dev_pm_ops twl6030_gpadc_pm_ops = {
>> +     .suspend = twl6030_gpadc_suspend,
>> +     .resume = twl6030_gpadc_resume,
>> +};
>> +
>> +static struct platform_driver twl6030_gpadc_driver = {
>> +     .probe          = twl6030_gpadc_probe,
>> +     .remove         = twl6030_gpadc_remove,
>> +     .driver         = {
>> +             .name   = DRIVER_NAME,
>> +             .owner  = THIS_MODULE,
>> +             .pm     = &twl6030_gpadc_pm_ops,
>> +             .of_match_table = of_twl6030_match_tbl,
>> +     },
>> +};
>> +
>> +module_platform_driver(twl6030_gpadc_driver);
>> +
>> +MODULE_ALIAS("platform: " DRIVER_NAME);
>> +MODULE_AUTHOR("Texas Instruments Inc.");
>> +MODULE_DESCRIPTION("twl6030 ADC driver");
>> +MODULE_LICENSE("GPL");
>> diff --git a/include/linux/i2c/twl6030-gpadc.h b/include/linux/i2c/twl6030-gpadc.h
>> new file mode 100644
>> index 0000000..5cd11e7
>> --- /dev/null
>> +++ b/include/linux/i2c/twl6030-gpadc.h
>> @@ -0,0 +1,51 @@
>> +/*
>> + * include/linux/i2c/twl6030-gpadc.h
>> + *
>> + * TWL6030 GPADC module driver header
>> + *
>> + * Copyright (C) 2009 Texas Instruments Inc.
>> + * Nishant Kamat <nskamat@ti.com>
>> + *
>> + * Based on twl4030-madc.h
>> + * Copyright (C) 2008 Nokia Corporation
>> + * Mikko Ylinen <mikko.k.ylinen@nokia.com>
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License
>> + * version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but
>> + * WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> + * General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
>> + * 02110-1301 USA
>> + *
>> + */
>> +
>> +#ifndef _TWL6030_GPADC_H
>> +#define _TWL6030_GPADC_H
>> +
>> +
>> +/** struct twl6030_gpadc_result
>> + * @raw_code         raw adc value from GPADC
>> + * @corrected_code   corrected code calibrated adc value
>> + * @result           calculated value
>> + */
>> +struct twl6030_gpadc_result {
>> +     int raw_code;
>> +     int corrected_code;
>> +     int result;
>> +};
>> +
>> +/*
>> + * the user passes the bit mask of channels he wants to read converted values
>> + * end pointer to buffer allocated for the conversion results
>> + * on success returns 0.
>> + */
>> +int twl6030_gpadc_conversion(u32 channels, struct twl6030_gpadc_result *res);
>> +
>> +#endif
>
>--
>Lee Jones
>Linaro ST-Ericsson Landing Team Lead
>Linaro.org ? Open source software for ARM SoCs
>Follow Linaro: Facebook | Twitter | Blog
