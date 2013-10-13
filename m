Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab3JMXO0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 19:14:26 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45784 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755277Ab3JMXOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 19:14:24 -0400
Message-ID: <525B2939.6070608@ti.com>
Date: Sun, 13 Oct 2013 19:14:01 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Wendy Ng <wendy.ng@broadcom.com>
CC: Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Christian Daudt <bcm@fixthebug.org>,
        Markus Mayer <mmayer@broadcom.com>, <eduardo.valentin@ti.com>
Subject: Re: [PATCH v2 1/3] thermal: bcm281xx: Add thermal driver
References: <1380321454-16216-1-git-send-email-wendy.ng@broadcom.com> <1380321454-16216-2-git-send-email-wendy.ng@broadcom.com>
In-Reply-To: <1380321454-16216-2-git-send-email-wendy.ng@broadcom.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="oCg4uePpK0Lc58KdRDUBsJr0hJqkjfOwx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--oCg4uePpK0Lc58KdRDUBsJr0hJqkjfOwx
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 27-09-2013 18:37, Wendy Ng wrote:
> This adds the support for reading out temperature from Broadcom bcm281x=
x
> SoCs.
>=20
> Signed-off-by: Wendy Ng <wendy.ng@broadcom.com>
> Reviewed-by: Markus Mayer <mmayer@broadcom.com>
> Reviewed-by: Christian Daudt <csd@broadcom.com>
> ---
>  .../bindings/thermal/bcm-kona-thermal.txt          |   18 +++
>  drivers/thermal/Kconfig                            |   10 ++
>  drivers/thermal/Makefile                           |    1 +
>  drivers/thermal/bcm_thermal.c                      |  170 ++++++++++++=
++++++++
>  4 files changed, 199 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/thermal/bcm-kona-=
thermal.txt
>  create mode 100644 drivers/thermal/bcm_thermal.c
>=20
> diff --git a/Documentation/devicetree/bindings/thermal/bcm-kona-thermal=
=2Etxt b/Documentation/devicetree/bindings/thermal/bcm-kona-thermal.txt
> new file mode 100644
> index 0000000..acca99e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/thermal/bcm-kona-thermal.txt
> @@ -0,0 +1,18 @@
> +* Broadcom Kona Thermal Management Unit
> +
> +This version is for the BCM281xx family of SoCs.

Might be worth describing the hardware a bit and also appending a link
to its documentation for further details.

> +
> +Required properties:
> +- compatible : "brcm,bcm11351-thermal", "brcm,kona-thermal"
> +- reg : Address range of the thermal register
> +- thermal-name: this entry must be specified and it will be passed int=
o
> +thermal_zone_device_register().  This name will also be reported under=
 Hwmon
> +sysfs 'name' attribute.

I guess by now you already remember my suggestion on this dt property.
If you can drop it then we could proceed with this driver. But with it
we are adding something specific to it that may be soon deprecated.

> +
> +Example:
> +	thermal@34008000 {
> +		compatible =3D "brcm,bcm11351-thermal", "brcm,kona-thermal";
> +		reg =3D <0x34008000 0x0024>;
> +		thermal-name =3D "bcm_kona_therm";
> +		status =3D "disabled";
> +	};
> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> index dbfc390..6a5341c 100644
> --- a/drivers/thermal/Kconfig
> +++ b/drivers/thermal/Kconfig
> @@ -134,6 +134,16 @@ config KIRKWOOD_THERMAL
>  	  Support for the Kirkwood thermal sensor driver into the Linux therm=
al
>  	  framework. Only kirkwood 88F6282 and 88F6283 have this sensor.
> =20
> +config BCM_THERMAL
> +	tristate "Temperature sensor on Broadcom BCM281xx family of SoCs"
> +	depends on ARCH_BCM_MOBILE

Is the sensor IP used only on this Arch? No plans for re-usability?

> +	default y
> +	help
> +	  If you say yes here you get support for TMU (Thermal Management
> +	  Unit) on Broadcom BCM281xx family of SoCs. This provides thermal
> +	  monitoring of CPU clusters, graphics, and SoC glue, but does not
> +	  include monitoring of charger temperature.
> +
>  config DOVE_THERMAL
>  	tristate "Temperature sensor on Marvell Dove SoCs"
>  	depends on ARCH_DOVE
> diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
> index 584b363..3ea8c1c 100644
> --- a/drivers/thermal/Makefile
> +++ b/drivers/thermal/Makefile
> @@ -21,6 +21,7 @@ obj-$(CONFIG_SPEAR_THERMAL)	+=3D spear_thermal.o
>  obj-$(CONFIG_RCAR_THERMAL)	+=3D rcar_thermal.o
>  obj-$(CONFIG_KIRKWOOD_THERMAL)  +=3D kirkwood_thermal.o
>  obj-y				+=3D samsung/
> +obj-$(CONFIG_BCM_THERMAL)       +=3D bcm_thermal.o
>  obj-$(CONFIG_DOVE_THERMAL)  	+=3D dove_thermal.o
>  obj-$(CONFIG_DB8500_THERMAL)	+=3D db8500_thermal.o
>  obj-$(CONFIG_ARMADA_THERMAL)	+=3D armada_thermal.o
> diff --git a/drivers/thermal/bcm_thermal.c b/drivers/thermal/bcm_therma=
l.c
> new file mode 100644
> index 0000000..131d3c4
> --- /dev/null
> +++ b/drivers/thermal/bcm_thermal.c
> @@ -0,0 +1,170 @@
> +/*
> + * Copyright 2013 Broadcom Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modif=
y
> + * it under the terms of the GNU General Public License, version 2,
> + * as published by the Free Software Foundation (the "GPL").
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * A copy of the GPL is available at http://www.broadcom.com/licenses/=
GPLv2.php,
> + * or by writing to the Free Software Foundation, Inc.,
> + * 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
> + */
> +
> +/**
> +*  Broadcom Thermal Management Unit - bcm_tmu
> +*/
> +#include <linux/module.h>
> +#include <linux/err.h>
> +#include <linux/kernel.h>
> +#include <linux/platform_device.h>
> +#include <linux/io.h>
> +#include <linux/thermal.h>
> +#include <linux/of.h>
> +
> +/* From TMON Register Database */
> +#define TMON_TEMP_VAL_OFFSET			0x0000001c
> +#define TMON_TEMP_VAL_TEMP_VAL_SHIFT		0
> +#define TMON_TEMP_VAL_TEMP_VAL_MASK		0x000003ff
> +
> +/* Broadcom Thermal Zone Device Structure */
> +struct bcm_thermal_zone_priv {
> +	char name[THERMAL_NAME_LENGTH];
> +	void __iomem *base;
> +};
> +
> +/* Temperature conversion function for TMON block */
> +static long raw_to_mcelsius(u32 raw)
> +{
> +	/*
> +	 * According to Broadcom internal Analog Module Specification
> +	 * the formula for converting TMON block output to temperature in
> +	 * degree Celsius is:
> +	 *	T =3D 428 - (0.561 * raw)
> +	 * Note: the valid operating range for the TMON block is -40C to 125C=

> +	 */

Does 125C mean silicon is not reliable? Shall we define a critical trip
at this level?

> +	return 428000 - (561 * (long)raw);
> +}
> +
> +/* Get temperature callback function for thermal zone */
> +static int bcm_get_temp(struct thermal_zone_device *thermal,
> +			unsigned long *temp)
> +{
> +	u32 raw;
> +	long mcelsius;
> +	struct bcm_thermal_zone_priv *priv =3D thermal->devdata;
> +
> +	if (!priv) {
> +		pr_err("%s: thermal zone number %d devdata not initialized.\n",
> +			__func__, thermal->id);
> +		return -EINVAL;
> +	}
> +
> +	raw =3D (readl(priv->base + TMON_TEMP_VAL_OFFSET)
> +		& TMON_TEMP_VAL_TEMP_VAL_MASK) >> TMON_TEMP_VAL_TEMP_VAL_SHIFT;
> +
> +	pr_debug("%s: thermal zone number %d raw temp 0x%x\n", __func__,
> +		thermal->id, raw);
> +
> +	mcelsius =3D raw_to_mcelsius(raw);
> +
> +	/*
> +	 * Since 'mcelsius' might be negative, we need to limit it to smalles=
t
> +	 * unsigned value before returning it to thermal framework.
> +	 */

Do you have practical usage of negative values?

> +	if (mcelsius < 0)
> +		*temp =3D 0;
> +	else
> +		*temp =3D mcelsius;
> +
> +	pr_debug("%s: thermal zone number %d final temp %d\n", __func__,
> +		thermal->id, (int) *temp);
> +
> +	return 0;
> +}
> +
> +/* Operation callback functions for thermal zone */
> +static struct thermal_zone_device_ops bcm_dev_ops =3D {
> +	.get_temp =3D bcm_get_temp,
> +};
> +
> +static const struct of_device_id bcm_tmu_match_table[] =3D {
> +	{ .compatible =3D "brcm,kona-thermal" },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, bcm_tmu_match_table);
> +
> +static int bcm_tmu_probe(struct platform_device *pdev)
> +{
> +	struct thermal_zone_device *thermal =3D NULL;
> +	struct bcm_thermal_zone_priv *priv;
> +	struct resource *res;
> +	const char *str;
> +
> +	priv =3D devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv) {
> +		dev_err(&pdev->dev, "Failed to malloc priv.\n");
> +		return -ENOMEM;
> +	}
> +
> +	/* Obtain the tmu name from device tree file */
> +	if (of_property_read_string(pdev->dev.of_node, "thermal-name",
> +			&str) =3D=3D 0) {

it is common practice to use a variable to hold the error values.

> +		strlcpy(priv->name, str, sizeof(priv->name));
> +	} else {
> +		dev_err(&pdev->dev, "Failed to get thermal-name from DT.\n");
> +		return -EINVAL;
> +	}
> +
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	priv->base =3D devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(priv->base))
> +		return PTR_ERR(priv->base);
> +
> +	thermal =3D thermal_zone_device_register(priv->name, 0, 0, priv,
> +						&bcm_dev_ops, NULL, 0, 0);


No trips, no cooling.. constraint and logic is somewhere in userland?

> +	if (IS_ERR(thermal)) {
> +		dev_err(&pdev->dev,
> +			"Failed to register Broadcom thermal zone device.\n");
> +		return PTR_ERR(thermal);
> +	}
> +
> +	platform_set_drvdata(pdev, thermal);
> +
> +	dev_info(&pdev->dev, "Broadcom Thermal Monitor Initialized.\n");

Are you sure you want to be this wordy?
> +
> +	return 0;
> +}
> +
> +static int bcm_tmu_remove(struct platform_device *pdev)
> +{
> +	struct thermal_zone_device *broadcom_thermal =3D
> +		platform_get_drvdata(pdev);
> +
> +	thermal_zone_device_unregister(broadcom_thermal);
> +
> +	dev_info(&pdev->dev, "Broadcom Thermal Monitor Uninitialized.\n");

ditto

> +
> +	return 0;
> +}
> +
> +static struct platform_driver bcm_tmu_driver =3D {
> +	.driver =3D {
> +		.name =3D "bcm-thermal",
> +		.owner =3D THIS_MODULE,
> +		.of_match_table =3D bcm_tmu_match_table,
> +	},
> +	.probe =3D bcm_tmu_probe,
> +	.remove =3D bcm_tmu_remove,
> +};
> +
> +module_platform_driver(bcm_tmu_driver);
> +
> +MODULE_DESCRIPTION("Broadcom Thermal Driver");
> +MODULE_AUTHOR("Broadcom");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS("platform:bcm-thermal");
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--oCg4uePpK0Lc58KdRDUBsJr0hJqkjfOwx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlJbKUIACgkQCXcVR3XQvP2p5wD/UEMd8eQvNPiUzTK67IizV8Gm
AikGI+on7JTsmwA31aIA/RwLbVAxWlHF6TN09JrChj9QDXbDaKqDiFUWSkPHg3bk
=karx
-----END PGP SIGNATURE-----

--oCg4uePpK0Lc58KdRDUBsJr0hJqkjfOwx--
