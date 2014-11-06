Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393AbaKFTtG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 14:49:06 -0500
Received: from mout.gmx.net ([212.227.17.20]:59295 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbaKFTtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 14:49:04 -0500
Message-ID: <545BD09E.9030106@gmx.de>
Date: Thu, 06 Nov 2014 20:48:46 +0100
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:32.0) Gecko/20100101 Firefox/32.0 SeaMonkey/2.29
MIME-Version: 1.0
To: "Markezana, William" <William.Markezana@meas-spec.com>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Daniel Baluta <daniel.baluta@intel.com>
CC: "jic23@kernel.org" <jic23@kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iio: (ms5637) Add Measurement Specialties MS5637 support
References: <8B5E2C57A478A447A3ECC506FBF26C030E1E2E@TLSE-SVR-MAIL01.europe.msiusa.com> <CAEnQRZCSQT-nOjPDjnL7hKn95y0--DzXxj3rihGA6e2cdFrwtA@mail.gmail.com> <alpine.DEB.2.02.1411061721010.20073@pmeerw.net> <8B5E2C57A478A447A3ECC506FBF26C030E2756@TLSE-SVR-MAIL01.europe.msiusa.com>
In-Reply-To: <8B5E2C57A478A447A3ECC506FBF26C030E2756@TLSE-SVR-MAIL01.europe.msiusa.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:ySQJNB07hkOEvXiYBxHSRYH2UDn1v5G/Iesq4qkCDgxsgM04708
 s+vtRcLEAdHFpx1QkVdHkkLv33kuAQSn8btjyyLa6vLDG1WIOjWiWqXhLSENuLq2k+tK4/h
 HS/BBi293k4te/0xfpAru0NdoxgzFK6oMOklZy+UjrCJ2fHl2sIkt1MddJm/VRaP+bGzW3p
 bezT2RnbhOjUZZAMAteYg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markezana, William schrieb am 06.11.2014 18:38:
> Hi all, 
> 
> Thank you for your feedbacks, I will take all those remarks in account and come back to you soon.
> Just one question, is the kilopascals output mandatory for pressure sensors?
> The benefit of our sensor is its accuracy of 1 millibars which is 0.1 kilopascals. It does not makes sense to have such accuracy if the final output is ten times less accurate...
> 
Using IIO_VAL_INT_PLUS_MICRO, you will get a resolution of 1E-6 kPa. That should be sufficient for your purpose, but if you need more, have a look at IIO_VAL_INT_PLUS_NANO.
> William Markezana 
> +33 582 082 286
> william.markezana@meas-spec.com
> 
> 
> -----Message d'origine-----
> De : Peter Meerwald [mailto:pmeerw@pmeerw.net] 
> Envoyé : jeudi 6 novembre 2014 17:54
> À : Daniel Baluta; Markezana, William
> Cc : jic23@kernel.org; linux-iio@vger.kernel.org; linux-kernel@vger.kernel.org
> Objet : Re: [PATCH] iio: (ms5637) Add Measurement Specialties MS5637 support
> 
>> Use  iio: ms5637: Add Measurement Specialties MS5637 support instead 
>> of
>> iio: (ms5637) Add Measurement Specialties MS5637 support for subject.
>>
>> If available please add a link to the datasheet here.
> 
> some more comments below...
>  
>> On Thu, Nov 6, 2014 at 11:46 AM, Markezana, William 
>> <William.Markezana@meas-spec.com> wrote:
>>> Signed-off-by: Ludovic <ludovic.tancerel@maplehightech.com>
>>> ---
>>>  drivers/iio/pressure/Kconfig                      |   10 +
>>>  drivers/iio/pressure/Makefile                     |    1 +
>>>  drivers/iio/pressure/ms5637.c                     |  488 +++++++++++++++++++++
>>>  drivers/staging/iio/Documentation/pressure/ms5637 |   25 ++
> 
> don't add documentation to staging
> 
>>>  4 files changed, 524 insertions(+)
>>>  create mode 100644 drivers/iio/pressure/ms5637.c  create mode 
>>> 100644 drivers/staging/iio/Documentation/pressure/ms5637
>>>
>>> diff --git a/drivers/iio/pressure/Kconfig 
>>> b/drivers/iio/pressure/Kconfig index ffac8ac..4ba9bd5 100644
>>> --- a/drivers/iio/pressure/Kconfig
>>> +++ b/drivers/iio/pressure/Kconfig
>>> @@ -41,6 +41,16 @@ config MPL3115
>>>            To compile this driver as a module, choose M here: the module
>>>            will be called mpl3115.
>>>
>>> +config MS5637
>>> +        tristate "MS5637 pressure & temperature sensor"
>>> +        depends on I2C
>>> +        help
>>> +          If you say yes here you get support for the Measurement Specialties
>>> +          MS5637 pressure and temperature sensor.
>>> +
>>> +          This driver can also be built as a module. If so, the module will
>>> +          be called ms5637.
>>> +
>>>  config IIO_ST_PRESS
>>>         tristate "STMicroelectronics pressure sensor Driver"
>>>         depends on (I2C || SPI_MASTER) && SYSFS diff --git 
>>> a/drivers/iio/pressure/Makefile b/drivers/iio/pressure/Makefile 
>>> index c53d250..50fe66e 100644
>>> --- a/drivers/iio/pressure/Makefile
>>> +++ b/drivers/iio/pressure/Makefile
>>> @@ -6,6 +6,7 @@
>>>  obj-$(CONFIG_HID_SENSOR_PRESS)   +=id-sensor-press.o
>>>  obj-$(CONFIG_MPL115) +=pl115.o
>>>  obj-$(CONFIG_MPL3115) +=pl3115.o
>>> +obj-$(CONFIG_MS5637) +=s5637.o
>>>  obj-$(CONFIG_IIO_ST_PRESS) +=t_pressure.o  st_pressure-y := 
>>> st_pressure_core.o
>>>  st_pressure-$(CONFIG_IIO_BUFFER) +=t_pressure_buffer.o diff --git 
>>> a/drivers/iio/pressure/ms5637.c b/drivers/iio/pressure/ms5637.c new 
>>> file mode 100644 index 0000000..ea74636
>>> --- /dev/null
>>> +++ b/drivers/iio/pressure/ms5637.c
>>> @@ -0,0 +1,488 @@
>>> +/*
>>> + * ms5637.c - Support for Measurement Specialties MS5637 
>>> +temperature sensor
> 
> pressure & temperature
> 
>>> + *
>>> + * Copyright (c) 2014 Measurement Specialties
>>> + *
>>> + * Licensed under the GPL-2.
>>> + *
>>> + * (7-bit I2C slave address 0x77)
>>> + *
>>> + */
>>> +
>>> +#include <linux/init.h>
>>> +#include <linux/device.h>
>>> +#include <linux/kernel.h>
>>> +#include <linux/stat.h>
>>> +#include <linux/module.h>
>>> +#include <linux/i2c.h>
>>> +#include <linux/iio/iio.h>
>>> +#include <linux/iio/sysfs.h>
>>> +#include <linux/jiffies.h>
>>> +#include <linux/delay.h>
>>> +#include <linux/mutex.h>
>>> +
>>> +/* MS5637 Commands */
>>> +#define MS5637_RESET                           (0x1E)
>>> +#define MS5637_TEMPERATURE_CONVERSION_START    (0x50)
>>> +#define MS5637_PRESSURE_CONVERSION_START       (0x40)
>>> +#define MS5637_ADC_READ                                (0x00)
>>> +#define MS5637_PROM_READ                       (0xA0)
>>> +#define MS5637_PROM_ELEMENTS_NB                 (7)
>>
>> I would prefer to remove "()" around hexa/decimal values.
>>
>>> +
>>> +#define ATTR_RESET                             0
>>> +#define ATTR_RESOLUTION                                1
> 
> MS5637_ prefix please
> 
>>> +
>>> +static const u16 conversion_time[] = 1000, 2000, 3000, 5000, 
>>> +9000, 17000 };
> 
> ms5637_ prefix please
> 
>>> +
>>> +struct ms5637_dev {
>>> +       struct i2c_client *client;
>>> +       struct mutex lock; /* mutex protecting this data structure */
>>> +       u16 calibration_coeffs[MS5637_PROM_ELEMENTS_NB];
>>> +       bool got_calibration_words;
>>> +       unsigned long last_update;
>>> +       bool valid;
>>> +       int temperature;
>>> +       unsigned int pressure;
>>> +       u8 resolution_index;
>>> +};
>>> +
>>> +static int ms5637_get_calibration_coeffs(struct ms5637_dev *dev_data,
>>> +                                        unsigned char index, u16 
>>> +*word) {
>>> +       int ret =;
>>> +
>>> +       ret =2c_smbus_read_word_swapped(dev_data->client,
>>> +                                         MS5637_PROM_READ + (index << 1));
>>> +       if (ret < 0)
>>> +               return ret;
>>> +       *word =u16) ret & 0xFFFF;
>>> +       return 0;
>>> +}
>>> +
>>> +static bool ms5637_crc_check(u16 *n_prom, u8 crc) {
>>> +       u8 cnt, n_bit;
> 
> cnt should be unsigned int, it's just a counter should have the CPUs native size
> 
>>> +       u16 n_rem, crc_read;
>>> +
>>> +       n_rem =x00;
> 
> should be 0 or 0x0000 as n_rem is u16
> 
>>> +       crc_read =_prom[0];
>>> +       n_prom[MS5637_PROM_ELEMENTS_NB] =;
>>> +       n_prom[0] =0x0FFF & (n_prom[0]));     /* Clear the CRC byte */
> 
> remove extra parenthesis
> 
>>> +
>>> +       for (cnt =; cnt < (MS5637_PROM_ELEMENTS_NB + 1) * 2; cnt++) {
>>> +               if (cnt % 2 =1)
>>> +                       n_rem ^=_prom[cnt >> 1] & 0x00FF;
>>> +               else
>>> +                       n_rem ^=_prom[cnt >> 1] >> 8;
>>> +
>>> +               for (n_bit =; n_bit > 0; n_bit--) {
>>> +                       if (n_rem & 0x8000)
>>> +                               n_rem =n_rem << 1) ^ 0x3000;
>>> +                       else
>>> +                               n_rem <<=;
>>> +               }
>>> +       }
>>> +       n_rem >>=2;
>>> +       n_prom[0] =rc_read;
>>> +       return (n_rem =crc);
>>> +}
>>> +
>>> +static int ms5637_fill_calibration_coeffs(struct ms5637_dev 
>>> +*dev_data) {
>>> +       int i, ret =;
>>> +
>>> +       for (i =; i < MS5637_PROM_ELEMENTS_NB; i++) {
>>> +               ret =s5637_get_calibration_coeffs(dev_data, i,
>>> +                               &dev_data->calibration_coeffs
>>> +                               [i]);
> 
> linebreak looks weird before [i]
> 
>>> +
>>> +               dev_dbg(&dev_data->client->dev, "Coeff %d : %d", i,
>>> +                       dev_data->calibration_coeffs[i]);
> 
> debug output should be after validity check
> 
>>> +
>>> +               if (ret < 0) {
>>> +                       dev_err(&dev_data->client->dev,
>>> +                               "unable to get calibration 
>>> + coefficients at address %d\n",
> 
> Unable probably (uppercase all all other messages
> 
>>> +                               i + 1);
>>> +                       return ret;
>>> +               }
>>> +       }
>>> +
>>> +       if (!ms5637_crc_check(dev_data->calibration_coeffs,
>>> +                             (dev_data->
>>> +                              calibration_coeffs[0] & 0xF000) >> 12)) {
>>> +               dev_err(&dev_data->client->dev,
>>> +                       "Calibration coefficients crc check error\n");
>>> +               return -1;
>>> +       }
>>> +
>>> +       return 0;
>>> +}
>>> +
>>> +static int ms5637_read_adc_value(struct ms5637_dev *dev_data, u32 
>>> +*adc_value) {
>>> +       int ret =;
> 
> no need to initialize ret
> 
>>> +       u8 buf[3];
>>> +
>>> +       ret > > +           i2c_smbus_read_i2c_block_data(dev_data->client, MS5637_ADC_READ, 3,
>>> +                                         buf);
>>> +       if (ret < 0)
>>> +               return ret;
>>> +       dev_dbg(&dev_data->client->dev, "ADC raw value : %x %x %x\n", buf[0],
>>> +               buf[1], buf[2]);
>>> +       *adc_value =buf[0] << 16) + (buf[1] << 8) + buf[0];
>>> +       return 0;
>>> +}
>>> +
>>> +static int ms5637_conversion_and_read_adc(struct ms5637_dev *dev_data,
>>> +                                         u32 *t_adc, u32 *p_adc) {
>>> +       int ret;
>>> +
>>> +       /* Trigger Temperature conversion */
>>> +       ret =2c_smbus_write_byte(dev_data->client,
>>> +                                  MS5637_TEMPERATURE_CONVERSION_START
>>> +                                  + dev_data->resolution_index * 2);
>>> +       if (ret < 0)
>>> +               return ret;
>>> +       usleep_range(conversion_time[dev_data->resolution_index],
>>> +                    conversion_time[dev_data->resolution_index]+3000);
>>> +       /* Retrieve ADC value */
>>> +       ret =s5637_read_adc_value(dev_data, t_adc);
>>> +
>> No check for ret here? If this is not needed then you can remove the 
>> above assignment.
>>
>>> +       /* Trigger Pressure conversion */
>>> +       ret =2c_smbus_write_byte(dev_data->client,
>>> +                                  MS5637_PRESSURE_CONVERSION_START
>>> +                                  + dev_data->resolution_index * 2);
>>> +       if (ret < 0)
>>> +               return ret;
>>> +       usleep_range(conversion_time[dev_data->resolution_index],
>>> +                    conversion_time[dev_data->resolution_index]+3000);
>>> +       /* Retrieve ADC value */
>>> +       ret =s5637_read_adc_value(dev_data, p_adc);
>>> +
>> No new line here.
>>> +       if (ret < 0)
>>> +               return ret;
>>> +       return 0;
>>> +}
>>> +
>>> +static int ms5637_read_temperature_and_pressure(struct ms5637_dev 
>>> +*dev_data) {
>>> +       int ret =;
>>> +       u32 t_adc, p_adc;
>>> +       s32 dt, temp;
>>> +       s64 off, sens, t2, off2, sens2;
>>> +
>>> +       mutex_lock(&dev_data->lock);
>>> +
>>> +       if (time_after(jiffies, dev_data->last_update + HZ / 2) ||
>>> +           !dev_data->valid) {
>>> +               if (!dev_data->got_calibration_words) {
>>> +                       ret =s5637_fill_calibration_coeffs(dev_data);
>>> +                       if (ret < 0)
>>> +                               goto out;
>>> +
>>> +                       dev_data->got_calibration_words =rue;
>>> +               }
>>> +
>>> +               ret =s5637_conversion_and_read_adc(dev_data, 
>>> + &t_adc, &p_adc);
>>> +
> remove blank line
> 
>>> +               if (ret < 0) {
>>> +                       dev_data->got_calibration_words =alse;
>>> +                       dev_err(&dev_data->client->dev,
>>> +                               "unable to make sensor adc conversion\n");
>>> +                       goto out;
>>> +               }
>>> +
>>> +               dt =s32) t_adc - (dev_data->calibration_coeffs[5] 
>>> + << 8);
>>> +
>>> +               /* Actual temperature =000 + dT * TEMPSENS */
>>> +               temp > > +                   2000 + (((s64) dt * 
>>> + dev_data->calibration_coeffs[6]) >> 23);
>>> +
>>> +               /* Second order temperature compensation */
>>> +               if (temp < 2000) {
>>> +                       s64 tmp =s64) temp - 2000;
>>> +
>>> +                       t2 =3 * ((s64) dt * (s64) dt)) >> 33;
>>> +                       off2 =61 * tmp * tmp) >> 4;
>>> +                       sens2 =29 * tmp * tmp) >> 4;
>>> +
>>> +                       if (temp < -1500) {
>>> +                               s64 tmp =s64) temp + 1500;
>>> +
>>> +                               off2 +=7 * tmp * tmp;
>>> +                               sens2 += * tmp * tmp;
>>> +                       }
>>> +               } else {
>>> +                       t2 =5 * ((s64) dt * (s64) dt)) >> 38;
>>> +                       off2 =;
>>> +                       sens2 =;
>>> +               }
>>> +
>>> +               /* OFF =FF_T1 + TCO * dT */
>>> +               off =((s64) dev_data->calibration_coeffs[2]) << 17)
>>> +                   +
>>> +                   ((((s64) dev_data->calibration_coeffs[4]) * (s64) dt) >> 6);
>>> +               off -=ff2;
>>> +
>>> +               /* Sensitivity at actual temperature =ENS_T1 + TCS * dT */
>>> +               sens =((s64) dev_data->calibration_coeffs[1]) << 16)
>>> +                   + (((s64) dev_data->calibration_coeffs[3] * dt) >> 7);
>>> +               sens -=ens2;
>>> +
>>> +               /* Temperature compensated pressure =1 * SENS - OFF */
>>> +               dev_data->temperature =temp - t2) * 10;
>>> +               dev_data->pressure =u32) (((((s64) p_adc * sens) >> 21)
>>> +                                            - off) >> 15) / 100;
>>> +
>>> +               dev_data->last_update =iffies;
>>> +               dev_data->valid =rue;
>>> +       }
>>> + out:
>>> +       mutex_unlock(&dev_data->lock);
>>> +
>>> +       return ret >= ? 0 : ret;
>>> +}
>>> +
>>> +static int ms5637_read_raw(struct iio_dev *indio_dev,
>>> +                          struct iio_chan_spec const *channel, int *val,
>>> +                          int *val2, long mask) {
>>> +       int ret;
>>> +       struct ms5637_dev *dev_data =io_priv(indio_dev);
>>> +
>>> +       switch (mask) {
>>> +       case IIO_CHAN_INFO_PROCESSED:
>>> +               switch (channel->type) {
>>> +               case IIO_TEMP:  /* in 0.001 °C */
>>> +                       ret =s5637_read_temperature_and_pressure(dev_data);
>>> +                       if (ret)
>>> +                               goto t_err;
>>> +                       *val =ev_data->temperature;
>>> +                       break;
>>> +               case IIO_PRESSURE:      /* in mB */
> 
> IIO wants kilopoascal
> 
>>> +                       ret =s5637_read_temperature_and_pressure(dev_data);
>>> +                       if (ret)
>>> +                               goto p_err;
>>> +                       *val =ev_data->pressure;
>>> +                       break;
>>> +               default:
>>> +                       return -EINVAL;
>>> +               }
>>> +               ret =IO_VAL_INT;
>>> +               break;
>>> +       default:
>>> +               return -EINVAL;
>>> +       }
>>> +
>>> +       return ret;
> 
> should simplify control flow a bit, just return instead of breaking, jumping
> 
> is it really necesary to have two different error messages?
> could just code the call to ms5637_read_temperature_and_pressure() once
> 
>>> + t_err:
>>> +       dev_err(&indio_dev->dev, "Temperature read error\n");
>>> +       return ret;
>>> + p_err:
>>> +       dev_err(&indio_dev->dev, "Pressure read error\n");
>>> +       return ret;
>>> +}
>>> +
>>> +static const struct iio_chan_spec ms5637_channels[] =
>>> +       {
>>> +        .type =IO_TEMP,
>>> +        .output =,
>>> +        .info_mask_separate =IT(IIO_CHAN_INFO_PROCESSED),
>>> +        .scan_index =,
>>> +        },
>>> +       {
>>> +        .type =IO_PRESSURE,
>>> +        .output =,
> 
> output is for output channels, I guess the ms5637 cannot change the weather :)
> 
>>> +        .info_mask_separate =IT(IIO_CHAN_INFO_PROCESSED),
>>> +        .scan_index =,
> 
> no need set the scan_index
> 
>>> +        }
>>> +};
>>> +
>>> +static ssize_t ms5637_read_attr(struct device *dev,
>>> +                               struct device_attribute *attr, char 
>>> +*buf) {
>>> +       struct iio_dev *indio_dev =ev_to_iio_dev(dev);
>>> +       struct ms5637_dev *dev_data =io_priv(indio_dev);
>>> +       struct iio_dev_attr *this_attr =o_iio_dev_attr(attr);
>>> +       int ret =;
>>> +
>>> +       switch (this_attr->address) {
>>> +       case ATTR_RESET:
>>> +               ret =printf(buf, "0\n");
>>> +               break;
>>> +       case ATTR_RESOLUTION:
> 
> uhuh, private ABI
> maybe this could be modelled by IIO's integration time?
> 
>>> +               ret =printf(buf, "%d\n", dev_data->resolution_index + 8);
>>> +               break;
>>> +       default:
>>> +               return -EINVAL;
>>> +       }
>>> +
>>> +       return ret;
>>> +}
>>> +
>>> +static ssize_t ms5637_write_attr(struct device *dev,
>>> +                                struct device_attribute *attr,
>>> +                                const char *buf, size_t len) {
>>> +       struct iio_dev *indio_dev =ev_to_iio_dev(dev);
>>> +       struct ms5637_dev *dev_data =io_priv(indio_dev);
>>> +       struct iio_dev_attr *this_attr =o_iio_dev_attr(attr);
>>> +       u8 val;
>>> +       int ret;
>>> +
>>> +       ret =strtou8(buf, 10, &val);
>>> +       if (ret)
>>> +               return ret;
>>> +
>>> +       mutex_lock(&dev_data->lock);
>>> +       switch (this_attr->address) {
>>> +       case ATTR_RESET:
>>> +               if (val !=)
>>> +                       goto einval;
>>> +
>>> +               ret =2c_smbus_write_byte(dev_data->client, MS5637_RESET);
>>> +               if (ret < 0)
>>> +                       goto out;
>>> +               usleep_range(3000, 6000);
>>> +
>>> +               break;
>>> +       case ATTR_RESOLUTION:
>>> +               if ((val < 8) || (val > 13))
>>> +                       goto einval;
>>> +               dev_data->resolution_index =al - 8;
>>> +               break;
>>> +       default:
>>> +               goto einval;
>>> +       }
>>> +
>>> +       dev_data->valid =alse;
>>> +       goto out;
>>> + einval:
>>> +       ret =EINVAL;
>>> + out:
>>> +       mutex_unlock(&dev_data->lock);
>>> +
>>> +       return ret ? ret : len;
>>> +}
>>> +
>>> +static IIO_DEVICE_ATTR(in_reset,
>>> +                      S_IRUGO | S_IWUSR,
>>> +                      ms5637_read_attr, ms5637_write_attr, 
>>> +ATTR_RESET); static IIO_DEVICE_ATTR(in_resolution,
>>> +                      S_IRUGO | S_IWUSR,
>>> +                      ms5637_read_attr, ms5637_write_attr, 
>>> +ATTR_RESOLUTION); static IIO_CONST_ATTR(resolution_available, "8 9 
>>> +10 11 12 13");
>>> +
>>> +static struct attribute *ms5637_attributes[] =
>>> +       &iio_dev_attr_in_reset.dev_attr.attr,
>>> +       &iio_dev_attr_in_resolution.dev_attr.attr,
>>> +       &iio_const_attr_resolution_available.dev_attr.attr,
>>> +       NULL,
>>> +};
>>> +
>>> +static const struct attribute_group ms5637_attribute_group =
>>> +       .attrs = s5637_attributes,
>>> +};
>>> +
>>> +static const struct iio_info ms5637_info =
>>> +       .read_raw = s5637_read_raw,
>>> +       .attrs =ms5637_attribute_group,
>>> +       .driver_module =HIS_MODULE, };
>>> +
>>> +static int ms5637_probe(struct i2c_client *client,
>>> +                       const struct i2c_device_id *id) {
>>> +       struct ms5637_dev *dev_data;
>>> +       struct iio_dev *indio_dev;
>>> +       int ret;
>>> +
>>> +       if (!i2c_check_functionality(client->adapter,
>>> +                                    I2C_FUNC_SMBUS_READ_WORD_DATA)) {
>>> +               dev_err(&client->dev,
>>> +                       "adapter does not support SMBus read word transactions\n");
>>> +               return -ENODEV;
>>> +       }
>>> +
>>> +       if (!i2c_check_functionality(client->adapter,
>>> +                                    I2C_FUNC_SMBUS_WRITE_BYTE)) {
>>> +               dev_err(&client->dev,
>>> +                       "adapter does not support SMBus write byte transactions\n");
>>> +               return -ENODEV;
>>> +       }
>>> +
>>> +       if (!i2c_check_functionality(client->adapter,
>>> +                                    I2C_FUNC_SMBUS_READ_I2C_BLOCK)) {
>>> +               dev_err(&client->dev,
>>> +                       "adapter does not support SMBus read block transactions\n");
>>> +               return -ENODEV;
>>> +       }
>>> +
>>> +       indio_dev =evm_iio_device_alloc(&client->dev, sizeof(*dev_data));
>>> +       if (!indio_dev)
>>> +               return -ENOMEM;
>>> +
>>> +       dev_data =io_priv(indio_dev);
>>> +       dev_data->client =lient;
>>> +       mutex_init(&dev_data->lock);
>>> +
>>> +       indio_dev->info =ms5637_info;
>>> +       indio_dev->name =d->name;
>>> +       indio_dev->dev.parent =client->dev;
>>> +       indio_dev->modes =NDIO_DIRECT_MODE;
>>> +       indio_dev->channels =s5637_channels;
>>> +       indio_dev->num_channels =RRAY_SIZE(ms5637_channels);
>>> +
>>> +       i2c_set_clientdata(client, indio_dev);
>>> +       ret =io_device_register(indio_dev);
>>> +       if (ret < 0)
>>> +               return ret;
>>> +
>>> +       ret =2c_smbus_write_byte(client, MS5637_RESET);
> 
> I'd rather do this before iio_device_register() -- what happens when it fails? there is no unregister()
> 
>>> +       if (ret < 0)
>>> +               return ret;
>>> +       usleep_range(3000, 6000);
>>> +
>>> +       ret =s5637_fill_calibration_coeffs(dev_data);
>>> +       if (ret =0)
>>> +               dev_data->got_calibration_words =rue;
>>> +
>>> +       if (ret < 0)
>>> +               return ret;
>>> +
>>> +       dev_dbg(&client->dev, "Driver initialization done");
>>> +       return 0;
>>> +}
>>> +
>>> +static int ms5637_remove(struct i2c_client *client) {
>>> +       struct iio_dev *indio_dev =2c_get_clientdata(client);
>>> +
>>> +       iio_device_unregister(indio_dev);
>>> +
>>> +       return 0;
>>> +}
>>> +
>>> +static const struct i2c_device_id ms5637_id[] =
>>> +       {"ms5637", 0},
>>> +       {}
>>> +};
>>> +
>>> +static struct i2c_driver ms5637_driver =
>>> +       .probe = s5637_probe,
>>> +       .remove =s5637_remove,
>>> +       .id_table =s5637_id,
>>> +       .driver =
>>> +                  .name = ms5637",
>>> +                  .owner =HIS_MODULE,
>>> +                  },
>>> +};
>>> +
>>> +module_i2c_driver(ms5637_driver);
>>> +
>>> +MODULE_LICENSE("GPL");
>>> +MODULE_DESCRIPTION("Measurement Specialties MS5637 temperature 
>>> +driver"); MODULE_AUTHOR("William Markezana 
>>> +<william.markezana@meas-spec.com>");
>>> +MODULE_AUTHOR("Ludovic Tancerel 
>>> +<ludovic.tancerel@maplehightech.com>");
>>> diff --git a/drivers/staging/iio/Documentation/pressure/ms5637 
>>> b/drivers/staging/iio/Documentation/pressure/ms5637
>>> new file mode 100644
>>> index 0000000..d0d64f3
>>> --- /dev/null
>>> +++ b/drivers/staging/iio/Documentation/pressure/ms5637
>>> @@ -0,0 +1,25 @@
>>> +Kernel driver ms5637
>>> +==================
>>> +
>>> +Supported chips:
>>> +  * Measurement Specialties MS5637
>>> +    Prefix: 'ms5637'
>>> +    Addresses scanned: I2C 0x76
> 
> 0x77 is claimed at the top of ms5637.c
> 
>>> +    Datasheet: Available for download on meas-spec.com
>>> +
>>> +Authors:
>>> +    William Markezana (Meas-Spec) <william.markezana@meas-spec.com>
>>> +    Ludovic Tancerel <ludovic.tancerel@maplehightech.com>
>>> +
>>> +Description
>>> +-----------
>>> +
>>> +The MS5637 is a single chip pressure & temperature sensor.
>>> +The driver returns a milli-bar pressure value and a milli-degre 
>>> +celius value using the iio framework
> 
> degree; the information so far is redundant
> 
>>> +
>>> +Via the iio sysfs interface, there are several attributes available.
>>> +in_reset - Reset ms5637 device by writing a 1 in it.
>>> +in_resolution - Set the number of bits for ADC resolution.
>>> +out_pressure_input - Current pressure from ms5637 sensor 
>>> +(milli-bar) out_temp_input - Current temperature from htu21 sensor 
>>> +(milli-°C value) resolution_available - List of resolutions 
>>> +supported
> 
> in_, not out_
> 
> regular IIO channels (integration time?) could/should be used
> 
> I don't know about reset, needed?
> 
> private ABI should go to documentation/ABI/testing/sysfs-bus-iio-*
> 
>>> --
>>> 1.7.9.5
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe 
>>> linux-kernel" in the body of a message to majordomo@vger.kernel.org 
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>> --
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-kernel" in the body of a message to majordomo@vger.kernel.org 
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 

