Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbaGVH6Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 03:58:16 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:51116 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbaGVH6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 03:58:15 -0400
Date: Tue, 22 Jul 2014 08:58:08 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Wei-Chun Pan <weichun.pan@advantech.com.tw>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>,
        "Louis.Lu" <Louis.Lu@advantech.com.tw>,
        "Neo.Lo" <neo.lo@advantech.com.tw>,
        "Hank.Peng" <Hank.Peng@advantech.com.tw>,
        "Kevin.Ong" <Kevin.Ong@advantech.com.tw>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mfd: imanager2: Add defines support for IT8516/18/28
Message-ID: <20140722075808.GD28529@lee--X1>
References: <1405342486-17031-1-git-send-email-weichun.pan@advantech.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405342486-17031-1-git-send-email-weichun.pan@advantech.com.tw>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch needs a commit log.  In fact, it can be squashed into the
first commit which uses these defines.

> Signed-off-by: Wei-Chun Pan <weichun.pan@advantech.com.tw>
> ---
>  include/linux/mfd/imanager2_ec.h | 358 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 358 insertions(+)
>  create mode 100644 include/linux/mfd/imanager2_ec.h
> 
> diff --git a/include/linux/mfd/imanager2_ec.h b/include/linux/mfd/imanager2_ec.h
> new file mode 100644
> index 0000000..bf7d70e
> --- /dev/null
> +++ b/include/linux/mfd/imanager2_ec.h
> @@ -0,0 +1,358 @@
> +/*
> + * imanager2_ec.h - MFD driver defines of Advantech EC IT8516/18/28
> + * Copyright (C) 2014  Richard Vidal-Dorsch <richard.dorsch@advantech.com>
> + *
> + * This program is free software: you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, either version 3 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.

This is the looooong version of the licence.  Can you find the shorter one.

> + */
> +
> +#ifndef __IMANAGER2_EC_H__
> +#define __IMANAGER2_EC_H__
> +
> +#include <linux/mutex.h>
> +
> +#define EC_FLAG_IO		0
> +#define EC_FLAG_IO_MAILBOX	(1 << 0)
> +#define EC_FLAG_MAILBOX		(1 << 1)

Use BIT(0), BIT(1) instead.

> +#define EC_MAX_DEVICE_ID_NUM	0xFF
> +#define EC_MAX_ITEM_NUM		32
> +
> +struct ec_table {
> +	u8 devid2itemnum[EC_MAX_DEVICE_ID_NUM];
> +	u8 pinnum[EC_MAX_ITEM_NUM];
> +	u8 devid[EC_MAX_ITEM_NUM];
> +};
> +
> +struct ec_version {
> +	u16 kernel_ver,
> +	    chip_code,
> +	    prj_id,
> +	    prj_ver;

Declare these separately.

> +};
> +
> +#define EC_MAX_LEN_PROJECT_NAME	8

Find a way to do this dynamically, or use 'const char *' instead.

> +struct imanager2 {
> +	u16 id;
> +	u32 flag;
> +	struct mutex lock;				/* protects io */

                                              We know what locks do.

> +	char prj_name[EC_MAX_LEN_PROJECT_NAME + 1];	/* strlen + '\0' */

                                              We know how strings work. 

> +	struct ec_version version;
> +	struct ec_table table;

'table' is awfully generic.

> +};

Use KernelDoc to document the main container.

> +/*
> + * Definition
> + */

This comment is not adding anything to the code here.

> +#define EC_TABLE_ITEM_UNUSED	0xFF
> +#define EC_TABLE_DID_NODEV	0x00
> +#define EC_TABLE_HWP_NODEV	0xFF
> +#define EC_TABLE_NOITEM		0xFF
> +
> +#define EC_ERROR		0xFF
> +
> +#define EC_RAM_BANK_SIZE	32	/* 32 bytes size for each bank. */
> +#define EC_RAM_BUFFER_SIZE	256	/* 32 bytes * 8 banks = 256 bytes */
> +
> +#define EC_SIO_CMD		0x29C
> +#define EC_SIO_DATA		0x29D

12bit commands?  Or are these 16bit and should have a leading 0?

> +/* Access Mailbox */
> +#define EC_IO_PORT_CMD		0x29A
> +#define EC_IO_PORT_DATA		0x299
> +
> +#define EC_IO_CMD_READ_OFFSET	0xA0
> +#define EC_IO_CMD_WRITE_OFFSET	0x50

Should these have leading 0's too?

> +#define EC_ITE_PORT_OFS		0x29E
> +#define EC_ITE_PORT_DATA	0x29F
> +
> +/*
> + * CMD - IO
> + */

Drop this.

> +/* ADC */
> +#define EC_CMD_ADC_INDEX				0x15
> +#define EC_CMD_ADC_READ_LSB				0x16
> +#define EC_CMD_ADC_READ_MSB				0x1F
> +/* HW Control Table */
> +#define EC_CMD_HWCTRLTABLE_INDEX			0x20
> +#define EC_CMD_HWCTRLTABLE_GET_PIN_NUM			0x21
> +#define EC_CMD_HWCTRLTABLE_GET_DEVICE_ID		0x22
> +#define EC_CMD_HWCTRLTABLE_GET_PIN_ACTIVE_POLARITY	0x23
> +/* ACPI RAM */
> +#define EC_CMD_ACPIRAM_READ				0x80
> +#define EC_CMD_ACPIRAM_WRITE				0x81
> +/* Extend RAM */
> +#define EC_CMD_EXTRAM_READ				0x86
> +#define EC_CMD_EXTRAM_WRITE				0x87
> +/* HW RAM */
> +#define EC_CMD_HWRAM_READ				0x88
> +#define EC_CMD_HWRAM_WRITE				0x89
> +
> +/*
> + * ACPI RAM Address Table
> + */
> +/* n = 1 ~ 2 */

Please accompany with words.  Random math is seldom helpful.

I'm guessing that you mean valid values of 'n' can be 1 or 2, but this
is unclear.

> +#define EC_ACPIRAM_ADDR_TEMPERATURE_BASE(n)	(0x60 + 3 * ((n) - 1))

What is 0x60?  Why 3?  Please use #defines for these numbers.

> +#define	EC_ACPIRAM_ADDR_LOCAL_TEMPERATURE(n) \
> +	EC_ACPIRAM_ADDR_TEMPERATURE_BASE(n)
> +#define	EC_ACPIRAM_ADDR_REMOTE_TEMPERATURE(n) \
> +	(EC_ACPIRAM_ADDR_TEMPERATURE_BASE(n) + 1)
> +#define	EC_ACPIRAM_ADDR_WARNING_TEMPERATURE(n)\
> +	(EC_ACPIRAM_ADDR_TEMPERATURE_BASE(n) + 2)
> +
> +/* N = 0 ~ 2 */

Please accompany with words.  Random math is seldom helpful.

> +#define EC_ACPIRAM_ADDR_FAN_SPEED_BASE(N)	(0x70 + 2 * (N))

No magic numbers.  Why are you using 'N' here and 'n' before?

> +#define EC_ACPIRAM_ADDR_KERNEL_MAJOR_VERSION	0xF8
> +#define EC_ACPIRAM_ADDR_CHIP_VENDOR_CODE	0xFA
> +#define EC_ACPIRAM_ADDR_PROJECT_NAME_CODE	0xFC
> +#define EC_ACPIRAM_ADDR_FIRMWARE_MAJOR_VERSION	0xFE
> +
> +/*
> + * HW RAM Address Table
> + */
> +/* Thermal Source Control RAM 0xB0-0xC7 (N: 0 ~ 3) */
> +#define EC_HWRAM_ADDR_THERMAL_SOURCE_BASE_ADDR(N)	(0xB0 + 6 * (N))

Same comments as above.

> +#define EC_HWRAM_ADDR_THERMAL_SOURCE_SMB_CHANNEL(N) \
> +	EC_HWRAM_ADDR_THERMAL_SOURCE_BASE_ADDR(N)
> +#define EC_HWRAM_ADDR_THERMAL_SOURCE_SMB_ADDR(N) \
> +	(EC_HWRAM_ADDR_THERMAL_SOURCE_BASE_ADDR(N) + 1)
> +#define EC_HWRAM_ADDR_THERMAL_SOURCE_SMB_CMD(N)	 \
> +	(EC_HWRAM_ADDR_THERMAL_SOURCE_BASE_ADDR(N) + 2)
> +#define EC_HWRAM_ADDR_THERMAL_SOURCE_SMB_STATUS(N) \
> +	(EC_HWRAM_ADDR_THERMAL_SOURCE_BASE_ADDR(N) + 3)
> +#define EC_HWRAM_ADDR_THERMAL_SOURCE_SMB_FAN_CODE(N) \
> +	(EC_HWRAM_ADDR_THERMAL_SOURCE_BASE_ADDR(N) + 4)
> +#define EC_HWRAM_ADDR_THERMAL_SOURCE_SMB_TEMPERATURE(N) \
> +	(EC_HWRAM_ADDR_THERMAL_SOURCE_BASE_ADDR(N) + 5)

Place more '\n' spacers in - these are difficult to read.

> +/* Fan Control 0xD0-0xEF (N: 0 ~ 3) */
> +#define EC_HWRAM_ADDR_FAN_BASE_ADDR(N)	(0xD0 + 0x10 * (N))
> +#define EC_HWRAM_ADDR_FAN_CODE(N)	EC_HWRAM_ADDR_FAN_BASE_ADDR(N)
> +#define EC_HWRAM_ADDR_FAN_STATUS(N)	(EC_HWRAM_ADDR_FAN_BASE_ADDR(N) + 1)
> +#define EC_HWRAM_ADDR_FAN_CONTROL(N)	(EC_HWRAM_ADDR_FAN_BASE_ADDR(N) + 2)
> +#define EC_HWRAM_ADDR_FAN_TEMP_HI(N)	(EC_HWRAM_ADDR_FAN_BASE_ADDR(N) + 3)
> +#define EC_HWRAM_ADDR_FAN_TEMP_LO(N)	(EC_HWRAM_ADDR_FAN_BASE_ADDR(N) + 4)
> +#define EC_HWRAM_ADDR_FAN_TEMP_LOSTOP(N) \
> +					(EC_HWRAM_ADDR_FAN_BASE_ADDR(N) + 5)
> +#define EC_HWRAM_ADDR_FAN_PWM_HI(N)	(EC_HWRAM_ADDR_FAN_BASE_ADDR(N) + 6)
> +#define EC_HWRAM_ADDR_FAN_PWM_LO(N)	(EC_HWRAM_ADDR_FAN_BASE_ADDR(N) + 7)
> +
> +/*
> + * OFS - Mailbox
> + */
> +/* Mailbox Structure */
> +#define EC_MAILBOX_OFFSET_CMD		0x00
> +#define EC_MAILBOX_OFFSET_STATUS	0x01
> +#define EC_MAILBOX_OFFSET_PARA		0x02
> +#define EC_MAILBOX_OFFSET_DAT(N)	(0x03 + (N))	/* N = 0x00 ~ 0x2C */
> +
> +/*
> + * CMD - Mailbox
> + */
> +/* GPIO */
> +#define EC_CMD_MAILBOX_READ_HW_PIN				0x11
> +#define EC_CMD_MAILBOX_WRITE_HW_PIN				0x12
> +/* Storage */
> +#define EC_CMD_MAILBOX_READ_EC_RAM				0x1E
> +#define EC_CMD_MAILBOX_WRITE_EC_RAM				0x1F
> +/* OTHERS */
> +#define EC_CMD_MAILBOX_READ_DYNAMIC_TABLE			0x20
> +/* Thermal Protect */
> +#define EC_CMD_MAILBOX_READ_THERMAL_SOURCE			0x42
> +#define EC_CMD_MAILBOX_WRITE_THERMAL_SOURCE			0x43
> +/* Storage */
> +#define EC_CMD_MALLBOX_CLEAR_256_BYTES_BUFFER			0xC0
> +#define EC_CMD_MALLBOX_READ_256_BYTES_BUFFER			0xC1
> +#define EC_CMD_MALLBOX_WRITE_256_BYTES_BUFFER			0xC2
> +#define EC_CMD_MALLBOX_READ_EEPROM_DATA_FROM_256_BYTES_BUFFER	0xC3
> +#define EC_CMD_MALLBOX_WRITE_256_BYTES_BUFFER_INTO_EEPROM_DATA	0xC4
> +/* General Mailbox Command */
> +#define EC_CMD_MAILBOX_GET_FIRMWARE_VERSION_AND_PROJECT_NAME	0xF0
> +#define EC_CMD_MAILBOX_CLEAR_ALL				0xFF
> +
> +/*
> + * Status - Mailbox
> + */
> +#define EC_MAILBOX_STATUS_FAIL		0x00
> +#define EC_MAILBOX_STATUS_SUCCESS	0x01
> +
> +/*
> + * PARA - Mailbox
> + */
> +/* RAM Type */
> +#define EC_RAM_BANK_ACPI	0x01
> +#define EC_RAM_BANK_HW		0x02
> +#define EC_RAM_BANK_EXT		0x03
> +#define EC_RAM_BANK_BUFFER	0x06
> +/* Dynamic Type */
> +#define EC_DYNAMIC_DEVICE_ID	0x00
> +#define EC_DYNAMIC_HW_PIN	0x01
> +#define EC_DYNAMIC_POLARITY	0x02
> +
> +/*
> + * Functions - Mailbox
> + */
> +/* command = 0x20 */
> +int imanager2_mbox_get_dynamic_table(u32 ecflag, u8 type, u8 *table);
> +/* command = 0x42 */
> +int imanager2_mbox_read_thermalzone(u32 ecflag, u8 zone, u8 *smbid, u8 *fanid,
> +				    u8 *buf, int *len);
> +/* command = 0xC0 */
> +int imanager2_mbox_clear_ram(u32 ecflag);
> +/* command = 0xC1 */
> +int imanager2_mbox_read_ram_across_banks(u32 ecflag, u8 *data, int len);
> +/* command = 0x1E */
> +int imanager2_mbox_read_ram(u32 ecflag, u8 bank, u8 offset, u8 *buf, u8 len);
> +/* command = 0x1F */
> +int imanager2_mbox_write_ram(u32 ecflag, u8 bank, u8 offset, u8 *buf, u8 len);
> +/* command = 0xF0 */
> +int imanager2_mbox_get_project_information(u32 ecflag, u8 *prj_name,
> +					   u16 *kernel_ver, u16 *chip_code,
> +					   u16 *prj_id, u16 *prj_ver);
> +
> +/*
> + * Functions - basic
> + */
> +#define IO_FLAG_OBF	(1 << 0)	/* output buffer full */
> +#define IO_FLAG_IBF	(1 << 1)	/* input buffer full  */

use BIT()

> +int ec_inb_after_obf1(u8 *data);
> +int ec_outb_after_ibc0(u16 port, u8 data);
> +/* ITE mailbox access */
> +int imanager2_mbox_read_data(u32 ecflag, u8 cmd, u8 para, u8 *data, int len);
> +int imanager2_mbox_write_data(u32 ecflag, u8 cmd, u8 para, u8 *data, int len);
> +/* only IO access */
> +int imanager2_mbox_io_read(u8 command, u8 offset, u8 *buf, u8 len);
> +int imanager2_mbox_io_write(u8 command, u8 offset, u8 *buf, u8 len);
> +int imanager2_mbox_io_simple_read(u8 command, u8 *value);
> +/* ITE Mailbox & IO access */
> +int imanager2_mbox_read_ram_support_io(u32 ecflag, u8 bank, u8 addr, u8 *buf,
> +				       u8 len);
> +
> +/*
> + * Device ID
> + */

Comments with the same information is as the type/variable name are
not helpful.  Please remove.

> +enum ec_device_id {
> +	/* GPIO */
> +	altgpio0 = 0x10,	/* 0x10 */

                                You're joking right? 

> +	altgpio1,
> +	altgpio2,
> +	altgpio3,
> +	altgpio4,
> +	altgpio5,
> +	altgpio6,
> +	altgpio7,
> +	/* GPIO - Button */
> +	btn0,
> +	btn1,
> +	btn2,
> +	btn3,
> +	btn4,
> +	btn5,
> +	btn6,
> +	btn7,
> +	/* PWM - Fan */
> +	cpufan_2p,		/* 0x20 */

Remove these comments.

> +	cpufan_4p,
> +	sysfan1_2p,
> +	sysfan1_4p,
> +	sysfan2_2p,
> +	sysfan2_4p,
> +	/* PWM - Brightness Control */
> +	pwmbrightness,
> +	/* PWM - System Speaker */
> +	pwmbeep,
> +	/* SMBus */
> +	smboem0,
> +	smboem1,
> +	smboem2,
> +	smbeeprom,
> +	smbthermal0,
> +	smbthermal1,
> +	smbsecurityeep,
> +	i2coem,
> +	/* DAC - Speaker */
> +	dacspeaker,		/* 0x30 */
> +	/* SMBus */
> +	smbeep2k = 0x38,
> +	oemeep,
> +	oemeep2k,
> +	peci,
> +	smboem3,
> +	smblink,
> +	smbslv,
> +	/* GPIO - LED */
> +	powerled = 0x40,	/* 0x40 */
> +	batledg,
> +	oemled0,
> +	oemled1,
> +	oemled2,
> +	batledr,
> +	/* SMBus - Smart Battery */
> +	smartbat1 = 0x48,
> +	smartbat2,
> +	/* ADC */
> +	adcmosbat = 0x50,	/* 0x50 */
> +	adcmosbatx2,
> +	adcmosbatx10,
> +	adcbat,
> +	adcbatx2,
> +	adcbatx10,
> +	adc5vs0,
> +	adc5vs0x2,
> +	adc5vs0x10,
> +	adv5vs5,
> +	adv5vs5x2,
> +	adv5vs5x10,
> +	adc33vs0,
> +	adc33vs0x2,
> +	adc33vs0x10,
> +	adc33vs5,
> +	adc33vs5x2,		/* 0x60 */
> +	adc33vs5x10,
> +	adv12vs0,
> +	adv12vs0x2,
> +	adv12vs0x10,
> +	adcvcorea,
> +	adcvcoreax2,
> +	adcvcoreax10,
> +	adcvcoreb,
> +	adcvcorebx2,
> +	adcvcorebx10,
> +	adcdc,
> +	adcdcx2,
> +	adcdcx10,
> +	adcdcstby,
> +	adcdcstbyx2,
> +	adcdcstbyx10,		/* 0x70 */
> +	adcdcother,
> +	adcdcotherx2,
> +	adcdcotherx10,
> +	adccurrent,
> +	/* IRQ - Watchdog */
> +	wdirq = 0x78,
> +	/* GPIO - Watchdog */
> +	wdnmi,
> +	/* Tacho - Fan */
> +	tacho0 = 0x80,		/* 0x80 */
> +	tacho1,
> +	tacho2,
> +	/* PWM - Brightness Control */
> +	pwmbrightness2 = 0x88,
> +	/* GPIO - Backlight Control */
> +	brionoff1,
> +	brionoff2,
> +};
> +
> +#endif /* __IMANAGER2_EC_H__ */

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
