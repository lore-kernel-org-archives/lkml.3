Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212AbaHGKGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 06:06:55 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:42453 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131AbaHGKGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 06:06:53 -0400
Date: Thu, 7 Aug 2014 11:06:45 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Wei-Chun Pan <weichun.pan@advantech.com.tw>
Cc: Guenter Roeck <linux@roeck-us.net>, Samuel Ortiz <sameo@linux.intel.com>,
        Jean Delvare <jdelvare@suse.de>, Wolfram Sang <wsa@the-dreams.de>,
        "Louis.Lu" <Louis.Lu@advantech.com.tw>,
        "Neo.Lo" <neo.lo@advantech.com.tw>,
        "Hank.Peng" <Hank.Peng@advantech.com.tw>,
        "Kevin.Ong" <Kevin.Ong@advantech.com.tw>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] hwmon: (imanager2) Add support for IT8516/18/28
Message-ID: <20140807100645.GF10136@lee--X1>
References: <1407403476-3634-1-git-send-email-weichun.pan@advantech.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1407403476-3634-1-git-send-email-weichun.pan@advantech.com.tw>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Aug 2014, Wei-Chun Pan wrote:

> Sorry, I sent wrong patch just now. Please ignore the mail "[PATCH 1/3]
>  imanager2: rename io functions and remove no used functions".
> 
> This mail include 2 patches:
> The first patch is shown I rename some functions.
> The second patch is shown I moditfy code according to your comment.
> 
> Signed-off-by: Wei-Chun Pan <weichun.pan@advantech.com.tw>

Please use Git to send patches.  All of the above is in the wrong
order and is missing lots of context.

Please read:
  Documentation/SubmittingPatches
  Documentation/email-clients.txt

> ---
> diff --git a/drivers/hwmon/imanager2_hwm.c b/drivers/hwmon/imanager2_hwm.c
> index 335bffb..ab63296 100644
> --- a/drivers/hwmon/imanager2_hwm.c
> +++ b/drivers/hwmon/imanager2_hwm.c
> @@ -119,17 +119,17 @@ static int imanager2_volt_get_value_by_io(struct imanager2 *ec, int index,
>  	u8 portnum;
>  	int ret;
>  
> -	ret = imanager2_mbox_io_read(EC_CMD_ADC_INDEX, pin, &portnum, 1);
> +	ret = imanager2_io_read_data(EC_CMD_ADC_INDEX, pin, &portnum, 1);
>  	if (ret)
>  		return ret;
>  	if (portnum == EC_ERROR)
>  		return -ENXIO;
>  
> -	ret = imanager2_mbox_io_simple_read(EC_CMD_ADC_READ_LSB, &buf[1]);
> +	ret = imanager2_io_nooffset_readbyte(EC_CMD_ADC_READ_LSB, &buf[1]);
>  	if (ret)
>  		return ret;
>  
> -	return imanager2_mbox_io_simple_read(EC_CMD_ADC_READ_MSB, &buf[0]);
> +	return imanager2_io_nooffset_readbyte(EC_CMD_ADC_READ_MSB, &buf[0]);
>  }

[...]

> ---
> > > ---
> > >  drivers/hwmon/Kconfig         |   5 +
> > >  drivers/hwmon/Makefile        |   1 +
> > >  drivers/hwmon/imanager2_hwm.c | 768
> > ++++++++++++++++++++++++++++++++++++++++++
> > 
> > Documentation/hwmon/imanager2_hwm missing.

WTF?

I'm confused my this and even more so with the stuff below this.
What's the idea of this email?  Are you sending a patch or replying to
a code review?  You can't do both in one submission.

> diff --git a/Documentation/hwmon/imanager2_hwm b/Documentation/hwmon/imanager2_hwm
> new file mode 100644
> index 0000000..bf3d0b5
> --- /dev/null
> +++ b/Documentation/hwmon/imanager2_hwm
> @@ -0,0 +1,42 @@
> +Kernel driver imanager2_hwm
> +===========================
> +
> +Supported chips:
> +  * ITE IT8516
> +    Prefix: 'it8516'
> +    Addresses scanned: I/O chennel 0x029A/0x0299,
> +                       IET mailbox chennel 0x029E/0x029F
> +    Datasheet: Not publicly available
> +  * ITE IT8518
> +    Prefix: 'it8518'
> +    Addresses scanned: I/O chennel 0x029A/0x0299,
> +                       IET mailbox chennel 0x029E/0x029F
> +    Datasheet: Not publicly available
> +  * ITE IT8528
> +    Prefix: 'it8528'
> +    Addresses scanned: I/O chennel 0x029A/0x0299
> +    Datasheet: Not publicly available
> +
> +Authors:
> +        Richard Vidal-Dorsch <richard.dorsch@advantech.com>
> +
> +
> +Description
> +-----------
> +
> +This driver supports the hardware monitoring features of the IT8516, IT8518, and
> +IT8528 chips. These features include 11 voltage sensors, 1 current sensor, 4
> +temperature sensors, and 3 fan rotation speed sensors.
> +
> +ITE IT8516, IT8518, and IT8528 are are 'EC chips'. These chips are like Super I/O control boards. For IT8516 and IT 8518 The control chennel can be I/O or ITE mailbox chennel. I/O chennel is a common way but ITE mailbox chennel performance faster since it does not need to wait IBF (input buffer full) and OBF (output buffer full) to before send or get data.
> +
> +ITE IT8528 use an I/O chennel way to access mailbox, called I/O mailbox for cost down. Its performance the between pure I/O controller and ITE mailbox controller.
> +
> +
> +sysfs-Interface
> +---------------
> +
> +in[0-11]_input	- adc voltage input
> +curr1_input	- adc current input
> +temp[1-4]_input	- temperature input
> +fan[1-3]_input	- fan speed input
> 
> > 
> > >  3 files changed, 774 insertions(+)
> > >  create mode 100644 drivers/hwmon/imanager2_hwm.c
> > >
> > > diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> > > index bc196f4..7524fc3 100644
> > > --- a/drivers/hwmon/Kconfig
> > > +++ b/drivers/hwmon/Kconfig
> > > @@ -39,6 +39,11 @@ config HWMON_DEBUG_CHIP
> > >
> > >  comment "Native drivers"
> > >
> > > +config SENSORS_IMANAGER2
> > > +	tristate "Support for Advantech iManager2 EC H.W. Monitor"
> > > +	select MFD_CORE
> > > +	depends on MFD_IMANAGER2
> > > +
> > Alphabetic order please.
> > 
> > >  config SENSORS_AB8500
> > >  	tristate "AB8500 thermal monitoring"
> > >  	depends on AB8500_GPADC && AB8500_BM
> > > diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
> > > index c48f987..a2c8f07 100644
> > > --- a/drivers/hwmon/Makefile
> > > +++ b/drivers/hwmon/Makefile
> > > @@ -146,6 +146,7 @@ obj-$(CONFIG_SENSORS_W83L785TS)	+= w83l785ts.o
> > >  obj-$(CONFIG_SENSORS_W83L786NG)	+= w83l786ng.o
> > >  obj-$(CONFIG_SENSORS_WM831X)	+= wm831x-hwmon.o
> > >  obj-$(CONFIG_SENSORS_WM8350)	+= wm8350-hwmon.o
> > > +obj-$(CONFIG_SENSORS_IMANAGER2)	+= imanager2_hwm.o
> > >
> > Alphabetic order please.
> > 
>  drivers/hwmon/Kconfig  | 10 +++++-----
>  drivers/hwmon/Makefile |  2 +-
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index 7524fc3..e39f8e0 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -39,11 +39,6 @@ config HWMON_DEBUG_CHIP
>  
>  comment "Native drivers"
>  
> -config SENSORS_IMANAGER2
> -	tristate "Support for Advantech iManager2 EC H.W. Monitor"
> -	select MFD_CORE
> -	depends on MFD_IMANAGER2
> -
>  config SENSORS_AB8500
>  	tristate "AB8500 thermal monitoring"
>  	depends on AB8500_GPADC && AB8500_BM
> @@ -576,6 +571,11 @@ config SENSORS_CORETEMP
>  	  sensor inside your CPU. Most of the family 6 CPUs
>  	  are supported. Check Documentation/hwmon/coretemp for details.
>  
> +config SENSORS_IMANAGER2
> +	tristate "Support for Advantech iManager2 EC H.W. Monitor"
> +	select MFD_CORE
> +	depends on MFD_IMANAGER2
> +
>  config SENSORS_IT87
>  	tristate "ITE IT87xx and compatibles"
>  	depends on !PPC
> diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
> index a2c8f07..564b6fe 100644
> --- a/drivers/hwmon/Makefile
> +++ b/drivers/hwmon/Makefile
> @@ -72,6 +72,7 @@ obj-$(CONFIG_SENSORS_I5K_AMB)	+= i5k_amb.o
>  obj-$(CONFIG_SENSORS_IBMAEM)	+= ibmaem.o
>  obj-$(CONFIG_SENSORS_IBMPEX)	+= ibmpex.o
>  obj-$(CONFIG_SENSORS_IIO_HWMON) += iio_hwmon.o
> +obj-$(CONFIG_SENSORS_IMANAGER2)	+= imanager2_hwm.o
>  obj-$(CONFIG_SENSORS_INA209)	+= ina209.o
>  obj-$(CONFIG_SENSORS_INA2XX)	+= ina2xx.o
>  obj-$(CONFIG_SENSORS_IT87)	+= it87.o
> @@ -146,7 +147,6 @@ obj-$(CONFIG_SENSORS_W83L785TS)	+= w83l785ts.o
>  obj-$(CONFIG_SENSORS_W83L786NG)	+= w83l786ng.o
>  obj-$(CONFIG_SENSORS_WM831X)	+= wm831x-hwmon.o
>  obj-$(CONFIG_SENSORS_WM8350)	+= wm8350-hwmon.o
> -obj-$(CONFIG_SENSORS_IMANAGER2)	+= imanager2_hwm.o
>  
>  obj-$(CONFIG_PMBUS)		+= pmbus/
> 
> > >  obj-$(CONFIG_PMBUS)		+= pmbus/
> > >
> > > diff --git a/drivers/hwmon/imanager2_hwm.c
> 
> [...]
> 
> > b/drivers/hwmon/imanager2_hwm.c
> > > new file mode 100644
> > > index 0000000..335bffb
> > > --- /dev/null
> > > +++ b/drivers/hwmon/imanager2_hwm.c
> > > @@ -0,0 +1,768 @@
> > > +/*
> > > + * imanager2_hwm.c - HW Monitoring interface for Advantech EC
> > IT8516/18/28
> > > + * Copyright (C) 2014  Richard Vidal-Dorsch <richard.dorsch@advantech.com>
> > > + *
> > > + * This program is free software: you can redistribute it and/or modify
> > > + * it under the terms of the GNU General Public License as published by
> > > + * the Free Software Foundation, either version 3 of the License, or
> > > + * (at your option) any later version.
> > > + *
> > > + * This program is distributed in the hope that it will be useful,
> > > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > + * GNU General Public License for more details.
> > > + *
> > > + * You should have received a copy of the GNU General Public License
> > > + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> > > + */
> > > +
> > > +#include <linux/module.h>
> > > +#include <linux/platform_device.h>
> > > +#include <linux/hwmon.h>
> > > +#include <linux/hwmon-sysfs.h>
> > > +#include <linux/mfd/imanager2_ec.h>
> > > +
> > > +#define DRV_NAME	"imanager2_hwm"
> > > +#define DRV_VERSION	"4.0.1"
> > > +
> > > +/* ADC */
> > > +#define EC_ADC_RESOLUTION_MAX	0x03FF	/* 10-bit */
> > > +#define EC_ADC_VALUE_MAX	3000	/* max: 3000 mV or mA */
> > > +
> > > +/* Thermal */
> > > +#define EC_THERMAL_ZONE_MAX	4
> > > +
> > > +enum thermaltype {
> > > +	none,
> > > +	sys1,
> > > +	cpu,
> > > +	sys3,
> > > +	sys2,
> > > +};
> > > +
> > > +struct ec_thermalzone {
> > > +	u8 channel,
> > > +	   addr,
> > > +	   cmd,
> > > +	   status,
> > > +	   fancode,
> > > +	   temp;
> > > +};
> > > +
> > > +/* Tacho */
> > > +#define EC_MAX_IO_FAN	3
> > > +
> > > +/* Voltage */
> > > +struct volt_item {
> > > +	u8 did;
> > > +	const char *name;
> > > +	int factor;
> > > +	bool visible;
> > > +};
> > > +
> > > +static struct volt_item ec_volt_table[] = {
> > > +	{
> > > +		.did = adcmosbat,
> > > +		.name = "BAT CMOS",
> > > +	},
> > > +	{
> > > +		.did = adcbat,
> > > +		.name = "BAT",
> > > +	},
> > > +	{
> > > +		.did = adc5vs0,
> > > +		.name = "5V S0",
> > > +	},
> > > +	{
> > > +		.did = adv5vs5,
> > > +		.name = "5V S5",
> > > +	},
> > > +	{
> > > +		.did = adc33vs0,
> > > +		.name = "3V3 S0",
> > > +	},
> > > +	{
> > > +		.did = adc33vs5,
> > > +		.name = "3V3 S5",
> > > +	},
> > > +	{
> > > +		.did = adv12vs0,
> > > +		.name = "12V S0",
> > > +	},
> > > +	{
> > > +		.did = adcvcorea,
> > > +		.name = "Vcore A",
> > > +	},
> > > +	{
> > > +		.did = adcvcoreb,
> > > +		.name = "Vcore B",
> > > +	},
> > > +	{
> > > +		.did = adcdc,
> > > +		.name = "DC",
> > > +	},
> > > +	{
> > > +		.did = adcdcstby,
> > > +		.name = "DC Standby",
> > > +	},
> > > +	{
> > > +		.did = adcdcother,
> > > +		.name = "DC Other",
> > > +	},
> > > +};
> > > +
> > > +static int imanager2_volt_get_value_by_io(struct imanager2 *ec, int index,
> > > +					  u8 *buf)
> > > +{
> > > +	u8 item = ec->table.devid2itemnum[ec_volt_table[index].did];
> > > +	u8 pin = ec->table.pinnum[item];
> > > +	u8 portnum;
> > > +	int ret;
> > > +
> > > +	ret = imanager2_mbox_io_read(EC_CMD_ADC_INDEX, pin, &portnum, 1);
> > > +	if (ret)
> > > +		return ret;
> > > +	if (portnum == EC_ERROR)
> > > +		return -ENXIO;
> > > +
> > > +	ret = imanager2_mbox_io_simple_read(EC_CMD_ADC_READ_LSB, &buf[1]);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	return imanager2_mbox_io_simple_read(EC_CMD_ADC_READ_MSB,
> > &buf[0]);
> > > +}
> > > +
> > > +static int imanager2_volt_get_value(struct imanager2 *ec, int index,
> > > +				    u32 *volt_mvolt)
> > > +{
> > > +	int ret;
> > > +	u8 tmp[2];
> > > +
> > > +	mutex_lock(&ec->lock);
> > > +
> > > +	if (ec->flag & EC_FLAG_MAILBOX)
> > > +		ret = imanager2_mbox_read_data(ec->flag,
> > > +					       EC_CMD_MAILBOX_READ_HW_PIN,
> > > +					       ec_volt_table[index].did,
> > > +					       tmp, 2);
> > > +	else
> > > +		ret = imanager2_volt_get_value_by_io(ec, index, tmp);
> > > +
> > > +	mutex_unlock(&ec->lock);
> > > +
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	*volt_mvolt = (((tmp[0] << 8) | tmp[1]) & EC_ADC_RESOLUTION_MAX) *
> > > +		      ec_volt_table[index].factor *
> > > +		      DIV_ROUND_CLOSEST(EC_ADC_VALUE_MAX,
> > > +					EC_ADC_RESOLUTION_MAX);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static void imanager2_volt_init(struct imanager2 *ec)
> > > +{
> > > +	u8 did;
> > > +	int i;
> > > +
> > > +	for (i = 0; i < ARRAY_SIZE(ec_volt_table); i++) {
> > > +		did = ec_volt_table[i].did;
> > > +
> > > +		if (ec->table.devid2itemnum[did] != EC_TABLE_ITEM_UNUSED) {
> > > +			ec_volt_table[i].factor = 1;
> > > +			ec_volt_table[i].visible = true;
> > > +		} else if (ec->table.devid2itemnum[did + 1] !=
> > > +			   EC_TABLE_ITEM_UNUSED) {
> > > +			ec_volt_table[i].did += 1;
> > > +			ec_volt_table[i].factor = 2;
> > > +			ec_volt_table[i].visible = true;
> > > +		} else if (ec->table.devid2itemnum[did + 2] !=
> > > +			   EC_TABLE_ITEM_UNUSED) {
> > > +			ec_volt_table[i].did += 2;
> > > +			ec_volt_table[i].factor = 10;
> > > +			ec_volt_table[i].visible = true;
> > > +		} else {
> > > +			ec_volt_table[i].visible = false;
> > > +		}
> > > +	}
> > > +}
> > > +
> > > +static ssize_t show_in(struct device *dev, struct device_attribute *dev_attr,
> > > +		       char *buf)
> > > +{
> > > +	struct imanager2 *ec = dev_get_drvdata(dev);
> > > +	u32 val;
> > > +	int ret = imanager2_volt_get_value(ec,
> > > +					   to_sensor_dev_attr(dev_attr)->index,
> > > +					   &val);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	return sprintf(buf, "%u\n", val);
> > > +}
> > > +
> > > +static ssize_t show_in_label(struct device *dev,
> > > +			     struct device_attribute *dev_attr, char *buf)
> > > +{
> > > +	return sprintf(buf, "%s\n",
> > > +		       ec_volt_table[to_sensor_dev_attr(dev_attr)->index].name);
> > > +}
> > > +
> > > +static SENSOR_DEVICE_ATTR(in0_input, S_IRUGO, show_in, NULL, 0);
> > > +static SENSOR_DEVICE_ATTR(in1_input, S_IRUGO, show_in, NULL, 1);
> > > +static SENSOR_DEVICE_ATTR(in2_input, S_IRUGO, show_in, NULL, 2);
> > > +static SENSOR_DEVICE_ATTR(in3_input, S_IRUGO, show_in, NULL, 3);
> > > +static SENSOR_DEVICE_ATTR(in4_input, S_IRUGO, show_in, NULL, 4);
> > > +static SENSOR_DEVICE_ATTR(in5_input, S_IRUGO, show_in, NULL, 5);
> > > +static SENSOR_DEVICE_ATTR(in6_input, S_IRUGO, show_in, NULL, 6);
> > > +static SENSOR_DEVICE_ATTR(in7_input, S_IRUGO, show_in, NULL, 7);
> > > +static SENSOR_DEVICE_ATTR(in8_input, S_IRUGO, show_in, NULL, 8);
> > > +static SENSOR_DEVICE_ATTR(in9_input, S_IRUGO, show_in, NULL, 9);
> > > +static SENSOR_DEVICE_ATTR(in10_input, S_IRUGO, show_in, NULL, 10);
> > > +static SENSOR_DEVICE_ATTR(in11_input, S_IRUGO, show_in, NULL, 11);
> > > +
> > > +static SENSOR_DEVICE_ATTR(in0_label, S_IRUGO, show_in_label, NULL, 0);
> > > +static SENSOR_DEVICE_ATTR(in1_label, S_IRUGO, show_in_label, NULL, 1);
> > > +static SENSOR_DEVICE_ATTR(in2_label, S_IRUGO, show_in_label, NULL, 2);
> > > +static SENSOR_DEVICE_ATTR(in3_label, S_IRUGO, show_in_label, NULL, 3);
> > > +static SENSOR_DEVICE_ATTR(in4_label, S_IRUGO, show_in_label, NULL, 4);
> > > +static SENSOR_DEVICE_ATTR(in5_label, S_IRUGO, show_in_label, NULL, 5);
> > > +static SENSOR_DEVICE_ATTR(in6_label, S_IRUGO, show_in_label, NULL, 6);
> > > +static SENSOR_DEVICE_ATTR(in7_label, S_IRUGO, show_in_label, NULL, 7);
> > > +static SENSOR_DEVICE_ATTR(in8_label, S_IRUGO, show_in_label, NULL, 8);
> > > +static SENSOR_DEVICE_ATTR(in9_label, S_IRUGO, show_in_label, NULL, 9);
> > > +static SENSOR_DEVICE_ATTR(in10_label, S_IRUGO, show_in_label, NULL, 10);
> > > +static SENSOR_DEVICE_ATTR(in11_label, S_IRUGO, show_in_label, NULL, 11);
> > > +
> > > +static struct attribute *imanager2_volt_attrs[] = {
> > > +	&sensor_dev_attr_in0_label.dev_attr.attr,
> > > +	&sensor_dev_attr_in0_input.dev_attr.attr,
> > > +
> > > +	&sensor_dev_attr_in1_label.dev_attr.attr,
> > > +	&sensor_dev_attr_in1_input.dev_attr.attr,
> > > +
> > > +	&sensor_dev_attr_in2_label.dev_attr.attr,
> > > +	&sensor_dev_attr_in2_input.dev_attr.attr,
> > > +
> > > +	&sensor_dev_attr_in3_label.dev_attr.attr,
> > > +	&sensor_dev_attr_in3_input.dev_attr.attr,
> > > +
> > > +	&sensor_dev_attr_in4_label.dev_attr.attr,
> > > +	&sensor_dev_attr_in4_input.dev_attr.attr,
> > > +
> > > +	&sensor_dev_attr_in5_label.dev_attr.attr,
> > > +	&sensor_dev_attr_in5_input.dev_attr.attr,
> > > +
> > > +	&sensor_dev_attr_in6_label.dev_attr.attr,
> > > +	&sensor_dev_attr_in6_input.dev_attr.attr,
> > > +
> > > +	&sensor_dev_attr_in7_label.dev_attr.attr,
> > > +	&sensor_dev_attr_in7_input.dev_attr.attr,
> > > +
> > > +	&sensor_dev_attr_in8_label.dev_attr.attr,
> > > +	&sensor_dev_attr_in8_input.dev_attr.attr,
> > > +
> > > +	&sensor_dev_attr_in9_label.dev_attr.attr,
> > > +	&sensor_dev_attr_in9_input.dev_attr.attr,
> > > +
> > > +	&sensor_dev_attr_in10_label.dev_attr.attr,
> > > +	&sensor_dev_attr_in10_input.dev_attr.attr,
> > > +
> > > +	&sensor_dev_attr_in11_label.dev_attr.attr,
> > > +	&sensor_dev_attr_in11_input.dev_attr.attr,
> > > +
> > > +	NULL
> > > +};
> > > +
> > > +static umode_t imanager2_volt_mode(struct kobject *kobj, struct attribute
> > *attr,
> > > +				   int index)
> > > +{
> > > +	struct device_attribute *dev_attr;
> > > +
> > > +	dev_attr = container_of(attr, struct device_attribute, attr);
> > > +	if (!ec_volt_table[to_sensor_dev_attr(dev_attr)->index].visible)
> > > +		return 0;
> > > +
> > > +	return attr->mode;
> > > +}
> > > +
> > > +static const struct attribute_group imanager2_volt_group = {
> > > +	.attrs = imanager2_volt_attrs,
> > > +	.is_visible = imanager2_volt_mode,
> > > +};
> > > +
> > > +/* Current */
> > > +struct curr_item {
> > > +	const u8 did;
> > > +	const char *name;
> > > +	bool visible;
> > > +};
> > > +
> > > +static struct curr_item ec_curr_table[] = {
> > > +	{
> > > +		.did = adccurrent,
> > > +		.name = "IMON"
> > > +	},
> > > +};
> > > +
> > > +static int imanager2_curr_get_value(struct imanager2 *ec, int index,
> > > +				    u32 *curr_mamp)
> > > +{
> > > +	int ret;
> > > +	u8 tmp[5];
> > > +	u16 value, factor;
> > > +	u32 baseunit = 1;
> > > +
> > > +	mutex_lock(&ec->lock);
> > > +	ret = imanager2_mbox_read_data(ec->flag,
> > EC_CMD_MAILBOX_READ_HW_PIN,
> > > +				       ec_curr_table[index].did, tmp,
> > > +				       ARRAY_SIZE(tmp));
> > > +	mutex_unlock(&ec->lock);
> > > +
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	value = ((tmp[0] << 8) | tmp[1]) & EC_ADC_RESOLUTION_MAX;
> > > +	factor = (tmp[2] << 8) | tmp[3];
> > 
> > Is it guaranteed that factor is never 0 ? If not, this may result
> > in a division by 0 error.
> > 
> 
> @@ -326,6 +318,11 @@ static int imanager2_curr_get_value(struct imanager2 *ec, int index,
>  	value = ((tmp[0] << 8) | tmp[1]) & EC_ADC_RESOLUTION_MAX;
>  	factor = (tmp[2] << 8) | tmp[3];
>  
> +	if (!factor) {
> +		*curr_mamp = 0;
> +		return 0;
> +	}
> +
>  	while (tmp[4]++)
>  		baseunit *= 10;
> 
> > > +
> > > +	while (tmp[4]++)
> > > +		baseunit *= 10;
> > > +
> 
> [...]
> 
> > > +static void imanager2_temp_init(struct imanager2 *ec)
> > > +{
> > > +	int i, thm, ret;
> > > +	u8 tmltype, smbid, fanid;
> > > +	struct ec_thermalzone zone;
> > > +
> > > +	for (i = 0; i < ARRAY_SIZE(ec_temp_table); i++)
> > > +		ec_temp_table[i].visible = false;
> > > +
> > > +	for (thm = 0; thm < EC_THERMAL_ZONE_MAX; thm++) {
> > > +		mutex_lock(&ec->lock);
> > > +
> > > +		if (ec->flag & EC_FLAG_MAILBOX) {
> > > +			int len = sizeof(struct ec_thermalzone);
> > 
> > Checkpatch warning.
> 
> I use "./scripts/checkpatch.pl --no-tree --strict -f drivers/hwmon/imanager2_hwm"
> but no warning shown out.
> Can you help me to find out the warning?
> 
> > 
> > > +			ret = imanager2_mbox_read_thermalzone(ec->flag, thm,
> > > +							      &smbid, &fanid,
> > > +							      (u8 *)&zone,
> > > +							      &len);
> 
> [...]
> 
> > > +static struct fan_item ec_fan_table[] = {
> > > +	{
> > > +		.did = tacho0,
> > > +		.name = "Fan CPU",
> > > +		.fspeed_acpireg = 0,
> > 
> > It is not necessary to set such constants to 0.
> 
> @@ -566,20 +566,17 @@ static struct fan_item ec_fan_table[] = {
>  	{
>  		.did = tacho0,
>  		.name = "Fan CPU",
> -		.fspeed_acpireg = 0,
> -		.visible = false
> +		.visible = false,
>  	},
>  	{
>  		.did = tacho1,
>  		.name = "Fan SYS",
> -		.fspeed_acpireg = 0,
> -		.visible = false
> +		.visible = false,
>  	},
>  	{
>  		.did = tacho2,
>  		.name = "Fan SYS2",
> -		.fspeed_acpireg = 0,
> -		.visible = false
> +		.visible = false,
>  	},
>  };
> 
> > 
> > > +		.visible = false
> > > +	},
> > > +	{
> > > +		.did = tacho1,
> > > +		.name = "Fan SYS",
> > > +		.fspeed_acpireg = 0,
> > > +		.visible = false
> > > +	},
> > > +	{
> > > +		.did = tacho2,
> > > +		.name = "Fan SYS2",
> > > +		.fspeed_acpireg = 0,
> > > +		.visible = false
> > > +	},
> > > +};
> > > +
> > > +static int imanager2_fan_get_value(struct imanager2 *ec, int index,
> > > +				   u32 *speed_rpm)
> > > +{
> > > +	int ret;
> > > +	u8 tmp[2];
> > > +
> > > +	mutex_lock(&ec->lock);
> > > +
> > > +	if (ec->flag & EC_FLAG_MAILBOX)
> > > +		ret = imanager2_mbox_read_data(ec->flag,
> > > +					       EC_CMD_MAILBOX_READ_HW_PIN,
> > > +					       ec_fan_table[index].did, tmp, 2);
> > > +	else
> > > +		ret = imanager2_mbox_io_read(EC_CMD_ACPIRAM_READ,
> > > +					     ec_fan_table[index].fspeed_acpireg,
> > > +					     tmp, 2);
> > > +
> > > +	mutex_unlock(&ec->lock);
> > > +
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	if (tmp[0] == 0xFF && tmp[1] == 0xFF)
> > > +		return -ENODEV;
> > 
> > That is a bit late for detecting that there is no such device.
> > 
> 
> @@ -605,11 +602,11 @@ static int imanager2_fan_get_value(struct imanager2 *ec, int index,
>  	if (ret)
>  		return ret;
>  
> -	if (tmp[0] == 0xFF && tmp[1] == 0xFF)
> -		return -ENODEV;
> -
>  	*speed_rpm = (tmp[0] << 8) | tmp[1];
>  
> +	if (*speed_rpm == 0xFFFF)
> +		*speed_rpm = 0;
> +
>  	return 0;
>  }
> 
> > > +
> > > +	*speed_rpm = (tmp[0] << 8) | tmp[1];
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +#define EC_FANCTROL_SPEEDSRC_MASK	0x30
> > > +
> > > +static int imanager2_fan_item_init_by_io(struct imanager2 *ec, int fnum)
> > > +{
> > > +	int i, ret;
> > > +	u8 tmp;
> > > +
> > > +	mutex_lock(&ec->lock);
> > > +	ret = imanager2_mbox_io_read(EC_CMD_HWRAM_READ,
> > > +				     EC_HWRAM_ADDR_FAN_CONTROL(fnum), &tmp, 1);
> > > +	mutex_unlock(&ec->lock);
> > > +
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	i = ((tmp & EC_FANCTROL_SPEEDSRC_MASK) >> 4) - 1;
> > > +	if (i < 0)
> > > +		return -ENODEV;
> > > +
> > 
> > This error return is quite pointless. See below.
> > 
> 
> @@ -627,7 +624,7 @@ static int imanager2_fan_item_init_by_io(struct imanager2 *ec, int fnum)
>  
>  	i = ((tmp & EC_FANCTROL_SPEEDSRC_MASK) >> 4) - 1;
>  	if (i < 0)
> -		return -ENODEV;
> +		return 0;
>  
>  	/* Unnecessary set again if it has been set. */
>  	if (ec_fan_table[i].visible)
> 
> > > +	/* Unnecessary set again if it has been set. */
> > > +	if (ec_fan_table[i].visible)
> > > +		return 0;
> > > +
> > > +	ec_fan_table[i].fspeed_acpireg = EC_ACPIRAM_ADDR_FAN_SPEED_BASE(i);
> > > +	ec_fan_table[i].visible = true;
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static void imanager2_fan_init(struct imanager2 *ec)
> > > +{
> > > +	int i;
> > > +
> > > +	if (ec->flag & EC_FLAG_MAILBOX) {
> > > +		for (i = 0; i < ARRAY_SIZE(ec_fan_table); i++)
> > > +			ec_fan_table[i].visible =
> > > +			    ec->table.devid2itemnum[ec_fan_table[i].did] !=
> > > +			    EC_TABLE_ITEM_UNUSED;
> > > +	} else {
> > > +		int fnum;
> > > +
> > > +		for (i = 0; i < ARRAY_SIZE(ec_fan_table); i++)
> > > +			ec_fan_table[i].visible = false;
> > > +
> > > +		for (fnum = 0; fnum < EC_MAX_IO_FAN; fnum++) {
> > > +			if (imanager2_fan_item_init_by_io(ec, fnum))
> > > +				continue;
> > 
> > This continue is quite pointless.
> > 
> 
> @@ -654,10 +651,8 @@ static void imanager2_fan_init(struct imanager2 *ec)
>  		for (i = 0; i < ARRAY_SIZE(ec_fan_table); i++)
>  			ec_fan_table[i].visible = false;
>  
> -		for (fnum = 0; fnum < EC_MAX_IO_FAN; fnum++) {
> -			if (imanager2_fan_item_init_by_io(ec, fnum))
> -				continue;
> -		}
> +		for (fnum = 0; fnum < EC_MAX_IO_FAN; fnum++)
> +			imanager2_fan_item_init_by_io(ec, fnum);
>  	}
>  }
> 
> > > +		}
> > > +	}
> > > +}
> > > +
> > > +static ssize_t show_fan(struct device *dev, struct device_attribute *dev_attr,
> > > +			char *buf)
> > > +{
> > > +	struct imanager2 *ec = dev_get_drvdata(dev);
> > > +	u32 val;
> > > +	int ret = imanager2_fan_get_value(ec,
> > > +					  to_sensor_dev_attr(dev_attr)->index,
> > > +					  &val);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	return sprintf(buf, "%u\n", val);
> > > +}
> > > +
> > > +static ssize_t show_fan_label(struct device *dev,
> > > +			      struct device_attribute *dev_attr, char *buf)
> > > +{
> > > +	return sprintf(buf, "%s\n",
> > > +		       ec_fan_table[to_sensor_dev_attr(dev_attr)->index].name);
> > > +}
> > > +
> > > +static SENSOR_DEVICE_ATTR(fan1_input, S_IRUGO, show_fan, NULL, 0);
> > > +static SENSOR_DEVICE_ATTR(fan2_input, S_IRUGO, show_fan, NULL, 1);
> > > +static SENSOR_DEVICE_ATTR(fan3_input, S_IRUGO, show_fan, NULL, 2);
> > > +
> > > +static SENSOR_DEVICE_ATTR(fan1_label, S_IRUGO, show_fan_label, NULL, 0);
> > > +static SENSOR_DEVICE_ATTR(fan2_label, S_IRUGO, show_fan_label, NULL, 1);
> > > +static SENSOR_DEVICE_ATTR(fan3_label, S_IRUGO, show_fan_label, NULL, 2);
> > > +
> > > +static struct attribute *imanager2_fan_attrs[] = {
> > > +	&sensor_dev_attr_fan1_label.dev_attr.attr,
> > > +	&sensor_dev_attr_fan1_input.dev_attr.attr,
> > > +
> > > +	&sensor_dev_attr_fan2_label.dev_attr.attr,
> > > +	&sensor_dev_attr_fan2_input.dev_attr.attr,
> > > +
> > > +	&sensor_dev_attr_fan3_label.dev_attr.attr,
> > > +	&sensor_dev_attr_fan3_input.dev_attr.attr,
> > > +
> > > +	NULL
> > > +};
> > > +
> > > +static umode_t imanager2_fan_mode(struct kobject *kobj, struct attribute *attr,
> > > +				  int index)
> > > +{
> > > +	struct device_attribute *dev_attr;
> > > +
> > > +	dev_attr = container_of(attr, struct device_attribute, attr);
> > > +	if (!ec_fan_table[to_sensor_dev_attr(dev_attr)->index].visible)
> > > +		return 0;
> > > +
> > > +	return attr->mode;
> > > +}
> > > +
> > > +static const struct attribute_group imanager2_fan_group = {
> > > +	.attrs = imanager2_fan_attrs,
> > > +	.is_visible = imanager2_fan_mode,
> > > +};
> > > +
> > > +/* Module */
> > > +static const struct attribute_group *imanager2_hwmon_groups[] = {
> > > +	&imanager2_volt_group,
> > > +	&imanager2_curr_group,
> > > +	&imanager2_temp_group,
> > > +	&imanager2_fan_group,
> > > +	NULL
> > > +};
> > > +
> > > +static int imanager2_hwmon_probe(struct platform_device *pdev)
> > > +{
> > > +	struct device *hwmon_dev;
> > > +	struct imanager2 *hwmon_ec = pdev->dev.parent->platform_data;
> > > +
> > > +	imanager2_volt_init(hwmon_ec);
> > > +	imanager2_curr_init(hwmon_ec);
> > > +	imanager2_temp_init(hwmon_ec);
> > > +	imanager2_fan_init(hwmon_ec);
> > > +
> > > +	hwmon_dev = devm_hwmon_device_register_with_groups(
> > > +			&pdev->dev, "imanager2", hwmon_ec,
> > > +			imanager2_hwmon_groups);
> > > +
> > > +	if (IS_ERR(hwmon_dev))
> > > +		return PTR_ERR(hwmon_dev);
> > > +
> > > +	return 0;
> > 
> > 	return PTR_ERR_OR_ZERO(hwmon_dev);
> > 
> 
> @@ -743,10 +738,7 @@ static int imanager2_hwmon_probe(struct platform_device *pdev)
>  			&pdev->dev, "imanager2", hwmon_ec,
>  			imanager2_hwmon_groups);
>  
> -	if (IS_ERR(hwmon_dev))
> -		return PTR_ERR(hwmon_dev);
> -
> -	return 0;
> +	return PTR_ERR_OR_ZERO(hwmon_dev);
>  }
> 
> > > +}
> > > +
> > > +static struct platform_driver imanager2_hwmon_driver = {
> > > +	.probe = imanager2_hwmon_probe,
> > > +	.driver = {
> > > +			.owner = THIS_MODULE,
> > > +			.name = DRV_NAME,
> > > +	},
> > > +};
> > > +
> > > +module_platform_driver(imanager2_hwmon_driver);
> > > +
> > > +MODULE_AUTHOR("Richard Vidal-Dorsch <richard.dorsch at
> > advantech.com>");
> > > +MODULE_DESCRIPTION("HW Monitoring interface for Advantech EC
> > IT8516/18/28");
> > > +MODULE_LICENSE("GPL");
> > > +MODULE_VERSION(DRV_VERSION);
> > >
> > >

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
