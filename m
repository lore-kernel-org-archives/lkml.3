Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbaGBPne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 11:43:34 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57416 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754728AbaGBPnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 11:43:32 -0400
Date: Wed, 2 Jul 2014 10:43:23 -0500
From: Felipe Balbi <balbi@ti.com>
To: Dan Murphy <dmurphy@ti.com>
CC: <balbi@ti.com>, <linux-sound@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <broonie@kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3] ASoC: tas2552: Support TI TAS2552 Amplifier
Message-ID: <20140702154323.GD5541@saruman.home>
Reply-To: <balbi@ti.com>
References: <1404307852-10456-1-git-send-email-dmurphy@ti.com>
 <20140702141001.GA5541@saruman.home>
 <53B41CD6.8090403@ti.com>
 <20140702150259.GC5541@saruman.home>
 <53B42591.5080608@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u65IjBhB3TIa72Vp"
Content-Disposition: inline
In-Reply-To: <53B42591.5080608@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--u65IjBhB3TIa72Vp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jul 02, 2014 at 10:30:25AM -0500, Dan Murphy wrote:
> On 07/02/2014 10:03 AM, Felipe Balbi wrote:
> > Hi,
> >
> > On Wed, Jul 02, 2014 at 09:53:10AM -0500, Dan Murphy wrote:
> >> Felipe
> >> Thanks for the review
> >>
> >> On 07/02/2014 09:10 AM, Felipe Balbi wrote:
> >>> Hi,
> >>>
> >>> On Wed, Jul 02, 2014 at 08:30:52AM -0500, Dan Murphy wrote:
> >>>> Support the TI TAS2552 Class D amplifier.
> >>>>
> >>>> The TAS2552 is a high efficiency Class-D audio
> >>>> power amplifier with advanced battery current
> >>>> management and an integrated Class-G boost
> >>>> The device constantly measures the
> >>>> current and voltage across the load and provides a
> >>>> digital stream of this information.
> >>>>
> >>>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> >>>> ---
> >>>>
> >>>> v3 - Updated bindings doc per comments, rearranged probe pdata vs=20
> >>>> np check - https://patchwork.kernel.org/patch/4453481/
> >>>>
> >>>>  .../devicetree/bindings/sound/tas2552.txt          |   22 +
> >>>>  include/sound/tas2552-plat.h                       |   25 ++
> >>>>  sound/soc/codecs/Kconfig                           |    5 +
> >>>>  sound/soc/codecs/Makefile                          |    2 +
> >>>>  sound/soc/codecs/tas2552.c                         |  463 +++++++++=
+++++++++++
> >>>>  sound/soc/codecs/tas2552.h                         |   75 ++++
> >>>>  6 files changed, 592 insertions(+)
> >>>>  create mode 100644 Documentation/devicetree/bindings/sound/tas2552.=
txt
> >>>>  create mode 100644 include/sound/tas2552-plat.h
> >>>>  create mode 100644 sound/soc/codecs/tas2552.c
> >>>>  create mode 100644 sound/soc/codecs/tas2552.h
> >>>>
> >>>> diff --git a/Documentation/devicetree/bindings/sound/tas2552.txt b/D=
ocumentation/devicetree/bindings/sound/tas2552.txt
> >>>> new file mode 100644
> >>>> index 0000000..ada8fd4
> >>>> --- /dev/null
> >>>> +++ b/Documentation/devicetree/bindings/sound/tas2552.txt
> >>>> @@ -0,0 +1,22 @@
> >>>> +Texas Instruments - tas2552 Codec module
> >>>> +
> >>>> +The tas2552 serial control bus communicates through I2C protocols
> >>>> +
> >>>> +Required properties:
> >>>> +
> >>>> +- compatible - One of:
> >>>> +    "ti,tas2552" - TAS2552
> >>>> +
> >>>> +- reg -  I2C slave address
> >>>> +
> >>>> +Optional properties:
> >>>> +
> >>>> +- power-gpio - gpio pin to enable/disable the device
> >>>> +
> >>>> +Example:
> >>>> +
> >>>> +tas2552: tas2552@41 {
> >>>> +	compatible =3D "ti,tas2552";
> >>>> +	reg =3D <0x41>;
> >>>> +	enable-gpio =3D <&gpio4 2 GPIO_ACTIVE_HIGH>;
> >>> you probably want to add:
> >>>
> >>> 	pvdd-supply =3D <&pvdd>;
> >>> 	vbat-supply =3D <&vbat>;
> >>> 	avdd-supply =3D <&avdd>;
> >>> 	iovdd-supply =3D <&iovdd>;
> >>>
> >>> that way you can make sure to switch your regulators on from the driv=
er.
> >>> Since they must be all on, you can just grab them all with
> >>> regulator_bulk_get() and enable them all with regulator_bulk_enable().
> >> I could add this but I don't have a use case for this so I did not add
> >> the code.
> > actually, you do. Right now you have a device which is powered by
> > several different sources (fixed or not).
>=20
> Does the regulator_enable *gaurantee* that the supplies will be turned on=
 in
> the following order?
>=20
> 1. VBAT,
> 2. IOVDD,
> 3. AVDD.

you can always regulator_enable() each one in the order you want.

> >> The supplies I used were always-on so adding the regulators was not
> >> testable in this patchset.
> > it _is_ testable. regulator_get()/regulator_enable() still works on
> > fixed regulators.
>=20
> I did not say i used fixed regulators.  I indicated that the regulators
> were always-on.  So regulator_enable/disable would have no affect.  right?
>=20
> I mean you cannot turn off vbat right?

It depends. If you're sharing VBAT with the board's power source, then
yeah, you can't disable it. You would still see
regulator_enable()/regulator_disable() being called, which serves as
unit testing.

And VBAT, *would* be modeled as a fixed regulator, so all the code paths
are tested, it's just that there's no gpio (or whatever) to be toggled
for VBAT.

> >>>> @@ -325,3 +326,4 @@ obj-$(CONFIG_SND_SOC_WM_HUBS)	+=3D snd-soc-wm-hu=
bs.o
> >>>>  # Amp
> >>>>  obj-$(CONFIG_SND_SOC_MAX9877)	+=3D snd-soc-max9877.o
> >>>>  obj-$(CONFIG_SND_SOC_TPA6130A2)	+=3D snd-soc-tpa6130a2.o
> >>>> +obj-$(CONFIG_SND_SOC_TAS2552)	+=3D snd-soc-tas2552.o
> >>>> diff --git a/sound/soc/codecs/tas2552.c b/sound/soc/codecs/tas2552.c
> >>>> new file mode 100644
> >>>> index 0000000..79b8212
> >>>> --- /dev/null
> >>>> +++ b/sound/soc/codecs/tas2552.c
> >>>> @@ -0,0 +1,463 @@
> >>>> +/*
> >>>> + * ALSA SoC Texas Instruments TAS2552 Mono Audio Amplifier
> >>>> + *
> >>>> + * Copyright (C) 2014 Texas Instruments Inc.
> >>>> + *
> >>>> + * Author: Dan Murphy <dmurphy@ti.com>
> >>>> + *
> >>>> + * This program is free software; you can redistribute it and/or
> >>>> + * modify it under the terms of the GNU General Public License
> >>>> + * version 2 as published by the Free Software Foundation.
> >>>> + *
> >>>> + * This program is distributed in the hope that it will be useful, =
but
> >>>> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> >>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> >>>> + * General Public License for more details.
> >>>> + */
> >>>> +
> >>>> +#include <linux/module.h>
> >>>> +#include <linux/errno.h>
> >>>> +#include <linux/device.h>
> >>>> +#include <linux/i2c.h>
> >>>> +#include <linux/gpio.h>
> >>>> +#include <linux/of_gpio.h>
> >>>> +#include <linux/regmap.h>
> >>>> +#include <linux/slab.h>
> >>>> +
> >>>> +#include <sound/pcm.h>
> >>>> +#include <sound/pcm_params.h>
> >>>> +#include <sound/soc.h>
> >>>> +#include <sound/soc-dapm.h>
> >>>> +#include <sound/tlv.h>
> >>>> +#include <sound/tas2552-plat.h>
> >>>> +
> >>>> +#include "tas2552.h"
> >>>> +
> >>>> +static struct reg_default tas2552_reg_defs[] =3D {
> >>>> +	{TAS2552_CFG_1, 0x16},
> >>>> +	{TAS2552_CFG_3, 0x5E},
> >>>> +	{TAS2552_DOUT, 0x00},
> >>>> +	{TAS2552_OUTPUT_DATA, 0xC8},
> >>>> +	{TAS2552_PDM_CFG, 0x02},
> >>>> +	{TAS2552_PGA_GAIN, 0x10},
> >>>> +	{TAS2552_BOOST_PT_CTRL, 0x0F},
> >>>> +	{TAS2552_LIMIT_LVL_CTRL, 0x0C},
> >>>> +	{TAS2552_LIMIT_RATE_HYS, 0x20},
> >>>> +	{TAS2552_CFG_2, 0xEA},
> >>>> +	{TAS2552_SER_CTRL_1, 0x00},
> >>>> +	{TAS2552_SER_CTRL_2, 0x00},
> >>>> +	{TAS2552_PLL_CTRL_1, 0x10},
> >>>> +	{TAS2552_PLL_CTRL_2, 0x00},
> >>>> +	{TAS2552_PLL_CTRL_3, 0x00},
> >>>> +	{TAS2552_BTIP, 0x8f},
> >>>> +	{TAS2552_BTS_CTRL, 0x80},
> >>>> +	{TAS2552_LIMIT_RELEASE, 0x05},
> >>>> +	{TAS2552_LIMIT_INT_COUNT, 0x00},
> >>>> +	{TAS2552_EDGE_RATE_CTRL, 0x40},
> >>>> +	{TAS2552_VBAT_DATA, 0x00},
> >>>> +};
> >>>> +
> >>>> +struct tas2552_data {
> >>>> +	struct mutex mutex;
> >>>> +	struct snd_soc_codec *codec;
> >>>> +	struct regmap *regmap;
> >>>> +	struct i2c_client *tas2552_client;
> >>>> +	unsigned char regs[TAS2552_VBAT_DATA];
> >>>> +	int power_gpio;
> >>>> +	u8 power_state:1;
> >>>> +};
> >>>> +
> >>>> +static int tas2552_power(struct tas2552_data *data, u8 power)
> >>>> +{
> >>>> +	int	ret =3D 0;
> >>>> +
> >>>> +	BUG_ON(data->tas2552_client =3D=3D NULL);
> >>> don't hang the entire machine because of a bug on the amplifier drive=
r,
> >>> WARN() should be enough, followed by the return of an error code.
> >>>
> >>> In fact, is this really necessary ? It would be a simple bug on the
> >>> driver to fix.
> >> Yeah I can remove this.  I was following an older example.
> >>
> >>>> +
> >>>> +	mutex_lock(&data->mutex);
> >>>> +	if (power =3D=3D data->power_state)
> >>> Same here. Is this really necessary ? It's simple to guarantee this c=
ase
> >>> won't happen in code.
> >> Yes this LOC is necessary.  It is checking the current state of the ta=
s2552.
> > heh, the point is that all your calls to this function can be balanced
> > easily, so this check becomes pointless, as it will never be true.
>=20
> I will remove it.
>=20
> >>>> +		goto exit;
> >>>> +
> >>>> +	if (power) {
> >>>> +		if (data->power_gpio >=3D 0)
> >>>> +			gpio_set_value(data->power_gpio, 1);
> >>>> +
> >>>> +		data->power_state =3D 1;
> >>>> +	} else {
> >>>> +		if (data->power_gpio >=3D 0)
> >>>> +			gpio_set_value(data->power_gpio, 0);
> >>>> +
> >>>> +		data->power_state =3D 0;
> >>>> +	}
> >>>> +
> >>>> +exit:
> >>>> +	mutex_unlock(&data->mutex);
> >>>> +	return ret;
> >>>> +}
> >>>> +
> >>>> +static void tas2552_sw_shutdown(struct tas2552_data *tas_data, int =
sw_shutdown)
> >>>> +{
> >>>> +	u8 cfg1_reg =3D 0x0;
> >>>> +
> >>>> +	if (sw_shutdown)
> >>>> +		cfg1_reg |=3D (sw_shutdown << 1);
> >>> this line is dangerous. You're using a 32-bit variable to write a sin=
gle
> >>> bit on cfg1 register. What if user passes 0xff on sw_shutdown ?
> >>>
> >>> I think a better approach would be to:
> >>>
> >>> a) first of all, move this sw_shutdown function to
> >>> runtime_suspend/runtime_resume.
> >> Yeah that is not the intent of this API.  This API is called when the =
ALSA layer
> >> opens/closes the device.  It is not governed by pm calls.
> > and PM calls are exactly for that. You start with a powered off device,
> > then when user wants to use it, you power it up. This is exactly what's
> > you're doing here.
>=20
> I will look into it.
>=20
> But I am not convinced I need these calls yet.

what your shutdown function is basically a private runtime_pm
implementation. Look at your usage of it:

	shutdown(0);
	do_something_magical();
	shutdown(1);

The translation to:

	pm_runtime_get_sync();
	do_something_magical();
	pm_runtime_put_sync();

is really straight forward. You can even move the GPIO enable to
runtime_resume() and this shutdown(1) to runtime_idle so that it would
look like:

static int tas2552_runtime_resume(struct device *dev)
{
	struct tas2552_data *tas =3D dev_get_drvdata(dev);
	u8 reg;

	gpio_set_value(tas->enable_gpio, 1);
	reg |=3D TAS2552_SWS;
	snd_soc_update_bits(tas_data->codec, TAS2552_CFG_1,
			TAS2552_SWS_MASK, reg);

	return 0;
}

static int tas2552_runtime_suspend(struct device *dev)
{
	struct tas2552_data *tas =3D dev_get_drvdata(dev);

	gpio_set_value(tas->enable_gpio, 0);

	return 0;
}

static int tas2552_runtime_idle(struct device *dev)
{
	struct tas2552_data *tas =3D dev_get_drvdata(dev);
	u8 reg;

	reg &=3D ~TAS2552_SWS;
	snd_soc_update_bits(tas_data->codec, TAS2552_CFG_1,
			TAS2552_SWS_MASK, reg);
}

how to properly use them in this driver and make sure the device is only
"suspended" on close() is left as an exercise.

> >>> b) to the check as below:
> >>>
> >>> 	if (shutdown)
> >>> 		cfg1_reg |=3D TAS2552_SWS;
> >>> 	else
> >>> 		cfg1_reg &=3D ~TAS2552_SWS;
> >>>
> >>> then, of course #define TAS2552_SWS (1 << 1) (or BIT(1), even)
> >> But I will make this change.
> >>
> >>>> +	else
> >>>> +		cfg1_reg &=3D ~TAS2552_SWS_MASK;
> >>>> +
> >>>> +	snd_soc_update_bits(tas_data->codec, TAS2552_CFG_1,
> >>>> +						 TAS2552_SWS_MASK, cfg1_reg);
> >>>> +}
> >>>> +
> >>>> +static void tas2552_init(struct snd_soc_codec *codec)
> >>>> +{
> >>>> +	snd_soc_write(codec, TAS2552_CFG_1, 0x16);
> >>>> +	snd_soc_write(codec, TAS2552_CFG_3, 0x5E);
> >>>> +	snd_soc_write(codec, TAS2552_DOUT, 0x00);
> >>>> +	snd_soc_write(codec, TAS2552_OUTPUT_DATA, 0xC8);
> >>>> +	snd_soc_write(codec, TAS2552_PDM_CFG, 0x02);
> >>>> +	snd_soc_write(codec, TAS2552_PGA_GAIN, 0x10);
> >>>> +	snd_soc_write(codec, TAS2552_BOOST_PT_CTRL, 0x0F);
> >>>> +	snd_soc_write(codec, TAS2552_LIMIT_LVL_CTRL, 0x0C);
> >>>> +	snd_soc_write(codec, TAS2552_LIMIT_RATE_HYS, 0x20);
> >>>> +	snd_soc_write(codec, TAS2552_CFG_2, 0xEA);
> >>> what do all these magic constants mean ? Also, lower case hex numbers
> >>> are usually preferred.
> >> I will add comments to what the numbers mean and change to lower case
> > I would rather see proper bit macros and the driver using them.
>=20
> Yeah I started doing that in my initial driver but the bit macros were ge=
tting
> a little obsessive.
>=20
> >
> >>> No battery tracking ?  Any plans to add that at a later date ? It's
> >>> probably not needed to have functional audio, but might have some use
> >>> cases where you want it.
> >> The battery tracking was not the scope of the driver.  We just need to
> >> get the basic driver in place with audio functional and add the
> >> battery tracking later.
> > it's a single bit
>=20
> I will flip the bit for the default.
>=20
> I looked back in my emails and it was the IVsense code I could not develo=
p not
> the battery checking.

if you really want to make sure the device *does* track the battery,
just hook that pin to a lab power supply and slowly dial down the output
voltage, then look at the gain to see if it is tracking.

--=20
balbi

--u65IjBhB3TIa72Vp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTtCibAAoJEIaOsuA1yqREyrMP/2ncWhnIuk7vsjvpFBHCMcL6
vZqqQ3NjmFGyCE+GJcOekdHx8hjWVnKQbIQ2xsnuowUdy9fvJO/6G/Y9JMzMVxMv
dXO7TTZsOxSq5gbLnVpq6B2IekwDyLg/VfUBtP3t/dIIW+n7eGbgxMACOl1YdAE6
ykqH/bBMOl19B33pa4rWiugFCUeqXR/n3Kvh2NscCKmG7FfIpOM4yLAyWuTjNvbM
4kVJgqJDEuV7Qe3Yl1SEBPIW+YFccltk+lNG391cWp2ACWrXS869zPqVud6s30ee
GYXcTsSEjpqqpOIVPYYCNWThPrBIUNPvGwdej7SsYdqVR7YkkUPSiiW4RP8IlwUx
YBbF9y5FAQ+gyjch9sytPZGFZfxcpnu2D5VJ0VK/zQMRnErjIwOSYq1f5ix8gxuY
KC+nQFvpwtrm+NaPlTxmEBM27dShx+MNgy99pHIu9bekkDNjMisq2qMm08RlHjuw
xS8nBZnqn4JIgZci+vAc1u1I/kRxSc09TL4lNhD/CUNBhkcDRMdtCNZLKHBqwgJc
ewX/TUTdgSjv30vGqn81ZKbIbv6ZueGJD4vS3Z0KPZW4cirstiwco88+Rvmix+uQ
Q16KTatw+6qIttnm0HOFy8foIBBNxenBDZTw6Nd4EsMLRJ5mWBri3v8M7c/wyqw6
ueoFpytROdrcmIh1O1h8
=pxxS
-----END PGP SIGNATURE-----

--u65IjBhB3TIa72Vp--
