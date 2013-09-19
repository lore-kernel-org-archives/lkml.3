Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab3ISU2Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 16:28:25 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:38495 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab3ISU2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 16:28:23 -0400
Date: Thu, 19 Sep 2013 22:27:07 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>,
        Manish Badarkhe <badarkhe.manish@gmail.com>,
        Darbha Sriharsha <dsriharsha@nvidia.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [Patch V2] drivers: power: Add support for bq24735 charger
Message-ID: <20130919202706.GB4470@ulmo>
References: <1379607514-11200-1-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H+4ONPRPur6+Ovig"
Content-Disposition: inline
In-Reply-To: <1379607514-11200-1-git-send-email-rklein@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H+4ONPRPur6+Ovig
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 19, 2013 at 12:18:33PM -0400, Rhyland Klein wrote:
> From: Darbha Sriharsha <dsriharsha@nvidia.com>
>=20
> Adding driver support for bq24735 charger chipset.

This could be somewhat more descriptive. Merely repeating the subject
doesn't add useful information.

> diff --git a/Documentation/devicetree/bindings/power_supply/ti,bq24735.tx=
t b/Documentation/devicetree/bindings/power_supply/ti,bq24735.txt
[...]
> +Optional properties :
> + - ti,ac-detect: This gpio is optionally used to read the ac adapter
> +   presence.

"GPIO". And if this truly is a reference to a GPIO I think it should be
named something like: ti,ac-detect-gpio(s).

> + - ti,charge-current : Used to control and set the charging current. Thi=
s value
> +   must follow the below guidelines:

Perhaps the wording should be clearer here. Something like:

	The charging current is specified by ORing together the bits
	listed below and summing up their respective weights.

> +	bit 0 - 5:	Not used
> +	bit 6:		1 =3D Adds 64mA of charger current
> +	bit 7:		1 =3D Adds 128mA of charger current
> +	bit 8:		1 =3D Adds 256mA of charger current
> +	bit 9:		1 =3D Adds 512mA of charger current
> +	bit 10:		1 =3D Adds 1024mA of charger current
> +	bit 11:		1 =3D Adds 2048mA of charger current
> +	bit 12:		1 =3D Adds 4096mA of charger current

Then again, these bits match the actual values, so it might just be
easier to simply state that the current must be a multiple of 64 mA
(and the below limits).

> +	bit 13 - 15:	Not used
> +   Setting the value to < 128mA or > 8.128A terminates charging.

If my math doesn't deceive me, using the above you can't set the current
to > 8.128 A. In fact, adding in all the bits yields exactly 8128 mA.

> + - ti,charge-voltage : Used to control and set the charging voltage. Thi=
s value
> +   must follow the below guidelines:
> +	bit 0 - 3:	Not used
> +	bit 4:		1 =3D Adds 16mV of charger voltage
> +	bit 5:		1 =3D Adds 32mV of charger voltage
> +	bit 6:		1 =3D Adds 64mV of charger voltage
> +	bit 7:		1 =3D Adds 128mV of charger voltage
> +	bit 8:		1 =3D Adds 256mV of charger voltage
> +	bit 9:		1 =3D Adds 512mV of charger voltage
> +	bit 10:		1 =3D Adds 1024mV of charger voltage
> +	bit 11:		1 =3D Adds 2048mV of charger voltage
> +	bit 12:		1 =3D Adds 4096mV of charger voltage
> +	bit 13:		1 =3D Adds 8192mV of charger voltage
> +	bit 14:		1 =3D Adds 16384mV of charger voltage

Same comments here.

> +	bit 15:		Not used
> +   Setting the value to < 1.024V or > 19.2V terminates charging.
> + - ti,input-current:	Used to control and set the charger input current. =
This

Nit: formatting here is inconsistent: sometimes there's a space on both
sides of the colon, here, there's no space on the left, but the space on
the right is actually a tab.

> +   value must follow the below guidelines:
> +	bit 0 - 6:	Not used
> +	bit 7:		1 =3D Adds 128mA of input current
> +	bit 8:		1 =3D Adds 256mA of input current
> +	bit 9:		1 =3D Adds 512mA of input current
> +	bit 10:		1 =3D Adds 1024mA of input current
> +	bit 11:		1 =3D Adds 2048mA of input current
> +	bit 12:		1 =3D Adds 4086mA of input current

And here. Also, should 4086 really be 4096?

> +	bit 13 - 15:	Not used
> +   Setting the value to < 128mA or > 8.064A terminates charging.

Again, none of the combinations of the valid bits are outside of the
range specified here. But I think it'd be easier to just specify the
valid range here and that it needs to be a multiple of 128 mA.

> +Example:
> +
> +	bq24735@9 {
> +		compatible =3D "ti,bq24735";
> +		reg =3D < 0x9 >;

No space after < or before >.

> +		ti,ac-detect =3D <&gpio 72 0x1>;
> +	}

Since this doesn't list any of the ti,charge-current, ti,charge-voltage
or ti,input-current properties, perhaps the document should mention the
defaults?

> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
[...]
>  	help
>  	  Say Y to enable support for the TI BQ24190 battery charger.
> =20
> +config CHARGER_BQ24735
> +	tristate "BQ24735 battery charger support"
> +	depends on I2C && GPIOLIB
> +	help
> +	  bq24735 is the battery charger chipset.
> +	  Say Y here to enable battery charging driver support for
> +	  bq24735

Perhaps keep this consistent with the BQ24190 entry above?

> diff --git a/drivers/power/bq24735-charger.c b/drivers/power/bq24735-char=
ger.c
[...]
> new file mode 100644
> index 0000000..8271558
> --- /dev/null
> +++ b/drivers/power/bq24735-charger.c
> @@ -0,0 +1,384 @@
> +/*
> + * drivers/power/bq24735-charger.c

I'd leave this out. It's unnecessary.

> + *
> + * Battery charger driver for bq24735 from TI

Nit: this sounds like the driver is "from TI". Perhaps:

	battery charger driver for TI BQ24735

?

> + * You should have received a copy of the GNU General Public License alo=
ng
> + * with this program; if not, write to the Free Software Foundation, Inc=
=2E,
> + * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
> + */
> +#include <linux/init.h>

Nit: could use a space between the above two lines.

> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/err.h>
> +#include <linux/i2c.h>
> +#include <linux/power_supply.h>
> +#include <linux/slab.h>
> +#include <linux/interrupt.h>
> +#include <linux/of.h>
> +#include <linux/gpio.h>
> +#include <linux/of_gpio.h>

Perhaps sort this list alphabetically?

> +struct bq24735_charger {

Perhaps just bq24735? _charger seems redundant.

> +	struct power_supply	charger;
> +	struct device		*dev;

This field is used in exactly two locations, where it would be easier to
just use the i2c_client.dev field instead.

> +	struct i2c_client	*client;
> +	struct bq24735_platform	*pdata;

The tendency has been to not borrow trouble by adding platform data
support unless you actually use it. So can this perhaps be dropped?

> +	int			irq;

This is the same as i2c_client.irq, so redundant and can be dropped.

> +static int bq24735_write_word(struct i2c_client *client, int reg, u16 va=
lue)

reg should probably be u8 because that's the type passed to
i2c_smbus_write_word_data().

> +{
> +	s32 ret;
> +
> +	ret =3D i2c_smbus_write_word_data(client, reg, le16_to_cpu(value));
> +	if (ret < 0)
> +		dev_err(&client->dev, "Failed in writing to 0x%x\n", reg);
> +	return ret;
> +}

I'm not sure if we need that error here. This can probably be better
handled in callers. That way you can make this a one line function.

> +static int bq24735_read_word(struct i2c_client *client, int reg)

u8 for reg.

> +{
> +	s32 ret;
> +
> +	ret =3D i2c_smbus_read_word_data(client, reg);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "Failed in reading from 0x%x\n", reg);
> +		return ret;
> +	}
> +
> +	return le16_to_cpu(ret);
> +}

Equally this can be made simpler:

{
	s32 ret =3D i2c_smbus_read_word_data(client, reg);

	return ret < 0 ? ret : le16_to_cpu(ret);
}

> +static int bq24735_update_word(struct i2c_client *client, int reg,

u8 for reg.

> +	ret =3D bq24735_read_word(client, reg);
> +	if (ret < 0)
> +		return ret;
> +
> +	tmp =3D ret & ~mask;
> +	tmp |=3D value & mask;
> +
> +	ret =3D bq24735_write_word(client, reg, tmp);
> +
> +	return ret;

Just: return bq24735_write_word(...);

> +static int bq24735_config_charger(struct bq24735_charger *charger)
> +{
> +	int ret =3D 0;
> +	u16 value =3D 0;

I don't think you need to initialize these to 0 since you'll be
overwriting them immediately anyway.

> +	struct bq24735_platform *pdata =3D charger->pdata;
> +
> +	if (pdata->charge_current) {
[...]
> +	}
> +
> +	if (pdata->charge_voltage) {
[...]
> +	}
> +
> +	if (pdata->input_current) {
[...]
> +	}
> +	return ret;

If you don't initialize ret, then it might end up uninitialized here,
but since this is only reached when everything else succeeded, this can
probably just be "return 0;", can't it?

> +static irqreturn_t bq24735_charger_isr(int irq, void *devid)
> +{
> +	struct power_supply *charger =3D devid;
> +
> +	power_supply_changed(charger);
> +
> +	return IRQ_HANDLED;
> +}

I may have missed this, but where does the interrupt come from? The
device tree binding didn't seem to specify an interrupts property. But
looking at what this ISR does, it seems like it handles interrupts from
the ti,ac-detect GPIO. But I don't see how that ends up in the
i2c_client.irq field.

> +static int bq24735_charger_get_property(struct power_supply *psy,
> +	enum power_supply_property psp, union power_supply_propval *val)

Alignment of arguments isn't right here.

> +{
> +	struct bq24735_charger *bq24735_charger;

Just "bq24735", or "charger" would be good names too, and shorter.

> +	struct bq24735_platform *pdata;
> +
> +	bq24735_charger =3D container_of(psy, struct bq24735_charger, charger);

Perhaps this should be a static inline wrapper: to_bq2475()?

> +	pdata =3D bq24735_charger->pdata;
> +
> +	switch (psp) {
> +	case POWER_SUPPLY_PROP_ONLINE:
> +		if (pdata->status_gpio) {
> +			val->intval =3D gpio_get_value_cansleep(
> +							pdata->status_gpio);
> +			val->intval ^=3D  pdata->gpio_active_low;

There's an extra space between ^=3D and pdata->.

> +		} else {
> +			int ac =3D 0;
> +
> +			ac =3D bq24735_read_word(bq24735_charger->client,
> +						BQ24735_CHG_OPT_REG);
> +			val->intval =3D (ac & BQ24735_CHG_OPT_AC_PRESENT) ? 1 : 0;

You should probably check for ac < 0 before setting the value here.

> +		}

Perhaps move this whole code for the online property into a separate
function. It's not really huge, but it'll remove one level of
indentation, which may result in less wrapping of statements across
several lines.

> +static int bq24735_enable_charging(struct bq24735_charger *charger)
> +{
> +	int ret =3D 0;

No need to initialize this variable.

> +
> +	ret =3D bq24735_update_word(charger->client, BQ24735_CHG_OPT_REG,
> +				  BQ24735_CHG_OPT_CHARGE_ENABLE,
> +				  BQ24735_ENABLE_CHARGING);
> +	return ret;

Just "return bq24735_...(...);" will do.

> +#ifdef CONFIG_OF
> +static struct bq24735_platform *bq24735_parse_dt_data(
> +		struct i2c_client *client)
> +{
[...]
> +}
> +#else
> +static inline struct bq24735_platform *bq24735_parse_dt_data(
> +		struct i2c_client *client)
> +{
> +	return NULL;
> +}
> +#endif

Can we please get rid of the whole #ifdefery here? We have this really
cool tool that allows the compiler to handle this really well and give
us complete compile coverage. See below.

> +static int bq24735_charger_probe(struct i2c_client *client,
> +					const struct i2c_device_id *id)

Parameter alignment is not right.

> +{
> +	int ret =3D 0;

No need to initialize this to 0.

> +	struct bq24735_charger *charger_device;
> +	struct power_supply *charger;

This is confusing, perhaps call the charger just "charger", and the
power supply "supply"?

> +	char *name;
> +
> +	charger_device =3D devm_kzalloc(&client->dev, sizeof(*charger_device),
> +		GFP_KERNEL);

Parameter alignment again.

> +	if (!charger_device) {
> +		dev_err(&client->dev, "failed to allocate memory status\n");

No, we don't want to mention this explicitly. The allocator's output
should be quite verbose in case this really ever happens, so no need to
add to that.

> +		return -ENOMEM;
> +	}
> +
> +	charger_device->pdata =3D client->dev.platform_data;
> +
> +	if (!charger_device->pdata && client->dev.of_node)

If you use IS_ENABLED(CONFIG_OF) here, the compiler will see that it
evaluates to 0 if OF is not selected, in which case it will be clever
enough to see that bq24735_parse_dt_data() is not used and just discard
it (because it is static). Then the #ifdefery above is not needed and
you will get compile coverage whether or not OF has been selected. Which
is a good thing.

That said, I've mentioned before that you may want to not support the
non-DT at all since there's no immediate need, so this may not even be
an issue.

> +	name =3D charger_device->pdata->name;
> +	if (!name) {
> +		name =3D kasprintf(GFP_KERNEL, "bq24735-%s",
> +				 dev_name(&client->dev));

Won't the device name already include bq24735 because of the driver
name?

> +		if (!name) {
> +			dev_err(&client->dev, "Failed to alloc device name\n");

Again, no need for the error message.

> +	charger->supplied_to =3D charger_device->pdata->supplied_to;
> +	charger->num_supplicants =3D charger_device->pdata->num_supplicants;

I think these are never filled in in the DT case.

> +	ret =3D bq24735_read_word(charger_device->client,

You can just use client directly here.

> +				BQ24735_MANUFACTURER_ID_REG);
> +	if (ret !=3D BQ24735_MANUFACTURER_ID) {
> +		dev_err(charger_device->dev,
> +		"manufacturer id mismatch..exiting driver..\n");

This should be reformatted. It's just weird.

> +		ret =3D -ENODEV;

Perhaps differentiate between the original error (ret, instead of
overwriting it) and the case where the manufacturer ID doesn't match?

> +		goto err_free_name;
> +	}
> +
> +	if (client->irq) {
> +		ret =3D devm_request_threaded_irq(&client->dev, client->irq,

devm_request_threaded_irq() can be dangerous here. You seem to handle it
properly in remove, but the ISR could be run at any point from here on
in. And automatic removal will happen rather late.

The ISR could still be run at any point from here on in if you used the
non-devm variant, so it's probably safer to call this much later. Since
you'd call power_supply_changed() on an unregistered power_supply.

> +			NULL, bq24735_charger_isr,
> +			IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING |
> +			IRQF_ONESHOT,
> +			charger->name, charger);

Parameter indentation again.

> +		if (ret) {
> +			dev_err(&client->dev,
> +				"Unable to register irq %d err %d\n",

"IRQ"

> +	if (charger_device->pdata->status_gpio) {
> +		if (!gpio_is_valid(charger_device->pdata->status_gpio)) {

Why not make the first if check for gpio_is_valid()? Also, 0 is a valid
GPIO number.

> +			dev_err(&client->dev, "Invalid gpio pin\n");

"GPIO". And would it make sense to continue with degraded functionality
if no GPIO is specified? It seems like it given the initial check for a
non-zero GPIO.

> +	ret =3D bq24735_config_charger(charger_device);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "failed in configuring charger");
> +		goto err_free_name;
> +	}
> +
> +	/* check for AC adapter presence */
> +	ret =3D bq24735_read_word(charger_device->client, BQ24735_CHG_OPT_REG);
> +	if (ret < 0)
> +		goto err_free_name;
> +	else if (ret & BQ24735_CHG_OPT_AC_PRESENT) {
> +		/* enable charging */
> +		ret =3D bq24735_enable_charging(charger_device);
> +		if (ret < 0)
> +			goto err_free_name;
> +	}

I think you already had code for this (in the one property accessor?),
so perhaps it should be factored out.

Also I don't see where charging is disabled. Or enabled when AC power is
plugged after the device has been probed. How does that work?

> +err_free_name:
> +	if (name && name !=3D charger_device->pdata->name)
> +		kfree(name);

kfree() can handle NULL pointers, so the check for name is unnecessary.

> diff --git a/include/linux/power/bq24735-charger.h b/include/linux/power/=
bq24735-charger.h
[...]
> +#ifndef __CHARGER_BQ24735_H_
> +#define __CHARGER_BQ24735_H_

I would hope that we can get rid of this file. As I already mentioned,
unless you're actually going to use platform data, there's little sense
in adding support for it.

> +#define BQ24735_CHG_OPT_REG		0x12
> +#define BQ24735_CHG_OPT_CHARGE_ENABLE	(1 << 0)
> +#define BQ24735_ENABLE_CHARGING		0
> +#define BQ24735_DISABLE_CHARGING	1

I don't think these are really useful. The field is already named
CHARGE_ENABLE, so it should be pretty clear what you're supposed to put
in here. For that matter, I'm not a huge fan of the whole "update bits"
API because it encourages these things and they are just confusing.

> +#define BQ24735_CHG_OPT_ACOC_THRESHOLD	(1 << 1)
> +#define BQ24735_CHG_OPT_BOOST_MODE	(1 << 2)
> +#define BQ24735_CHG_OPT_BOOST_ENABLE	(1 << 3)
> +#define BQ24735_CHG_OPT_AC_PRESENT	(1 << 4)
> +#define BQ24735_CHG_OPT_IOUT_SELECTION	(1 << 5)
> +#define BQ24735_CHG_OPT_LEARN_ENABLE	(1 << 6)
> +#define BQ24735_CHG_OPT_IFAULT_LOW	(1 << 7)
> +#define BQ24735_CHG_OPT_IFAULT_HIGH	(1 << 8)
> +#define BQ24735_CHG_OPT_EMI_SW_FREQ_EN	(1 << 9)
> +#define BQ24735_CHG_OPT_EMI_SW_FREQ_ADJ	(1 << 10)
> +#define BQ24735_CHG_OPT_BAT_DEPLETION	(3 << 11)
> +#define BQ24735_CHG_OPT_WATCHDOG_TIMER	(3 << 13)
> +#define BQ24735_CHG_OPT_ACOK_DEGLITCH	(1 << 15)

Most (if not all) of these fields are unused, so I'm not sure if it
makes sense to list them here.

> +#define BQ24735_CHARGE_CURRENT_REG	0x14
> +#define BQ24735_CHARGE_CURRENT_MASK	0x1fc0
> +#define BQ24735_CHARGE_VOLTAGE_REG	0x15
> +#define BQ24735_CHARGE_VOLTAGE_MASK	0x7ff0
> +#define BQ24735_INPUT_CURRENT_REG	0x3f
> +#define BQ24735_INPUT_CURRENT_MASK	0x1f80
> +#define BQ24735_MANUFACTURER_ID_REG	0xfe
> +#define BQ24735_DEVICE_ID_REG		0xff

I think I'd drop the _REG suffix. Also perhaps these register
definitions should go into the driver source file.

> +#define BQ24735_MANUFACTURER_ID		0x0040
> +#define BQ24735_DEVICE_ID		0x000B

I think these could actually be used literally, since you read out a
register and compare the value to this one, it is immediately clear from
the context that they are the reference manufacturer and device IDs that
you expect for this driver.

> +struct bq24735_platform {
> +	uint32_t charge_current;
> +	uint32_t charge_voltage;
> +	uint32_t input_current;
> +
> +	const char *name;
> +
> +	int status_gpio;
> +	int gpio_active_low;

This is somewhat unfortunate. Perhaps status_gpio_active_low. That makes
it clear that it relates to the status_gpio, but it's also rather long.
Fortunately there's some good work being done to the GPIO core that will
hopefully make this unnecessary in the future.

> +
> +	char **supplied_to;
> +	size_t num_supplicants;
> +};

If you don't implement platform data support, you can get rid of this.
Move the registers to the driver source file and you don't need this
header file at all anymore.

Thierry

--H+4ONPRPur6+Ovig
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSO14aAAoJEN0jrNd/PrOh/KsQALJlE21hdz+RSmp77P0p/ACl
/iLTymK31RjfoBfbHKUf4ymt6XSWRNwZZadB+htAd3s5m1TWjBPYxCdzq42Y/9Ze
Nw7Qs98BYTpazo9U7XY9tgoXxfyJRp9q4wlwNZMNfa84xcrdXVl2pVedOI2paFj1
PV83LMVaalbN1aOGvFUG4Lwxa6Q+IZBL/jTZcrl14pLnHjEDu5fuJNlxBckCfDE9
JkVsP6+FHMbQ68qpye717ph5hM+GZCCd4i2rfaBpPo66DRQM+nZMihWbsOEHP+DH
qH7Zr/rsoueB9CVLOC2D39jxOrY1XFbNv3Yyz4TXzI9M7DigTA1vnKKLAekibG9N
55+Bx+TQMWnEDIKgwDDArfyJopoBIBPIDu57ldcrfoKwU5xhIBAlxwnmS14Owbn8
XxFDWmr9SvmC6ZL4SE3OGo/neTZU1CaOERKoEw3LmS6gTRtVmjGSgxk2XzIVulyc
3mL2ObhlvqszwRoD64Hx/7JN4Venr/SnG7ptMzGnYEXFTLkfzGOfDWTRd3RwxWRs
UkjPparqY+B6qjZVjV2NKldcfduKo/AajbbC+Oevwrju9EClnKKd9EgI0PH+mNsf
i7lbwgFXnR8UlOC5OYgDjRZChzuPb27moGGx7j98zNfhbEHutWn+Bon7QKHMn5oD
vb67mIcJODlIxDU5Rzhj
=zPdY
-----END PGP SIGNATURE-----

--H+4ONPRPur6+Ovig--
