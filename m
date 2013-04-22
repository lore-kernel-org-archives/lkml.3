Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab3DVNeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 09:34:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58148 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751450Ab3DVNeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 09:34:21 -0400
Date: Mon, 22 Apr 2013 14:34:18 +0100
From: Mark Brown <broonie@kernel.org>
To: Anthony Olech <anthony.olech.opensource@diasemi.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Steven Toth <stoth@kernellabs.com>,
        Michael Krufky <mkrufky@kernellabs.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [NEW DRIVER V6 1/7] drivers/mfd: DA9058 MFD core driver
Message-ID: <20130422133417.GN30351@opensource.wolfsonmicro.com>
References: <201304191722.r3JHMGqA019124@latitude>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O27Gs9jTTFWz3gAR"
Content-Disposition: inline
In-Reply-To: <201304191722.r3JHMGqA019124@latitude>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O27Gs9jTTFWz3gAR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 19, 2013 at 05:56:24PM +0100, Anthony Olech wrote:

> +static struct da9058_regulator_pdata buck1_pdata =3D {
> +	.init.constraints.name =3D "DA9058_BUCK1",
> +	.regulator_id =3D DA9058_BUCK_1,
> +	.init.constraints.min_uV =3D DA9058_BUCK12_VOLT_LOWER * 1000,
> +	.init.constraints.max_uV =3D DA9058_BUCK12_VOLT_UPPER * 1000,
> +	.control_voltage_step =3D DA9058_BUCK_VOLT_STEP * 1000,
> +	.control_register =3D DA9058_BUCK1_REG,
> +	.control_step_mask =3D DA9058_MAX_VSEL,
> +	.control_enable_mask =3D DA9058_BUCK_LDO_EN,
> +	.ramp_register =3D DA9058_SUPPLY_REG,
> +	.ramp_enable_mask =3D DA9058_SUPPLY_VBUCK1GO,
> +	.init.constraints.valid_ops_mask =3D REGULATOR_CHANGE_VOLTAGE |
> +			REGULATOR_CHANGE_MODE | REGULATOR_CHANGE_STATUS,
> +	.init.constraints.valid_modes_mask =3D REGULATOR_MODE_NORMAL,
> +	.init.constraints.boot_on =3D 1,

No, you're totally missing the point here.  Your regulator driver needs
to be generic and work on any machine using the device.  This means you
can't specify any constraints, the constraints need to come from the
system integration.

> +};
> +
> +static struct da9058_regulator_pdata buck2_pdata =3D {
> +	.init.constraints.name =3D "DA9058_BUCK2",
> +	.regulator_id =3D DA9058_BUCK_2,
> +	.init.constraints.min_uV =3D DA9058_BUCK12_VOLT_LOWER * 1000,
> +	.init.constraints.max_uV =3D DA9058_BUCK12_VOLT_UPPER * 1000,
> +	.control_voltage_step =3D DA9058_BUCK_VOLT_STEP * 1000,
> +	.control_register =3D DA9058_BUCK2_REG,
> +	.control_step_mask =3D DA9058_MAX_VSEL,
> +	.control_enable_mask =3D DA9058_BUCK_LDO_EN,
> +	.ramp_register =3D DA9058_SUPPLY_REG,
> +	.ramp_enable_mask =3D DA9058_SUPPLY_VBUCK2GO,
> +	.init.constraints.valid_ops_mask =3D REGULATOR_CHANGE_VOLTAGE |
> +			REGULATOR_CHANGE_MODE,
> +	.init.constraints.valid_modes_mask =3D REGULATOR_MODE_NORMAL,
> +	.init.constraints.always_on =3D 1,
> +};
> +
> +static struct da9058_regulator_pdata buck3_pdata =3D {
> +	.init.constraints.name =3D "DA9058_BUCK3",
> +	.regulator_id =3D DA9058_BUCK_3,
> +	.init.constraints.min_uV =3D DA9058_BUCK3_VOLT_LOWER * 1000,
> +	.init.constraints.max_uV =3D DA9058_BUCK3_VOLT_UPPER * 1000,
> +	.control_voltage_step =3D DA9058_BUCK_VOLT_STEP * 1000,
> +	.control_register =3D DA9058_BUCK3_REG,
> +	.control_step_mask =3D DA9058_MAX_VSEL,
> +	.control_enable_mask =3D DA9058_BUCK_LDO_EN,
> +	.ramp_register =3D DA9058_SUPPLY_REG,
> +	.ramp_enable_mask =3D DA9058_SUPPLY_VBUCK3GO,
> +	.init.constraints.valid_ops_mask =3D REGULATOR_CHANGE_VOLTAGE |
> +			REGULATOR_CHANGE_MODE | REGULATOR_CHANGE_STATUS,
> +	.init.constraints.valid_modes_mask =3D REGULATOR_MODE_NORMAL,
> +	.init.constraints.boot_on =3D 1,
> +};
> +
> +static struct da9058_regulator_pdata buck4_pdata =3D {
> +	.init.constraints.name =3D "DA9058_BUCK4",
> +	.regulator_id =3D DA9058_BUCK_4,
> +	.init.constraints.min_uV =3D DA9058_BUCK4_VOLT_LOWER * 1000,
> +	.init.constraints.max_uV =3D DA9058_BUCK4_VOLT_UPPER * 1000,
> +	.control_voltage_step =3D DA9058_BUCK_VOLT_STEP * 1000,
> +	.control_register =3D DA9058_BUCK4_REG,
> +	.control_step_mask =3D DA9058_MAX_VSEL,
> +	.control_enable_mask =3D DA9058_BUCK_LDO_EN,
> +	.ramp_register =3D DA9058_SUPPLY_REG,
> +	.ramp_enable_mask =3D DA9058_SUPPLY_VBUCK4GO,
> +	.init.constraints.valid_ops_mask =3D REGULATOR_CHANGE_VOLTAGE |
> +			REGULATOR_CHANGE_MODE | REGULATOR_CHANGE_STATUS,
> +	.init.constraints.valid_modes_mask =3D REGULATOR_MODE_NORMAL,
> +};
> +
> +static struct da9058_regulator_pdata ldo1_pdata =3D {
> +	.init.constraints.name =3D "DA9058_LDO1",
> +	.regulator_id =3D DA9058_LDO_1,
> +	.init.constraints.min_uV =3D DA9058_LDO_VOLT_LOWER * 1000,
> +	.init.constraints.max_uV =3D DA9058_LDO_VOLT_UPPER * 1000,
> +	.control_voltage_step =3D DA9058_LDO_VOLT_STEP * 1000,
> +	.control_register =3D DA9058_LDO1_REG,
> +	.control_step_mask =3D DA9058_MAX_VSEL,
> +	.control_enable_mask =3D DA9058_BUCK_LDO_EN,
> +	.init.constraints.valid_ops_mask =3D REGULATOR_CHANGE_VOLTAGE |
> +			REGULATOR_CHANGE_STATUS,
> +	.init.constraints.valid_modes_mask =3D REGULATOR_MODE_NORMAL,
> +	.init.constraints.boot_on =3D 1,
> +};
> +
> +static struct da9058_regulator_pdata ldo2_pdata =3D {
> +	.init.constraints.name =3D "DA9058_LDO2",
> +	.regulator_id =3D DA9058_LDO_2,
> +	.init.constraints.min_uV =3D DA9058_LDO_VOLT_LOWER * 1000,
> +	.init.constraints.max_uV =3D DA9058_LDO_VOLT_UPPER * 1000,
> +	.control_voltage_step =3D DA9058_LDO_VOLT_STEP * 1000,
> +	.control_register =3D DA9058_LDO2_REG,
> +	.control_step_mask =3D DA9058_MAX_VSEL,
> +	.control_enable_mask =3D DA9058_BUCK_LDO_EN,
> +	.init.constraints.valid_ops_mask =3D REGULATOR_CHANGE_VOLTAGE |
> +			REGULATOR_CHANGE_STATUS,
> +	.init.constraints.valid_modes_mask =3D REGULATOR_MODE_NORMAL,
> +	.init.constraints.boot_on =3D 1,
> +};
> +
> +static struct da9058_regulator_pdata ldo3_pdata =3D {
> +	.init.constraints.name =3D "DA9058_LDO3",
> +	.regulator_id =3D DA9058_LDO_3,
> +	.init.constraints.min_uV =3D DA9058_LDO_VOLT_LOWER * 1000,
> +	.init.constraints.max_uV =3D DA9058_LDO_VOLT_UPPER * 1000,
> +	.control_voltage_step =3D DA9058_LDO_VOLT_STEP * 1000,
> +	.control_register =3D DA9058_LDO3_REG,
> +	.control_step_mask =3D DA9058_MAX_VSEL,
> +	.control_enable_mask =3D DA9058_BUCK_LDO_EN,
> +	.init.constraints.valid_ops_mask =3D REGULATOR_CHANGE_VOLTAGE |
> +			REGULATOR_CHANGE_STATUS,
> +	.init.constraints.valid_modes_mask =3D REGULATOR_MODE_NORMAL,
> +	.init.constraints.boot_on =3D 1,
> +};
> +
> +static struct da9058_regulator_pdata ldo4_pdata =3D {
> +	.init.constraints.name =3D "DA9058_LDO4",
> +	.regulator_id =3D DA9058_LDO_4,
> +	.init.constraints.min_uV =3D DA9058_LDO_VOLT_LOWER * 1000,
> +	.init.constraints.max_uV =3D DA9058_LDO_VOLT_UPPER * 1000,
> +	.control_voltage_step =3D DA9058_LDO_VOLT_STEP * 1000,
> +	.control_register =3D DA9058_LDO4_REG,
> +	.control_step_mask =3D DA9058_MAX_VSEL,
> +	.control_enable_mask =3D DA9058_BUCK_LDO_EN,
> +	.init.constraints.valid_ops_mask =3D REGULATOR_CHANGE_VOLTAGE |
> +			REGULATOR_CHANGE_STATUS,
> +	.init.constraints.valid_modes_mask =3D REGULATOR_MODE_NORMAL,
> +	.init.constraints.boot_on =3D 1,
> +};
> +
> +static struct da9058_regulator_pdata ldo5_pdata =3D {
> +	.init.constraints.name =3D "DA9058_LDO5",
> +	.regulator_id =3D DA9058_LDO_5,
> +	.init.constraints.min_uV =3D DA9058_LDO_VOLT_LOWER * 1000,
> +	.init.constraints.max_uV =3D DA9058_LDO_VOLT_UPPER * 1000,
> +	.control_voltage_step =3D DA9058_LDO_VOLT_STEP * 1000,
> +	.control_register =3D DA9058_LDO5_REG,
> +	.control_step_mask =3D DA9058_MAX_VSEL,
> +	.control_enable_mask =3D DA9058_BUCK_LDO_EN,
> +	.init.constraints.valid_ops_mask =3D REGULATOR_CHANGE_VOLTAGE |
> +			REGULATOR_CHANGE_STATUS,
> +	.init.constraints.valid_modes_mask =3D REGULATOR_MODE_NORMAL,
> +	.init.constraints.boot_on =3D 1,
> +};
> +
> +static struct da9058_regulator_pdata ldo6_pdata =3D {
> +	.init.constraints.name =3D "DA9058_LDO6",
> +	.regulator_id =3D DA9058_LDO_6,
> +	.init.constraints.min_uV =3D DA9058_LDO_VOLT_LOWER * 1000,
> +	.init.constraints.max_uV =3D DA9058_LDO_VOLT_UPPER * 1000,
> +	.control_voltage_step =3D DA9058_LDO_VOLT_STEP * 1000,
> +	.control_register =3D DA9058_LDO6_REG,
> +	.control_step_mask =3D DA9058_MAX_VSEL,
> +	.control_enable_mask =3D DA9058_BUCK_LDO_EN,
> +	.init.constraints.valid_ops_mask =3D REGULATOR_CHANGE_VOLTAGE |
> +			REGULATOR_CHANGE_STATUS,
> +	.init.constraints.valid_modes_mask =3D REGULATOR_MODE_NORMAL,
> +};
> +
> +static struct da9058_regulator_pdata ldo7_pdata =3D {
> +	.init.constraints.name =3D "DA9058_LDO7",
> +	.regulator_id =3D DA9058_LDO_7,
> +	.init.constraints.min_uV =3D DA9058_LDO_VOLT_LOWER * 1000,
> +	.init.constraints.max_uV =3D DA9058_LDO_VOLT_UPPER * 1000,
> +	.control_voltage_step =3D DA9058_LDO_VOLT_STEP * 1000,
> +	.control_register =3D DA9058_LDO7_REG,
> +	.control_step_mask =3D DA9058_MAX_VSEL,
> +	.control_enable_mask =3D DA9058_BUCK_LDO_EN,
> +	.init.constraints.valid_ops_mask =3D REGULATOR_CHANGE_VOLTAGE |
> +			REGULATOR_CHANGE_STATUS,
> +	.init.constraints.valid_modes_mask =3D REGULATOR_MODE_NORMAL,
> +	.init.constraints.boot_on =3D 1,
> +};
> +
> +static struct da9058_regulator_pdata ldo8_pdata =3D {
> +	.init.constraints.name =3D "DA9058_LDO8",
> +	.regulator_id =3D DA9058_LDO_8,
> +	.init.constraints.min_uV =3D DA9058_LDO_VOLT_LOWER * 1000,
> +	.init.constraints.max_uV =3D DA9058_LDO_VOLT_UPPER * 1000,
> +	.control_voltage_step =3D DA9058_LDO_VOLT_STEP * 1000,
> +	.control_register =3D DA9058_LDO8_REG,
> +	.control_step_mask =3D DA9058_MAX_VSEL,
> +	.control_enable_mask =3D DA9058_BUCK_LDO_EN,
> +	.init.constraints.valid_ops_mask =3D REGULATOR_CHANGE_VOLTAGE |
> +			REGULATOR_CHANGE_STATUS,
> +	.init.constraints.valid_modes_mask =3D REGULATOR_MODE_NORMAL,
> +	.init.constraints.boot_on =3D 1,
> +};
> +
> +static struct da9058_regulator_pdata ldo9_pdata =3D {
> +	.init.constraints.name =3D "DA9058_LDO9",
> +	.regulator_id =3D DA9058_LDO_9,
> +	.init.constraints.min_uV =3D DA9058_LDO_VOLT_LOWER * 1000,
> +	.init.constraints.max_uV =3D DA9058_LDO_VOLT_UPPER * 1000,
> +	.control_voltage_step =3D DA9058_LDO_VOLT_STEP * 1000,
> +	.control_register =3D DA9058_LDO9_REG,
> +	.control_step_mask =3D DA9058_MAX_VSEL,
> +	.control_enable_mask =3D DA9058_BUCK_LDO_EN,
> +	.init.constraints.valid_ops_mask =3D REGULATOR_CHANGE_VOLTAGE |
> +			REGULATOR_CHANGE_STATUS,
> +	.init.constraints.valid_modes_mask =3D REGULATOR_MODE_NORMAL,
> +};
> +
> +static struct da9058_regulator_pdata ldo10_pdata =3D {
> +	.init.constraints.name =3D "DA9058_LDO10",
> +	.regulator_id =3D DA9058_LDO_10,
> +	.init.constraints.min_uV =3D DA9058_LDO_VOLT_LOWER * 1000,
> +	.init.constraints.max_uV =3D DA9058_LDO_VOLT_UPPER * 1000,
> +	.control_voltage_step =3D DA9058_LDO_VOLT_STEP * 1000,
> +	.control_register =3D DA9058_LDO10_REG,
> +	.control_step_mask =3D DA9058_MAX_VSEL,
> +	.control_enable_mask =3D DA9058_BUCK_LDO_EN,
> +	.init.constraints.valid_ops_mask =3D REGULATOR_CHANGE_VOLTAGE |
> +			REGULATOR_CHANGE_STATUS,
> +	.init.constraints.valid_modes_mask =3D REGULATOR_MODE_NORMAL,
> +	.init.constraints.boot_on =3D 1,
> +};
> +
> +static struct da9058_regulator_pdata ldo12_pdata =3D {
> +	.init.constraints.name =3D "DA9058_LDO12",
> +	.regulator_id =3D DA9058_LDO_12,
> +	.init.constraints.min_uV =3D DA9058_LDO_VOLT_LOWER * 1000,
> +	.init.constraints.max_uV =3D DA9058_LDO_VOLT_UPPER * 1000,
> +	.control_voltage_step =3D DA9058_LDO_VOLT_STEP * 1000,
> +	.control_register =3D DA9058_LDO12_REG,
> +	.control_step_mask =3D DA9058_MAX_VSEL,
> +	.control_enable_mask =3D DA9058_BUCK_LDO_EN,
> +	.init.constraints.valid_ops_mask =3D REGULATOR_CHANGE_VOLTAGE |
> +			REGULATOR_CHANGE_STATUS,
> +	.init.constraints.valid_modes_mask =3D REGULATOR_MODE_NORMAL,
> +	.init.constraints.boot_on =3D 1,
> +};
> +
> +static struct da9058_regulator_pdata ldo13_pdata =3D {
> +	.init.constraints.name =3D "DA9058_LDO13",
> +	.regulator_id =3D DA9058_LDO_13,
> +	.init.constraints.min_uV =3D DA9058_LDO_VOLT_LOWER * 1000,
> +	.init.constraints.max_uV =3D DA9058_LDO_VOLT_UPPER * 1000,
> +	.control_voltage_step =3D DA9058_LDO_VOLT_STEP * 1000,
> +	.control_register =3D DA9058_LDO13_REG,
> +	.control_step_mask =3D DA9058_MAX_VSEL,
> +	.control_enable_mask =3D DA9058_BUCK_LDO_EN,
> +	.init.constraints.valid_ops_mask =3D REGULATOR_CHANGE_VOLTAGE |
> +			REGULATOR_CHANGE_STATUS,
> +	.init.constraints.valid_modes_mask =3D REGULATOR_MODE_NORMAL,
> +};
> +
> +static struct da9058_regulator_pdata ldo14_pdata =3D {
> +	.init.constraints.name =3D "DA9058_LDO14",
> +	.regulator_id =3D DA9058_LDO_14,
> +	.init.constraints.min_uV =3D DA9058_LDO_VOLT_LOWER * 1000,
> +	.init.constraints.max_uV =3D DA9058_LDO_VOLT_UPPER * 1000,
> +	.control_voltage_step =3D DA9058_LDO_VOLT_STEP * 1000,
> +	.control_register =3D DA9058_LDO14_REG,
> +	.control_step_mask =3D DA9058_MAX_VSEL,
> +	.control_enable_mask =3D DA9058_BUCK_LDO_EN,
> +	.init.constraints.valid_ops_mask =3D REGULATOR_CHANGE_VOLTAGE |
> +			REGULATOR_CHANGE_STATUS,
> +	.init.constraints.valid_modes_mask =3D REGULATOR_MODE_NORMAL,
> +};
> +
> +static struct da9058_regulator_pdata ldo16_pdata =3D {
> +	.init.constraints.name =3D "DA9058_LDO16",
> +	.regulator_id =3D DA9058_LDO_16,
> +	.init.constraints.min_uV =3D DA9058_LDO_VOLT_LOWER * 1000,
> +	.init.constraints.max_uV =3D DA9058_LDO_VOLT_UPPER * 1000,
> +	.control_voltage_step =3D DA9058_LDO_VOLT_STEP * 1000,
> +	.control_register =3D DA9058_LDO16_REG,
> +	.control_step_mask =3D DA9058_MAX_VSEL,
> +	.control_enable_mask =3D DA9058_BUCK_LDO_EN,
> +	.init.constraints.valid_ops_mask =3D REGULATOR_CHANGE_VOLTAGE |
> +			REGULATOR_CHANGE_STATUS,
> +	.init.constraints.valid_modes_mask =3D REGULATOR_MODE_NORMAL,
> +};
> +
> +static struct da9058_regulator_pdata ldo17_pdata =3D {
> +	.init.constraints.name =3D "DA9058_LDO17",
> +	.regulator_id =3D DA9058_LDO_17,
> +	.init.constraints.min_uV =3D DA9058_LDO_VOLT_LOWER * 1000,
> +	.init.constraints.max_uV =3D DA9058_LDO_VOLT_UPPER * 1000,
> +	.control_voltage_step =3D DA9058_LDO_VOLT_STEP * 1000,
> +	.control_register =3D DA9058_LDO17_REG,
> +	.control_step_mask =3D DA9058_MAX_VSEL,
> +	.control_enable_mask =3D DA9058_BUCK_LDO_EN,
> +	.init.constraints.valid_ops_mask =3D REGULATOR_CHANGE_VOLTAGE |
> +			REGULATOR_CHANGE_STATUS,
> +	.init.constraints.valid_modes_mask =3D REGULATOR_MODE_NORMAL,
> +};
> +
> +static struct da9058_regulator_pdata ldo18_pdata =3D {
> +	.init.constraints.name =3D "DA9058_LDO18",
> +	.regulator_id =3D DA9058_LDO_18,
> +	.init.constraints.min_uV =3D DA9058_LDO_VOLT_LOWER * 1000,
> +	.init.constraints.max_uV =3D DA9058_LDO_VOLT_UPPER * 1000,
> +	.control_voltage_step =3D DA9058_LDO_VOLT_STEP * 1000,
> +	.control_register =3D DA9058_LDO18_REG,
> +	.control_step_mask =3D DA9058_MAX_VSEL,
> +	.control_enable_mask =3D DA9058_BUCK_LDO_EN,
> +	.init.constraints.valid_ops_mask =3D REGULATOR_CHANGE_VOLTAGE |
> +			REGULATOR_CHANGE_STATUS,
> +	.init.constraints.valid_modes_mask =3D REGULATOR_MODE_NORMAL,
> +};
> +
> +static struct da9058_regulator_pdata ldo19_pdata =3D {
> +	.init.constraints.name =3D "DA9058_LDO19",
> +	.regulator_id =3D DA9058_LDO_19,
> +	.init.constraints.min_uV =3D DA9058_LDO_VOLT_LOWER * 1000,
> +	.init.constraints.max_uV =3D DA9058_LDO_VOLT_UPPER * 1000,
> +	.control_voltage_step =3D DA9058_LDO_VOLT_STEP * 1000,
> +	.control_register =3D DA9058_LDO19_REG,
> +	.control_step_mask =3D DA9058_MAX_VSEL,
> +	.control_enable_mask =3D DA9058_BUCK_LDO_EN,
> +	.init.constraints.valid_ops_mask =3D REGULATOR_CHANGE_VOLTAGE |
> +			REGULATOR_CHANGE_STATUS,
> +	.init.constraints.valid_modes_mask =3D REGULATOR_MODE_NORMAL,
> +};
> +
> +/*
> + *  one control for 2 AUDIO regulators 15A and 15B =3D AUDIO
> + *      15A has two settings 1.2V and 1.6V
> + *	15B is fixed at 3.3V
> + *
> + *  there are 3 states for this regulator:
> + *	15A and 15B both off
> + *	15A =3D 1.2V and 15B =3D 3.3V
> + *	15A =3D 1.6V and 15B =3D 3.3V
> + */
> +
> +static struct da9058_regulator_pdata ldoaudio_pdata =3D {
> +	.init.constraints.name =3D "DA9058_AUDIO",
> +	.regulator_id =3D DA9058_LDO_AUDIO,
> +	.init.constraints.min_uV =3D DA9058_AUDIO_VOLT_LOWER * 1000,
> +	.init.constraints.max_uV =3D DA9058_AUDIO_VOLT_UPPER * 1000,
> +	.control_voltage_step =3D DA9058_AUDIO_VOLT_STEP * 1000,
> +	.control_register =3D DA9058_SUPPLY_REG,
> +	.control_step_mask =3D DA9058_SUPPLY_LDO15MODE,
> +	.control_enable_mask =3D DA9058_SUPPLY_LDO15EN,
> +	.init.constraints.valid_ops_mask =3D REGULATOR_CHANGE_VOLTAGE |
> +			REGULATOR_CHANGE_STATUS,
> +	.init.constraints.valid_modes_mask =3D REGULATOR_MODE_NORMAL,
> +};
> +
> +static const struct resource da9058_gpio_resources[] =3D {
> +	{
> +		.name =3D "gpio0",
> +		.start =3D DA9058_IRQ_EGPI0,
> +		.end =3D DA9058_IRQ_EGPI0,
> +		.flags =3D IORESOURCE_IRQ,
> +	},
> +	{
> +		.name =3D "gpio1",
> +		.start =3D DA9058_IRQ_EGPI1,
> +		.end =3D DA9058_IRQ_EGPI1,
> +		.flags =3D IORESOURCE_IRQ,
> +	},
> +};
> +
> +static const struct resource da9058_rtc_resources[] =3D {
> +	{
> +		.name =3D "alarm",
> +		.start =3D DA9058_IRQ_EALRAM,
> +		.end =3D DA9058_IRQ_EALRAM,
> +		.flags =3D IORESOURCE_IRQ,
> +	},
> +	{
> +		.name =3D "tick",
> +		.start =3D DA9058_IRQ_ETICK,
> +		.end =3D DA9058_IRQ_ETICK,
> +		.flags =3D IORESOURCE_IRQ,
> +	},
> +};
> +
> +static const struct resource da9058_onkey_resources[] =3D {
> +	{
> +		.name =3D "keydown",
> +		.start =3D DA9058_IRQ_ENONKEY,
> +		.end =3D DA9058_IRQ_ENONKEY,
> +		.flags =3D IORESOURCE_IRQ,
> +	},
> +};
> +
> +static const struct resource da9058_adc_resources[] =3D {
> +	{
> +		.name =3D "adc",
> +		.start =3D DA9058_IRQ_EADCEOM,
> +		.end =3D DA9058_IRQ_EADCEOM,
> +		.flags =3D IORESOURCE_IRQ,
> +	},
> +};
> +
> +static struct da9058_gpio_pdata gpio_pdata =3D {
> +
> +		.ngpio =3D ARRAY_SIZE(da9058_gpio_resources),
> +		.gpio_base =3D -1,
> +};
> +
> +static struct da9058_hwmon_pdata hwmon_pdata =3D {
> +};
> +
> +static struct da9058_rtc_pdata rtc_pdata =3D {
> +};
> +
> +static struct da9058_onkey_pdata onkey_pdata =3D {
> +};
> +
> +static struct da9058_power_pdata power_pdata =3D {
> +};
> +
> +static struct da9058_adc_pdata adc_pdata =3D {
> +};
> +
> +static struct mfd_cell da9058_devices[] =3D {
> +	{
> +		.name =3D "da9058-adc",
> +		.id =3D -1,
> +		.platform_data =3D &adc_pdata,
> +		.num_resources =3D ARRAY_SIZE(da9058_adc_resources),
> +		.resources =3D da9058_adc_resources,
> +	},
> +	{
> +		.name =3D "da9058-regulator",
> +		.id =3D DA9058_BUCK_1,
> +		.platform_data =3D &buck1_pdata,
> +	},
> +	{
> +		.name =3D "da9058-regulator",
> +		.id =3D DA9058_BUCK_2,
> +		.platform_data =3D &buck2_pdata,
> +	},
> +	{
> +		.name =3D "da9058-regulator",
> +		.id =3D DA9058_BUCK_3,
> +		.platform_data =3D &buck3_pdata,
> +	},
> +	{
> +		.name =3D "da9058-regulator",
> +		.id =3D DA9058_BUCK_4,
> +		.platform_data =3D &buck4_pdata,
> +	},
> +	{
> +		.name =3D "da9058-regulator",
> +		.id =3D DA9058_LDO_1,
> +		.platform_data =3D &ldo1_pdata,
> +	},
> +	{
> +		.name =3D "da9058-regulator",
> +		.id =3D DA9058_LDO_2,
> +		.platform_data =3D &ldo2_pdata,
> +	},
> +	{
> +		.name =3D "da9058-regulator",
> +		.id =3D DA9058_LDO_3,
> +		.platform_data =3D &ldo3_pdata,
> +	},
> +	{
> +		.name =3D "da9058-regulator",
> +		.id =3D DA9058_LDO_4,
> +		.platform_data =3D &ldo4_pdata,
> +	},
> +	{
> +		.name =3D "da9058-regulator",
> +		.id =3D DA9058_LDO_5,
> +		.platform_data =3D &ldo5_pdata,
> +	},
> +	{
> +		.name =3D "da9058-regulator",
> +		.id =3D DA9058_LDO_6,
> +		.platform_data =3D &ldo6_pdata,
> +	},
> +	{
> +		.name =3D "da9058-regulator",
> +		.id =3D DA9058_LDO_7,
> +		.platform_data =3D &ldo7_pdata,
> +	},
> +	{
> +		.name =3D "da9058-regulator",
> +		.id =3D DA9058_LDO_8,
> +		.platform_data =3D &ldo8_pdata,
> +	},
> +	{
> +		.name =3D "da9058-regulator",
> +		.id =3D DA9058_LDO_9,
> +		.platform_data =3D &ldo9_pdata,
> +	},
> +	{
> +		.name =3D "da9058-regulator",
> +		.id =3D DA9058_LDO_10,
> +		.platform_data =3D &ldo10_pdata,
> +	},
> +	{
> +		.name =3D "da9058-regulator",
> +		.id =3D DA9058_LDO_12,
> +		.platform_data =3D &ldo12_pdata,
> +	},
> +	{
> +		.name =3D "da9058-regulator",
> +		.id =3D DA9058_LDO_13,
> +		.platform_data =3D &ldo13_pdata,
> +	},
> +	{
> +		.name =3D "da9058-regulator",
> +		.id =3D DA9058_LDO_14,
> +		.platform_data =3D &ldo14_pdata,
> +	},
> +	{
> +		.name =3D "da9058-regulator",
> +		.id =3D DA9058_LDO_16,
> +		.platform_data =3D &ldo16_pdata,
> +	},
> +	{
> +		.name =3D "da9058-regulator",
> +		.id =3D DA9058_LDO_17,
> +		.platform_data =3D &ldo17_pdata,
> +	},
> +	{
> +		.name =3D "da9058-regulator",
> +		.id =3D DA9058_LDO_18,
> +		.platform_data =3D &ldo18_pdata,
> +	},
> +	{
> +		.name =3D "da9058-regulator",
> +		.id =3D DA9058_LDO_19,
> +		.platform_data =3D &ldo19_pdata,
> +	},
> +	{
> +		.name =3D "da9058-regulator",
> +		.id =3D DA9058_LDO_AUDIO,
> +		.platform_data =3D &ldoaudio_pdata,
> +	},
> +	{
> +		.name =3D "da9058-hwmon",
> +		.id =3D -1,
> +		.platform_data =3D &hwmon_pdata,
> +	},
> +	{
> +		.name =3D "da9058-gpio",
> +		.id =3D -1,
> +		.platform_data =3D &gpio_pdata,
> +		.num_resources =3D ARRAY_SIZE(da9058_gpio_resources),
> +		.resources =3D da9058_gpio_resources,
> +	},
> +	{
> +		.name =3D "da9058-rtc",
> +		.id =3D -1,
> +		.platform_data =3D &rtc_pdata,
> +		.num_resources =3D ARRAY_SIZE(da9058_rtc_resources),
> +		.resources =3D da9058_rtc_resources,
> +	},
> +	{
> +		.name =3D "da9058-onkey",
> +		.id =3D -1,
> +		.platform_data =3D &onkey_pdata,
> +		.num_resources =3D ARRAY_SIZE(da9058_onkey_resources),
> +		.resources =3D da9058_onkey_resources,
> +	},
> +	{
> +		.name =3D "da9058-power",
> +		.id =3D -1,
> +		.platform_data =3D &power_pdata,
> +	},
> +};
> +
> +#define DA9058_INT_OFFSET_1			0
> +#define DA9058_INT_OFFSET_2			1
> +#define DA9058_INT_OFFSET_3			2
> +#define DA9058_INT_OFFSET_4			3
> +
> +static struct regmap_irq da9058_irqs[DA9058_NUM_IRQ] =3D {
> +	/* EVENT Register A start */
> +	[DA9058_IRQ_EALRAM] =3D {
> +				.reg_offset =3D DA9058_INT_OFFSET_1,
> +				.mask =3D DA9058_IRQMASKA_MALRAM,
> +	},
> +	[DA9058_IRQ_ESEQRDY] =3D {
> +				.reg_offset =3D DA9058_INT_OFFSET_1,
> +				.mask =3D DA9058_IRQMASKA_MSEQRDY,
> +	},
> +	[DA9058_IRQ_ETICK] =3D {
> +				.reg_offset =3D DA9058_INT_OFFSET_1,
> +				.mask =3D DA9058_IRQMASKA_MTICK,
> +	},
> +	/* EVENT Register B start */
> +	[DA9058_IRQ_ENONKEY] =3D {
> +				.reg_offset =3D DA9058_INT_OFFSET_2,
> +				.mask =3D DA9058_IRQMASKB_MNONKEY,
> +	},
> +	[DA9058_IRQ_EADCEOM] =3D {
> +				.reg_offset =3D DA9058_INT_OFFSET_2,
> +				.mask =3D DA9058_IRQMASKB_MADCEOM,
> +	},
> +	/* EVENT Register C start */
> +	[DA9058_IRQ_EGPI0] =3D {
> +				.reg_offset =3D DA9058_INT_OFFSET_3,
> +				.mask =3D DA9058_IRQMASKC_MGPI0,
> +	},
> +	[DA9058_IRQ_EGPI1] =3D {
> +				.reg_offset =3D DA9058_INT_OFFSET_3,
> +				.mask =3D DA9058_IRQMASKC_MGPI1,
> +	},
> +	[DA9058_IRQ_EAUDIO] =3D {
> +				.reg_offset =3D DA9058_INT_OFFSET_3,
> +				.mask =3D DA9058_IRQMASKC_MAUDIO,
> +	},
> +	/* EVENT Register D start */
> +	[DA9058_IRQ_EGPI2] =3D {
> +				.reg_offset =3D DA9058_INT_OFFSET_4,
> +				.mask =3D DA9058_IRQMASKD_MGPI2,
> +	},
> +	[DA9058_IRQ_EGPI3] =3D {
> +				.reg_offset =3D DA9058_INT_OFFSET_4,
> +				.mask =3D DA9058_IRQMASKD_MGPI3,
> +	},
> +	[DA9058_IRQ_EGPI4] =3D {
> +				.reg_offset =3D DA9058_INT_OFFSET_4,
> +				.mask =3D DA9058_IRQMASKD_MGPI4,
> +	},
> +	[DA9058_IRQ_EGPI5] =3D {
> +				.reg_offset =3D DA9058_INT_OFFSET_4,
> +				.mask =3D DA9058_IRQMASKD_MGPI5,
> +	},
> +};
> +
> +struct regmap_irq_chip da9058_irq_chip =3D {
> +	.name =3D "da9058",
> +	.irqs =3D da9058_irqs,
> +	.num_irqs =3D ARRAY_SIZE(da9058_irqs),
> +
> +	.num_regs =3D 4,
> +	.status_base =3D DA9058_EVENTA_REG,
> +	.mask_base =3D DA9058_IRQMASKA_REG,
> +	.ack_base =3D DA9058_EVENTA_REG,
> +};
> +EXPORT_SYMBOL_GPL(da9058_irq_chip);
> +
> +int da9058_add_mfd_devices(struct da9058 *da9058,
> +					struct da9058_chip_pdata *pdata,
> +					struct i2c_adapter *adapter)
> +{
> +
> +	if (pdata->battery_type && pdata->lookup_tables &&
> +					pdata->temp_adc_resistance) {
> +		power_pdata.battery_type =3D pdata->battery_type;
> +		power_pdata.bat_low_limit =3D pdata->bat_low_limit;
> +		power_pdata.use_automatic_adc =3D pdata->use_automatic_adc;
> +		power_pdata.lookup_tables =3D pdata->lookup_tables;
> +	} else {
> +		dev_warn(da9058->dev, "battery power monitor diabled\n");
> +	}
> +
> +	adc_pdata.use_automatic_adc =3D pdata->use_automatic_adc;
> +	hwmon_pdata.use_automatic_adc =3D pdata->use_automatic_adc;
> +	hwmon_pdata.temp_adc_resistance =3D pdata->temp_adc_resistance;
> +	hwmon_pdata.vf_adc_resistance =3D pdata->vf_adc_resistance;
> +	hwmon_pdata.battery_sensor_type =3D pdata->battery_sensor_type;
> +	return mfd_add_devices(da9058->dev, 0, da9058_devices,
> +				ARRAY_SIZE(da9058_devices), NULL,
> +				regmap_irq_chip_get_base(da9058->irq_data),
> +				NULL);
> +}
> +EXPORT_SYMBOL_GPL(da9058_add_mfd_devices);
> diff --git a/drivers/mfd/da9058-irq.c b/drivers/mfd/da9058-irq.c
> new file mode 100644
> index 0000000..183c81e
> --- /dev/null
> +++ b/drivers/mfd/da9058-irq.c
> @@ -0,0 +1,56 @@
> +/*
> + *  Copyright (C) 2012, 2013 Dialog Semiconductor Ltd.
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/device.h>
> +#include <linux/interrupt.h>
> +#include <linux/regmap.h>
> +
> +#include <linux/mfd/da9058/core.h>
> +#include <linux/mfd/da9058/pdata.h>
> +#include <linux/mfd/da9058/conf.h>
> +
> +int da9058_irq_init(struct da9058 *da9058, int irq,
> +				struct regmap_irq_chip *irq_chip)
> +{
> +	int ret;
> +
> +	da9058->chip_irq =3D irq;
> +
> +	if (!da9058->chip_irq) {
> +		dev_err(da9058->dev, "No IRQ configured\n");
> +		return -EINVAL;
> +	}
> +	if (!irq_chip) {
> +		dev_err(da9058->dev, "No chip interrupt data specified\n");
> +		return 0;
> +	}
> +
> +	ret =3D regmap_add_irq_chip(da9058->regmap, da9058->chip_irq,
> +			IRQF_TRIGGER_LOW | IRQF_ONESHOT | IRQF_SHARED,
> +					-1, irq_chip, &da9058->irq_data);
> +	if (ret) {
> +		dev_err(da9058->dev, "Failed to register IRQ chip: %d\n", ret);
> +		return ret;
> +	}
> +
> +	da9058->irq_base =3D regmap_irq_chip_get_base(da9058->irq_data);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(da9058_irq_init);
> +
> +int da9058_irq_exit(struct da9058 *da9058)
> +{
> +	regmap_del_irq_chip(da9058->chip_irq, da9058->irq_data);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(da9058_irq_exit);
> diff --git a/include/linux/mfd/da9058/adc.h b/include/linux/mfd/da9058/ad=
c.h
> new file mode 100644
> index 0000000..879436d
> --- /dev/null
> +++ b/include/linux/mfd/da9058/adc.h
> @@ -0,0 +1,18 @@
> +/*
> + *  Copyright (C) 2012, 2013 Dialog Semiconductor Ltd.
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + */
> +
> +#ifndef __DA9058_ADC_H
> +#define __DA9058_ADC_H
> +
> +struct da9058_adc_pdata {
> +	int use_automatic_adc;
> +};
> +
> +#endif /* __DA9058_ADC_H */
> diff --git a/include/linux/mfd/da9058/bat.h b/include/linux/mfd/da9058/ba=
t.h
> new file mode 100644
> index 0000000..fdf27d0
> --- /dev/null
> +++ b/include/linux/mfd/da9058/bat.h
> @@ -0,0 +1,33 @@
> +/*
> + *  Copyright (C) 2012, 2013 Dialog Semiconductor Ltd.
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + */
> +
> +#ifndef __D1982_BAT_H
> +#define __D1982_BAT_H
> +
> +#define DA9058_LOOK_UP_TABLE_SIZE		68
> +
> +struct da9058_temp_capacity {
> +	int temperature;
> +	u32 capacity[DA9058_LOOK_UP_TABLE_SIZE][2];
> +};
> +
> +struct da9058_power_table {
> +	int temperature_points;
> +	struct da9058_temp_capacity (*temp_tables)[];
> +};
> +
> +struct da9058_power_pdata {
> +	int battery_type;
> +	int bat_low_limit;
> +	int use_automatic_adc;
> +	struct da9058_power_table *lookup_tables;
> +};
> +
> +#endif /* __D1982_BAT_H */
> diff --git a/include/linux/mfd/da9058/codec.h b/include/linux/mfd/da9058/=
codec.h
> new file mode 100644
> index 0000000..f126b78
> --- /dev/null
> +++ b/include/linux/mfd/da9058/codec.h
> @@ -0,0 +1,22 @@
> +/*
> + *  Copyright (C) 2012, 2013 Dialog Semiconductor Ltd.
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + */
> +
> +#ifndef __DA9058_CODEC_H
> +#define __DA9058_CODEC_H
> +
> +struct da9058_codec_pdata {
> +	int i2c_addr;
> +	struct i2c_adapter *i2c_adapter;
> +	int amplifier_initially_on;
> +	int amp_control_reg;
> +	int amp_enable_mask;
> +};
> +
> +#endif /* __DA9058_CODEC_H */
> diff --git a/include/linux/mfd/da9058/conf.h b/include/linux/mfd/da9058/c=
onf.h
> new file mode 100644
> index 0000000..fb8e203
> --- /dev/null
> +++ b/include/linux/mfd/da9058/conf.h
> @@ -0,0 +1,22 @@
> +/*
> + *  Copyright (C) 2012, 2013 Dialog Semiconductor Ltd.
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + */
> +
> +#ifndef __DA9058_CONF_H
> +#define __DA9058_CONF_H
> +
> +extern struct regmap_irq_chip da9058_irq_chip;
> +extern int da9058_irq_init(struct da9058 *da9058, int irq,
> +			struct regmap_irq_chip *da9058_irq_chip);
> +extern int da9058_irq_exit(struct da9058 *da9058);
> +extern int da9058_add_mfd_devices(struct da9058 *da9058,
> +			struct da9058_chip_pdata *pdata,
> +			struct i2c_adapter *adapter);
> +
> +#endif /* __DA9058_CONF_H */
> diff --git a/include/linux/mfd/da9058/core.h b/include/linux/mfd/da9058/c=
ore.h
> new file mode 100644
> index 0000000..a8bd91d
> --- /dev/null
> +++ b/include/linux/mfd/da9058/core.h
> @@ -0,0 +1,66 @@
> +/*
> + *  Copyright (C) 2012, 2013 Dialog Semiconductor Ltd.
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + */
> +
> +#ifndef __DA9058_CORE_H
> +#define __DA9058_CORE_H
> +
> +#define DA9058_ADC_VBAT		0
> +#define DA9058_ADC_TEMP		2
> +#define DA9058_ADC_VF		4
> +#define DA9058_ADC_ADCIN	5
> +#define DA9058_ADC_TJUNC	8
> +
> +struct da9058;
> +
> +struct da9058 {
> +	struct device *dev;
> +	struct regmap *regmap;
> +
> +	int chip_irq;
> +	int irq_base;
> +
> +	struct regmap_irq_chip_data *irq_data;
> +
> +	struct mutex adc_mutex;
> +	struct completion adc_read_done;
> +	int (*adc_read)(struct da9058 *da9058, const int channel,
> +				int automatic_mode, unsigned int *value);
> +};
> +
> +/*
> + * da9058 device IO
> + */
> +#define da9058_set_bits(da9058, reg, mask) \
> +	regmap_update_bits(da9058->regmap, reg, mask, 0xFF)
> +#define da9058_clear_bits(da9058, reg, mask) \
> +	regmap_update_bits(da9058->regmap, reg, mask, 0x00)
> +#define da9058_update_bits(da9058, reg, mask, pval) \
> +	regmap_update_bits(da9058->regmap, reg, mask, pval)
> +
> +#define da9058_bulk_read(da9058, reg, pval, count) \
> +	 regmap_bulk_read(da9058->regmap, reg, pval, count)
> +#define da9058_bulk_write(da9058, reg, pval, count) \
> +	regmap_bulk_write(da9058->regmap, reg, pval, count)
> +
> +#define da9058_reg_read(da9058, reg, pval) \
> +	regmap_read(da9058->regmap, reg, pval)
> +#define da9058_reg_write(da9058, reg, val) \
> +	regmap_write(da9058->regmap, reg, val)
> +static inline int da9058_adc_read(struct da9058 *da9058, const int chann=
el,
> +					int automatic_mode, unsigned int *value)
> +{
> +	if (da9058->adc_read =3D=3D NULL)
> +		return -ENODEV;
> +	else
> +		return da9058->adc_read(da9058, channel,
> +					automatic_mode, value);
> +}
> +
> +#endif /* __DA9058_CORE_H */
> diff --git a/include/linux/mfd/da9058/gpio.h b/include/linux/mfd/da9058/g=
pio.h
> new file mode 100644
> index 0000000..bda0e72
> --- /dev/null
> +++ b/include/linux/mfd/da9058/gpio.h
> @@ -0,0 +1,19 @@
> +/*
> + *  Copyright (C) 2012, 2013 Dialog Semiconductor Ltd.
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + */
> +
> +#ifndef __D1982_GPIO_H
> +#define __D1982_GPIO_H
> +
> +struct da9058_gpio_pdata {
> +	int ngpio;
> +	int gpio_base;
> +};
> +
> +#endif /* __D1982_GPIO_H */
> diff --git a/include/linux/mfd/da9058/hwmon.h b/include/linux/mfd/da9058/=
hwmon.h
> new file mode 100644
> index 0000000..808f923
> --- /dev/null
> +++ b/include/linux/mfd/da9058/hwmon.h
> @@ -0,0 +1,32 @@
> +/*
> + *  Copyright (C) 2012, 2013 Dialog Semiconductor Ltd.
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + */
> +
> +#ifndef __DA9058_HWMON_H
> +#define __DA9058_HWMON_H
> +
> +struct da9058_hwmon {
> +	struct da9058	*da9058;
> +	struct platform_device *pdev;
> +
> +	struct device	*class_device;
> +	int use_automatic_adc;
> +	int temp_adc_resistance;
> +	int vf_adc_resistance;
> +	int battery_sensor_type;
> +};
> +
> +struct da9058_hwmon_pdata {
> +	int use_automatic_adc;
> +	int temp_adc_resistance;
> +	int vf_adc_resistance;
> +	int battery_sensor_type;
> +};
> +
> +#endif /* __DA9058_HWMON_H */
> diff --git a/include/linux/mfd/da9058/i2c.h b/include/linux/mfd/da9058/i2=
c.h
> new file mode 100644
> index 0000000..664dff9
> --- /dev/null
> +++ b/include/linux/mfd/da9058/i2c.h
> @@ -0,0 +1,22 @@
> +/*
> + *  Copyright (C) 2012, 2013 Dialog Semiconductor Ltd.
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + */
> +
> +#ifndef __DA9058_I2C_H
> +#define __DA9058_I2C_H
> +
> +struct da9058;
> +struct da9058_chip_pdata;
> +extern struct da9058 *da9058_device_init(struct device *dev,
> +				struct regmap *regmap, void *adapter, int irq,
> +				struct da9058_chip_pdata *pdata);
> +extern int da9058_device_exit(struct da9058 *da9058);
> +extern struct regmap_config da9058_regmap_config;
> +
> +#endif /* __DA9058_I2C_H */
> diff --git a/include/linux/mfd/da9058/irq.h b/include/linux/mfd/da9058/ir=
q.h
> new file mode 100644
> index 0000000..f29c1c2
> --- /dev/null
> +++ b/include/linux/mfd/da9058/irq.h
> @@ -0,0 +1,50 @@
> +/*
> + *  Copyright (C) 2012, 2013 Dialog Semiconductor Ltd.
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + */
> +
> +#ifndef __DA9058_IRQ_H
> +#define __DA9058_IRQ_H
> +
> +enum {
> +
> +DA9058_IRQ_EALRAM,
> +DA9058_IRQ_ESEQRDY,
> +DA9058_IRQ_ETICK,
> +
> +DA9058_IRQ_ENONKEY,
> +DA9058_IRQ_EADCEOM,
> +
> +DA9058_IRQ_EGPI0,
> +DA9058_IRQ_EGPI1,
> +DA9058_IRQ_EAUDIO,
> +
> +DA9058_IRQ_EGPI2,
> +DA9058_IRQ_EGPI3,
> +DA9058_IRQ_EGPI4,
> +DA9058_IRQ_EGPI5,
> +
> +DA9058_NUM_IRQ
> +};
> +
> +/*
> + *  da9058 virtual threaded interrupts
> + *  the MFD component drivers or users of those drivers
> + *  (in the case of GPIOs) will call:
> + *  request_threaded_irq() and free_irq() directly using
> + *  the actual virtual threaded IRQ number which can be
> + *  obtained from the DA9058 PMIC relative (soft) IRQ number
> + */
> +static inline int da9058_to_virt_irq_num(struct da9058 *da9058, int irq)
> +{
> +	if (!da9058->irq_data)
> +		return -EINVAL;
> +	return regmap_irq_get_virq(da9058->irq_data, irq);
> +}
> +
> +#endif /* __DA9058_IRQ_H */
> diff --git a/include/linux/mfd/da9058/onkey.h b/include/linux/mfd/da9058/=
onkey.h
> new file mode 100644
> index 0000000..c9c8acd
> --- /dev/null
> +++ b/include/linux/mfd/da9058/onkey.h
> @@ -0,0 +1,17 @@
> +/*
> + *  Copyright (C) 2012, 2013 Dialog Semiconductor Ltd.
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + */
> +
> +#ifndef __DA9058_ONKEY_H
> +#define __DA9058_ONKEY_H
> +
> +struct da9058_onkey_pdata {
> +};
> +
> +#endif /* __DA9058_ONKEY_H */
> diff --git a/include/linux/mfd/da9058/pdata.h b/include/linux/mfd/da9058/=
pdata.h
> new file mode 100644
> index 0000000..a19b3a9
> --- /dev/null
> +++ b/include/linux/mfd/da9058/pdata.h
> @@ -0,0 +1,30 @@
> +/*
> + *  Copyright (C) 2012, 2013 Dialog Semiconductor Ltd.
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + */
> +
> +#ifndef __DA9058_PDATA_H
> +#define __DA9058_PDATA_H
> +
> +struct da9058_hwmon;
> +/*
> + *  This is the Platform Data for the DA9058 PMIC chip as a whole.
> + */
> +struct da9058_chip_pdata {
> +	char *platform_description;
> +	struct i2c_adapter *i2c_adapter;
> +	int battery_type;
> +	int bat_low_limit;
> +	int use_automatic_adc;
> +	int temp_adc_resistance;
> +	int vf_adc_resistance;
> +	int battery_sensor_type;
> +	struct da9058_power_table *lookup_tables;
> +};
> +
> +#endif /* __DA9058_PDATA_H */
> diff --git a/include/linux/mfd/da9058/registers.h b/include/linux/mfd/da9=
058/registers.h
> new file mode 100644
> index 0000000..486b6c9
> --- /dev/null
> +++ b/include/linux/mfd/da9058/registers.h
> @@ -0,0 +1,480 @@
> +/*
> + *  Copyright (C) 2012, 2013 Dialog Semiconductor Ltd.
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + */
> +
> +#ifndef __DA9058_REGISTERS_H
> +#define __DA9058_REGISTERS_H
> +
> +#define DA9058_PAGECON0_REG			0
> +#define DA9058_STATUSA_REG			1
> +#define DA9058_STATUSB_REG			2
> +#define DA9058_STATUSC_REG			3
> +#define DA9058_STATUSD_REG			4
> +#define DA9058_EVENTA_REG			5
> +#define DA9058_EVENTB_REG			6
> +#define DA9058_EVENTC_REG			7
> +#define DA9058_EVENTD_REG			8
> +#define DA9058_FAULTLOG_REG			9
> +#define DA9058_IRQMASKA_REG			10
> +#define DA9058_IRQMASKB_REG			11
> +#define DA9058_IRQMASKC_REG			12
> +#define DA9058_IRQMASKD_REG			13
> +#define DA9058_CONTROLA_REG			14
> +#define DA9058_CONTROLB_REG			15
> +#define DA9058_CONTROLC_REG			16
> +#define DA9058_CONTROLD_REG			17
> +#define DA9058_PDDIS_REG			18
> +#define DA9058_INTERFACE_REG			19
> +#define DA9058_RESET_REG			20
> +#define DA9058_GPIO0001_REG			21
> +
> +#define DA9058_GPIO0203_REG			25
> +#define DA9058_GPIO0405_REG			27
> +
> +#define DA9058_ID01_REG				29
> +#define DA9058_ID23_REG				30
> +#define DA9058_ID45_REG				31
> +#define DA9058_ID67_REG				32
> +#define DA9058_ID89_REG				33
> +#define DA9058_ID1011_REG			34
> +#define DA9058_ID1213_REG			35
> +#define DA9058_ID1415_REG			36
> +#define DA9058_ID1617_REG			37
> +
> +#define DA9058_SEQSTATUS_REG			40
> +#define DA9058_SEQA_REG				41
> +#define DA9058_SEQB_REG				42
> +#define DA9058_SEQTIMER_REG			43
> +#define DA9058_BUCKA_REG			44
> +#define DA9058_BUCKB_REG			45
> +#define DA9058_BUCK1_REG			46
> +#define DA9058_BUCK2_REG			47
> +#define DA9058_BUCK3_REG			48
> +#define DA9058_BUCK4_REG			49
> +#define DA9058_LDO1_REG				50
> +#define DA9058_LDO2_REG				51
> +#define DA9058_LDO3_REG				52
> +#define DA9058_LDO4_REG				53
> +#define DA9058_LDO5_REG				54
> +#define DA9058_LDO6_REG				55
> +#define DA9058_LDO7_REG				56
> +#define DA9058_LDO8_REG				57
> +#define DA9058_LDO9_REG				58
> +#define DA9058_LDO10_REG			59
> +#define DA9058_LDO12_REG			60
> +#define DA9058_LDO13_REG			61
> +#define DA9058_PULLDOWN_REG_A			62
> +#define DA9058_PULLDOWN_REG_B			63
> +#define DA9058_PULLDOWN_REG_C			64
> +#define DA9058_LDO14_REG			65
> +#define DA9058_LDO16_REG			66
> +#define DA9058_LDO17_REG			67
> +#define DA9058_LDO18_REG			68
> +#define DA9058_LDO19_REG			69
> +#define DA9058_SUPPLY_REG			70
> +#define DA9058_WAITCONT_REG			71
> +#define DA9058_ONKEYCONT_REG			72
> +#define DA9058_POWERCONT_REG			73
> +#define DA9058_AUDIO_CONF1_REG			74
> +#define DA9058_AUDIO_CONF2_REG_A		75
> +#define DA9058_AUDIO_CONF2_REG_B		76
> +#define DA9058_BBATCONT_REG			77
> +
> +#define DA9058_ADCMAN_REG			81
> +#define DA9058_ADCCONT_REG			82
> +#define DA9058_ADCRESL_REG			83
> +#define DA9058_ADCRESH_REG			84
> +#define DA9058_VBATRES_REG_MSB			85
> +
> +#define DA9058_TEMPRES_REG_MSB			90
> +
> +#define DA9058_TOFFSET_REG			94
> +#define DA9058_VREF_REG				95
> +
> +#define DA9058_ADCINRES_REG_MSB			98
> +
> +#define DA9058_TJUNCRES_REG			104
> +#define DA9058_AUTORES_REG_1			105
> +#define DA9058_AUTORES_REG_2			106
> +#define DA9058_AUTORES_REG_3			107
> +
> +#define DA9058_COUNTS_REG			111
> +#define DA9058_COUNTMI_REG			112
> +#define DA9058_COUNTH_REG			113
> +#define DA9058_COUNTD_REG			114
> +#define DA9058_COUNTMO_REG			115
> +#define DA9058_COUNTY_REG			116
> +#define DA9058_ALARMS_REG			117
> +#define DA9058_ALARMMI_REG			118
> +#define DA9058_ALARMH_REG			119
> +#define DA9058_ALARMD_REG			120
> +#define DA9058_ALARMMO_REG			121
> +#define DA9058_ALARMY_REG			122
> +
> +#define DA9058_PAGECON1_REG			128
> +#define DA9058_CHIPID_REG			129
> +#define DA9058_CONFIGID_REG			130
> +#define DA9058_OTPCONT_REG			131
> +#define DA9058_OSCTRIM_REG			132
> +#define DA9058_GPID0_REG			133
> +#define DA9058_GPID1_REG			134
> +#define DA9058_GPID2_REG			135
> +#define DA9058_GPID3_REG			136
> +#define DA9058_GPID4_REG			137
> +#define DA9058_GPID5_REG			138
> +#define DA9058_GPID6_REG			139
> +#define DA9058_GPID7_REG			140
> +#define DA9058_GPID8_REG			141
> +#define DA9058_GPID9_REG			142
> +
> +#define DA9058_PAGE0_REG_START			DA9058_STATUSA_REG
> +#define DA9058_PAGE0_REG_END			DA9058_ALARMY_REG
> +#define DA9058_PAGE1_REG_START			DA9058_CHIPID_REG
> +#define DA9058_PAGE1_REG_END			DA9058_GPID9_REG
> +#define DA9058_MAX_REGISTER_CNT			DA9058_PAGE1_REG_END
> +
> +/* STATUS REGISTER A */
> +#define DA9058_STATUSA_NONKEY			(1<<0)
> +/* STATUS REGISTER B */
> +#define DA9058_STATUSB_SEQUENCING		(1<<6)
> +/* STATUS REGISTER C */
> +#define DA9058_STATUSC_INT_IN			(1<<2)
> +#define DA9058_STATUSC_GPI1			(1<<1)
> +#define DA9058_STATUSC_GPI0			(1<<0)
> +/* STATUS REGISTER D */
> +#define DA9058_STATUSD_GPI5			(1<<5)
> +#define DA9058_STATUSD_GPI4			(1<<4)
> +#define DA9058_STATUSD_GPI3			(1<<3)
> +#define DA9058_STATUSD_GPI2			(1<<0)
> +/* EVENT REGISTER A */
> +#define DA9058_EVENTA_ETICK			(1<<7)
> +#define DA9058_EVENTA_ESEQRDY			(1<<6)
> +#define DA9058_EVENTA_EALRAM			(1<<5)
> +/* EVENT REGISTER B */
> +#define DA9058_EVENTB_EADCEOM			(1<<5)
> +#define DA9058_EVENTB_ENONKEY			(1<<0)
> +/* EVENT REGISTER C */
> +#define DA9058_EVENTC_EAUDIO			(1<<2)
> +#define DA9058_EVENTC_EGPI1			(1<<1)
> +#define DA9058_EVENTC_EGPI0			(1<<0)
> +/* EVENT REGISTER D */
> +#define DA9058_EVENTC_EGPI5			(1<<5)
> +#define DA9058_EVENTC_EGPI4			(1<<4)
> +#define DA9058_EVENTC_EGPI3			(1<<3)
> +#define DA9058_EVENTC_EGPI2			(1<<0)
> +/* FAULT LOG REGISTER */
> +#define DA9058_FAULTLOG_WAITSET			(1<<7)
> +#define DA9058_FAULTLOG_KEYSHUT			(1<<5)
> +#define DA9058_FAULTLOG_TEMPOVER		(1<<3)
> +#define DA9058_FAULTLOG_VDDSTART		(1<<2)
> +#define DA9058_FAULTLOG_VDDFAULT		(1<<1)
> +#define DA9058_FAULTLOG_TWDERROR		(1<<0)
> +/* IRQ_MASK REGISTER A */
> +#define DA9058_IRQMASKA_MTICK			(1<<7)
> +#define DA9058_IRQMASKA_MSEQRDY			(1<<6)
> +#define DA9058_IRQMASKA_MALRAM			(1<<5)
> +#define DA9058_IRQMASKA_BIT4			(1<<4)
> +/* IRQ_MASK REGISTER B */
> +#define DA9058_IRQMASKB_MADCEOM			(1<<5)
> +#define DA9058_IRQMASKB_BIT4			(1<<4)
> +#define DA9058_IRQMASKB_MNONKEY			(1<<0)
> +/* IRQ_MASK REGISTER C */
> +#define DA9058_IRQMASKC_MAUDIO			(1<<2)
> +#define DA9058_IRQMASKC_MGPI1			(1<<1)
> +#define DA9058_IRQMASKC_MGPI0			(1<<0)
> +/* IRQ_MASK REGISTER D */
> +#define DA9058_IRQMASKD_MGPI5			(1<<5)
> +#define DA9058_IRQMASKD_MGPI4			(1<<4)
> +#define DA9058_IRQMASKD_MGPI3			(1<<3)
> +#define DA9058_IRQMASKD_MGPI2			(1<<0)
> +/* CONTROL REGISTER A */
> +#define DA9058_CONTROLA_GPIV			(1<<7)
> +#define DA9058_CONTROLA_PMOTYPE			(1<<5)
> +#define DA9058_CONTROLA_PMOPU			(1<<4)
> +#define DA9058_CONTROLA_PMIV			(1<<3)
> +#define DA9058_CONTROLA_PMIFV			(1<<3)
> +#define DA9058_CONTROLA_PWR1EN			(1<<2)
> +#define DA9058_CONTROLA_PWREN			(1<<1)
> +#define DA9058_CONTROLA_SYSEN			(1<<0)
> +/* CONTROL REGISTER B */
> +#define DA9058_CONTROLB_SHUTDOWN		(1<<7)
> +#define DA9058_CONTROLB_DEEPSLEEP		(1<<6)
> +#define DA9058_CONTROLB_WRITEMODE		(1<<5)
> +#define DA9058_CONTROLB_I2C1_SPEED		(1<<4)
> +#define DA9058_CONTROLB_OTPREADEN		(1<<3)
> +#define DA9058_CONTROLB_AUTOBOOT		(1<<2)
> +/* CONTROL REGISTER C */
> +#define DA9058_CONTROLC_DEBOUNCING		(7<<2)
> +#define DA9058_CONTROLC_PMFBPIN			(1<<0)
> +/* CONTROL REGISTER D */
> +#define DA9058_CONTROLD_WATCHDOG		(1<<7)
> +#define DA9058_CONTROLD_KEEPACTEN		(1<<3)
> +#define DA9058_CONTROLD_TWDSCALE		(7<<0)
> +/* POWER DOWN DISABLE REGISTER */
> +#define DA9058_PDDIS_PMCONTPD			(1<<7)
> +#define DA9058_PDDIS_OUT32KPD			(1<<6)
> +#define DA9058_PDDIS_CHGBBATPD			(1<<5)
> +#define DA9058_PDDIS_HSIFPD			(1<<3)
> +#define DA9058_PDDIS_PMIFPD			(1<<2)
> +#define DA9058_PDDIS_GPADCPD			(1<<1)
> +#define DA9058_PDDIS_GPIOPD			(1<<0)
> +/* INTERFACE REGISTER */
> +#define DA9058_INTERFACE_IFBASEADDR		(7<<5)
> +/* RESET REGISTER */
> +#define DA9058_RESET_RESETEVENT			(3<<6)
> +#define DA9058_RESET_RESETTIMER			(63<<0)
> +/* GPIO control register for PIN 0 and 1 */
> +#define DA9058_GPIO01_GPIO1MODE			(1<<7)
> +#define DA9058_GPIO01_GPIO1TYPE			(1<<6)
> +#define DA9058_GPIO01_GPIO1PIN			(3<<4)
> +#define DA9058_GPIO01_GPIO0MODE			(1<<3)
> +#define DA9058_GPIO01_GPIO0TYPE			(1<<2)
> +#define DA9058_GPIO01_GPIO0PIN			(3<<0)
> +/* GPIO control register for PIN 2 and 3 */
> +#define DA9058_GPIO23_GPIO3MODE			(1<<7)
> +#define DA9058_GPIO23_GPIO3TYPE			(1<<6)
> +#define DA9058_GPIO23_GPIO3PIN			(3<<4)
> +#define DA9058_GPIO23_GPIO2MODE			(1<<3)
> +#define DA9058_GPIO23_GPIO2TYPE			(1<<2)
> +#define DA9058_GPIO23_GPIO2PIN			(3<<0)
> +/* GPIO control register for PIN 4 and 5 */
> +#define DA9058_GPIO45_GPIO5MODE			(1<<7)
> +#define DA9058_GPIO45_GPIO5TYPE			(1<<6)
> +#define DA9058_GPIO45_GPIO5PIN			(3<<4)
> +#define DA9058_GPIO45_GPIO4MODE			(1<<3)
> +#define DA9058_GPIO45_GPIO4TYPE			(1<<2)
> +#define DA9058_GPIO45_GPIO4PIN			(3<<0)
> +/* BUCK and LDO fields */
> +#define DA9058_BUCK_LDO_EN			(1<<6)
> +#define DA9058_MAX_VSEL				0x3F
> +/* SEQ control register for ID 0 and 1 */
> +#define DA9058_ID01_LDO1STEP			(15<<4)
> +#define DA9058_ID01_WAITIDALWAYS		(1<<2)
> +#define DA9058_ID01_SYSPRE			(1<<2)
> +#define DA9058_ID01_DEFSUPPLY			(1<<1)
> +#define DA9058_ID01_nRESMODE			(1<<0)
> +/* SEQ control register for ID 2 and 3 */
> +#define DA9058_ID23_LDO3STEP			(15<<4)
> +#define DA9058_ID23_LDO2STEP			(15<<0)
> +/* SEQ control register for ID 4 and 5 */
> +#define DA9058_ID45_LDO5STEP			(15<<4)
> +#define DA9058_ID45_LDO4STEP			(15<<0)
> +/* SEQ control register for ID 6 and 7 */
> +#define DA9058_ID67_LDO7STEP			(15<<4)
> +#define DA9058_ID67_LDO6STEP			(15<<0)
> +/* SEQ control register for ID 8 and 9 */
> +#define DA9058_ID89_LDO9STEP			(15<<4)
> +#define DA9058_ID89_LDO8STEP			(15<<0)
> +/* SEQ control register for ID 10 and 11 */
> +#define DA9058_ID1011_PDDISSTEP			(15<<4)
> +#define DA9058_ID1011_LDO10STEP			(15<<0)
> +/* SEQ control register for ID 12 and 13 */
> +#define DA9058_ID1213_LDO13STEP			(15<<4)
> +#define DA9058_ID1213_LDO12STEP			(15<<0)
> +/* SEQ control register for ID 14 and 15 */
> +#define DA9058_ID1415_BUCK2			(15<<4)
> +#define DA9058_ID1415_BUCK1			(15<<0)
> +/* SEQ control register for ID 16 and 17 */
> +#define DA9058_ID1617_BUCK4			(15<<4)
> +#define DA9058_ID1617_BUCK3			(15<<0)
> +/* Power SEQ Status register */
> +#define DA9058_SEQSTATUS_SEQPOINTER		(15<<4)
> +#define DA9058_SEQSTATUS_WAITSTEP		(15<<0)
> +/* Power SEQ A register */
> +#define DA9058_SEQA_POWEREND			(15<<4)
> +#define DA9058_SEQA_SYSTEMEND			(15<<0)
> +/* Power SEQ B register */
> +#define DA9058_SEQB_PARTDOWN			(15<<4)
> +#define DA9058_SEQB_MAXCOUNT			(15<<0)
> +/* Power SEQ TIMER register */
> +#define DA9058_SEQTIMER_SEQDUMMY		(15<<4)
> +#define DA9058_SEQTIMER_SEQTIME			(15<<0)
> +/* BUCK REGISTER A */
> +#define DA9058_BUCKA_BUCK2ILIM			(3<<6)
> +#define DA9058_BUCKA_BUCK2MODE			(3<<4)
> +#define DA9058_BUCKA_BUCK1ILIM			(3<<2)
> +#define DA9058_BUCKA_BUCK1MODE			(3<<0)
> +/* BUCK REGISTER B */
> +#define DA9058_BUCKB_BUCK4ILIM			(3<<6)
> +#define DA9058_BUCKB_BUCK4IMODE			(3<<4)
> +#define DA9058_BUCKB_BUCK3ILIM			(3<<2)
> +#define DA9058_BUCKB_BUCK3MODE			(3<<0)
> +/* SUPPLY REGISTER */
> +#define DA9058_SUPPLY_VLOCK			(1<<7)
> +#define DA9058_SUPPLY_LDO15MODE			(1<<6)
> +#define DA9058_SUPPLY_LDO15EN			(1<<5)
> +#define DA9058_SUPPLY_BBCHGEN			(1<<4)
> +#define DA9058_SUPPLY_VBUCK4GO			(1<<3)
> +#define DA9058_SUPPLY_VBUCK3GO			(1<<2)
> +#define DA9058_SUPPLY_VBUCK2GO			(1<<1)
> +#define DA9058_SUPPLY_VBUCK1GO			(1<<0)
> +/* PULLDOWN REGISTER A */
> +#define DA9058_PULLDOWN_A_LDO4PDDIS		(1<<7)
> +#define DA9058_PULLDOWN_A_LDO3PDDIS		(1<<6)
> +#define DA9058_PULLDOWN_A_LDO2PDDIS		(1<<5)
> +#define DA9058_PULLDOWN_A_LDO1PDDIS		(1<<4)
> +#define DA9058_PULLDOWN_A_BUCK4PDDIS		(1<<3)
> +#define DA9058_PULLDOWN_A_BUCK3PDDIS		(1<<2)
> +#define DA9058_PULLDOWN_A_BUCK2PDDIS		(1<<1)
> +#define DA9058_PULLDOWN_A_BUCK1PDDIS		(1<<0)
> +/* PULLDOWN REGISTER B */
> +#define DA9058_PULLDOWN_B_LDO13PDDIS		(1<<7)
> +#define DA9058_PULLDOWN_B_LDO12PDDIS		(1<<6)
> +#define DA9058_PULLDOWN_B_LDO10PDDIS		(1<<5)
> +#define DA9058_PULLDOWN_B_LDO9PDDIS		(1<<4)
> +#define DA9058_PULLDOWN_B_LDO8PDDIS		(1<<3)
> +#define DA9058_PULLDOWN_B_LDO7PDDIS		(1<<2)
> +#define DA9058_PULLDOWN_B_LDO6PDDIS		(1<<1)
> +#define DA9058_PULLDOWN_B_LDO5PDDIS		(1<<0)
> +/* PULLDOWN REGISTER C */
> +#define DA9058_PULLDOWN_C_LDO19PDDIS		(1<<6)
> +#define DA9058_PULLDOWN_C_LDO18PDDIS		(1<<5)
> +#define DA9058_PULLDOWN_C_LDO17PDDIS		(1<<4)
> +#define DA9058_PULLDOWN_C_LDO16PDDIS		(1<<3)
> +#define DA9058_PULLDOWN_C_LDO15BPDDIS		(1<<2)
> +#define DA9058_PULLDOWN_C_LDO15APDDIS		(1<<1)
> +#define DA9058_PULLDOWN_C_LDO14PDDIS		(1<<0)
> +/* WAIT CONTROL REGISTER */
> +#define DA9058_WAITCONT_WAITDIR			(1<<7)
> +#define DA9058_WAITCONT_RTCCLOCK		(1<<6)
> +#define DA9058_WAITCONT_WAITMODE		(1<<5)
> +#define DA9058_WAITCONT_EN32KOUT		(1<<4)
> +#define DA9058_WAITCONT_DELAYTIME		(15<<0)
> +/* ONKEY CONTROL REGISTER */
> +#define DA9058_ONKEYCONT_PRESSTIME		(15<<0)
> +/* POWER CONTROL REGISTER */
> +#define DA9058_POWERCONT_nSLEEP			(1<<0)
> +/* BACKUP BATTERY CONTROL REGISTER */
> +#define DA9058_BBATCONT_BCHARGERISET		(15<<4)
> +#define DA9058_BBATCONT_BCHARGERVSET		(15<<0)
> +/* AUDIO CONF2 REGISTER */
> +#define DA9058_AUDIOCONF_CLASSDEN		(1<<0)
> +/* ADC MANUAL registers */
> +#define DA9058_ADCMAN_MANCONV			(1<<4)
> +#define DA9058_ADCMAN_MUXSEL_MASK		(0x0F)
> +#define DA9058_ADCMAN_MUXSEL_VBAT		(0x0<<0)
> +#define DA9058_ADCMAN_MUXSEL_TEMP		(0x2<<0)
> +#define DA9058_ADCMAN_MUXSEL_VF			(0x4<<0)
> +#define DA9058_ADCMAN_MUXSEL_ADCIN		(0x5<<0)
> +#define DA9058_ADCMAN_MUXSEL_TJUNC		(0x8<<0)
> +/* ADC CONTROL regsisters */
> +#define DA9058_ADCCONT_AUTOADCEN		(1<<7)
> +#define DA9058_ADCCONT_ADCMODE			(1<<6)
> +#define DA9058_ADCCONT_TEMPISRCEN		(1<<5)
> +#define DA9058_ADCCONT_VFISRCEN			(1<<4)
> +#define DA9058_ADCCONT_AUTOAINEN		(1<<2)
> +#define DA9058_ADCCONT_AUTOVFEN			(1<<1)
> +#define DA9058_ADCCONT_AUTOVBATEN		(1<<0)
> +/* ADC 12 BIT MANUAL CONVERSION RESULT LSB register */
> +#define DA9058_ADCRESL_ADCRESLSB		(15<<0)
> +#define DA9058_ADCRESL_ADCRESLSB_MASK		DA9058_ADCRESL_ADCRESLSB
> +/* ADC 12 BIT MANUAL CONVERSION RESULT MSB register */
> +#define DA9058_ADCRESH_ADCRESMSB			(255<<0)
> +#define DA9058_ADCRESH_ADCRESMSB_MASK		DA9058_ADCRESH_ADCRESMSB
> +/* VBAT 10 BIT RES MSB regsister*/
> +#define DA9058_VBATRES_VBATRESMSB		(255<<0)
> +#define DA9058_VBATRES_VBATRESMSB_MASK		DA9058_VBATRES_VBATRESMSB
> +/* VBAT 10 BIT RES LSB regsister*/
> +#define DA9058_VBATRES_VBATRESLSB		(3<<2)
> +#define DA9058_VBATRES_VBATRESLSB_MASK		DA9058_VBATRES_VBATRESLSB
> +/* TEMP 10 BIT RES MSB regsister*/
> +#define DA9058_TEMPRES_TEMPRESMSB		(255<<0)
> +#define DA9058_TEMPRES_TEMPRESMSB_MASK		DA9058_TEMPRES_TEMPRESMSB
> +/* TEMP 10 BIT RES LSB regsister*/
> +#define DA9058_TEMPRES_TEMPRESLSB		(3<<6)
> +#define DA9058_TEMPRES_TEMPRESLSB_MASK		DA9058_TEMPRES_TEMPRESLSB
> +/* T_OFFSET regsister*/
> +#define DA9058_TOFFSET_TOFFSET			(255<<0)
> +/* VF 10 BIT RES MSB regsister*/
> +#define DA9058_VFRES_VFRESMSB			(255<<0)
> +#define DA9058_VFRES_VFRESMSB_MASK		DA9058_VFRES_VFRESMSB
> +/* VF 10 BIT RES LSB regsister*/
> +#define DA9058_VFRES_VFRESLSB			(3<<2)
> +#define DA9058_VFRES_VFRESLSB_MASK		DA9058_VFRES_VFRESLSB
> +/* ADCIN 10 BIT RES MSB regsister*/
> +#define DA9058_ADCINRES_ADCINRESMSB		(255<<0)
> +#define DA9058_ADCINRES_ADCINRESMSB_MASK	DA9058_ADCINRES_ADCINRESMSB
> +/* ADCIN 10 BIT RES LSB regsister*/
> +#define DA9058_ADCINRES_ADCINRESLSB		(3<<6)
> +#define DA9058_ADCINRES_ADCINRESLSB_MASK	DA9058_ADCINRES_ADCINRESLSB
> +/* TJUNC 10 BIT RES MSB regsister*/
> +#define DA9058_TJUNCRES_TJUNCRESMSB		(255<<0)
> +#define DA9058_TJUNCRES_TJUNCRESMSB_MASK	DA9058_TJUNCRES_TJUNCRESMSB
> +/* ADCIN 10 BIT RES LSB regsister*/
> +#define DA9058_TJUNCRES_TJUNCRESLSB		(3<<6)
> +#define DA9058_TJUNCRES_TJUNCRESLSB_MASK	DA9058_TJUNCRES_TJUNCRESLSB
> +/* RTC fields - all values are coded linearly from 0 or 1 upwards */
> +#define DA9058_RTC_SECS_MASK			0x3F
> +#define DA9058_RTC_MINS_MASK			0x3F
> +#define DA9058_RTC_HRS_MASK			0x1F
> +#define DA9058_RTC_DAY_MASK			0x1F
> +#define DA9058_RTC_MTH_MASK			0x0F
> +#define DA9058_RTC_YRS_MASK			0x3F
> +#define DA9058_RTC_ALMSECS_MASK			0x3F
> +#define DA9058_RTC_ALMMINS_MASK			0x3F
> +#define DA9058_RTC_ALMHRS_MASK			0x1F
> +#define DA9058_RTC_ALMDAY_MASK			0x1F
> +#define DA9058_RTC_ALMMTH_MASK			0x0F
> +#define DA9058_RTC_ALMYRS_MASK			0x3F
> +/* RTC TIMER SECONDS REGISTER */
> +#define DA9058_COUNTS_COUNTSEC			(63<<0)
> +/* RTC TIMER MINUTES REGISTER */
> +#define DA9058_COUNTMI_COUNTMIN			(63<<0)
> +/* RTC TIMER HOUR REGISTER */
> +#define DA9058_COUNTH_COUNTHOUR			(31<<0)
> +/* RTC TIMER DAYS REGISTER */
> +#define DA9058_COUNTD_COUNTDAY			(31<<0)
> +/* RTC TIMER MONTHS REGISTER */
> +#define DA9058_COUNTMO_COUNTMONTH		(15<<0)
> +/* RTC TIMER YEARS REGISTER */
> +#define DA9058_COUNTY_MONITOR			(1<<6)
> +#define DA9058_COUNTY_COUNTYEAR			(63<<0)
> +/* RTC ALARM SECONDS REGISTER */
> +#define DA9058_ALARMMI_COUNTSEC			(63<<0)
> +/* RTC ALARM MINUTES REGISTER */
> +#define DA9058_ALARMMI_TICKTYPE			(1<<7)
> +#define DA9058_ALARMMI_ALARMMIN			(63<<0)
> +/* RTC ALARM HOURS REGISTER */
> +#define DA9058_ALARMH_ALARMHOUR			(31<<0)
> +/* RTC ALARM DAYS REGISTER */
> +#define DA9058_ALARMD_ALARMDAY			(31<<0)
> +/* RTC ALARM MONTHS REGISTER */
> +#define DA9058_ALARMMO_ALARMMONTH		(15<<0)
> +/* RTC ALARM YEARS REGISTER */
> +#define DA9058_ALARMY_TICKON			(1<<7)
> +#define DA9058_ALARMY_ALARMON			(1<<6)
> +#define DA9058_ALARMY_ALARMYEAR			(63<<0)
> +/* CHIP IDENTIFICATION REGISTER */
> +#define DA9058_CHIPID_MRC			(15<<4)
> +#define DA9058_CHIPID_TRC			(15<<0)
> +/* CONFIGURATION IDENTIFICATION REGISTER */
> +#define DA9058_CONFIGID_CONFID			(7<<0)
> +/* OTP CONTROL REGISTER */
> +#define DA9058_OTPCONT_GPWRITEDIS		(1<<7)
> +#define DA9058_OTPCONT_OTPCONFLOCK		(1<<6)
> +#define DA9058_OTPCONT_OTPGPLOCK		(1<<5)
> +#define DA9058_OTPCONT_OTPCONFG			(1<<3)
> +#define DA9058_OTPCONT_OTPGP			(1<<2)
> +#define DA9058_OTPCONT_OTPRP			(1<<1)
> +#define DA9058_OTPCONT_OTPTRANSFER		(1<<0)
> +/* RTC OSCILLATOR TRIM REGISTER */
> +#define DA9058_OSCTRIM_TRIM32K			(255<<0)
> +/* GP ID REGISTERs 0 - 9 */
> +#define DA9058_GPID0_GP0			(255<<0)
> +#define DA9058_GPID1_GP1			(255<<0)
> +#define DA9058_GPID2_GP2			(255<<0)
> +#define DA9058_GPID3_GP3			(255<<0)
> +#define DA9058_GPID4_GP4			(255<<0)
> +#define DA9058_GPID5_GP5			(255<<0)
> +#define DA9058_GPID6_GP6			(255<<0)
> +#define DA9058_GPID7_GP7			(255<<0)
> +#define DA9058_GPID8_GP8			(255<<0)
> +#define DA9058_GPID9_GP9			(255<<0)
> +
> +#endif /* __DA9058_REGISTERS_H */
> diff --git a/include/linux/mfd/da9058/regulator.h b/include/linux/mfd/da9=
058/regulator.h
> new file mode 100644
> index 0000000..83d4479
> --- /dev/null
> +++ b/include/linux/mfd/da9058/regulator.h
> @@ -0,0 +1,26 @@
> +/*
> + *  Copyright (C) 2012, 2013 Dialog Semiconductor Ltd.
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + */
> +
> +#ifndef __DA9058_REGULATOR_H
> +#define __DA9058_REGULATOR_H
> +
> +struct da9058_regulator_pdata {
> +	struct regulator_init_data init;
> +
> +	int regulator_id;
> +	int control_voltage_step;
> +	int control_register;
> +	int control_step_mask;
> +	int control_enable_mask;
> +	int ramp_register;
> +	int ramp_enable_mask;
> +};
> +
> +#endif /* __DA9058_REGULATOR_H */
> diff --git a/include/linux/mfd/da9058/rtc.h b/include/linux/mfd/da9058/rt=
c.h
> new file mode 100644
> index 0000000..4f25526
> --- /dev/null
> +++ b/include/linux/mfd/da9058/rtc.h
> @@ -0,0 +1,17 @@
> +/*
> + *  Copyright (C) 2012, 2013 Dialog Semiconductor Ltd.
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + */
> +
> +#ifndef __DA9058_RTC_H
> +#define __DA9058_RTC_H
> +
> +struct da9058_rtc_pdata {
> +};
> +
> +#endif /* __DA9058_RTC_H */
> --=20
> end-of-patch for NEW DRIVER V6
>=20

--O27Gs9jTTFWz3gAR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRdTvXAAoJELSic+t+oim9WmQP/iIoCdZzJHrzVW0aNU+CnYsL
DwmbD/Q1ySQyQdLthG79K6roO3BsJNwgPBMB3SHATEWBXIU9rGn94dy4PiB0pu6H
RYSbqLvUNEn4EpXVPLIYIF3jwYrKLzYEicb9tUsdnvMPBUstUl5n8m+yJrJDKd+M
uYy4agak8cahtoyUXBYY6m7c7kUG70HS4j77RwKV8+qGPAr2YdB9V4PnQz8Xd31G
VwNkpx9by3Yhh7B/pYnWAr711ZzPjoBWdddp64pYo6ZM26/AY+Z2Wd27QeMuZi9r
ajXp+kBx6RcSzrV5cUaueo1Hz1vUPfDfFoDf+gJS5ACO/2wvLYMAZ9JeEpi7a0xV
hnUVUdSDUGJZKONHA3TmlQg6s6JACEhxHROwzy8JnC7sFs+mFmkiNs4BCWp9cNgb
Xw9Rv+Cb7wPSkYr6MAjxbursZjIlmxvMQt9A+Hfxrx0j2zPH88rIO4aDyOnjuyFR
4xM+FyBQ4bdvhNAdtAGOsGjgUIHZvLSdOYV2ImMsKugB32+qK6fYMXqTPxCVC1dx
wT+7Hwj6Gr5/T3ZCPbf0FxWjh4bd0wdbiqHzAmN1bg2Fa/s7CRkgfAfIzWj2fPDQ
BrgLQ+lJZDdyAq5fq61YppYQy3tFYdudYypTycPVIedw3wSAB4JX8ucGPEbkxUJx
og//9qed2az6NvGLhZgS
=Drm6
-----END PGP SIGNATURE-----

--O27Gs9jTTFWz3gAR--
