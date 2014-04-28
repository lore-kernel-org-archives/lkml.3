Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbaD1JEa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 05:04:30 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47561 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446AbaD1JEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 05:04:24 -0400
Date: Mon, 28 Apr 2014 10:03:45 +0100
From: Mark Brown <broonie@kernel.org>
To: Keerthy <j-keerthy@ti.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        sameo@linux.intel.com, lee.jones@linaro.org, grant.likely@linaro.org,
        robh+dt@kernel.org, lgirdwood@gmail.com
Message-ID: <20140428090345.GD15125@sirena.org.uk>
References: <1398662906-4398-1-git-send-email-j-keerthy@ti.com>
 <1398662906-4398-3-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xB0nW4MQa6jZONgY"
Content-Disposition: inline
In-Reply-To: <1398662906-4398-3-git-send-email-j-keerthy@ti.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.197.120.38
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] Regulators: TPS65917: Add Regulator driver for
 TPS65917 PMIC
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xB0nW4MQa6jZONgY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2014 at 10:58:26AM +0530, Keerthy wrote:

> index 6a79328..5ddb220 100644
> --- a/drivers/regulator/Kconfig
> +++ b/drivers/regulator/Kconfig
> @@ -384,6 +384,18 @@ config REGULATOR_PALMAS
>  	  on the muxing. This is handled automatically in the driver by
>  	  reading the mux info from OTP.
> =20
> +config REGULATOR_TPS65917
> +	tristate "TI TPS65917 PMIC Regulators"
> +	depends on MFD_TPS65917

Please keep the Kconfig and Makefile sorted.

> +static const struct regs_info tps65917_regs_info[] =3D {
> +	{
> +		.name		=3D "SMPS1",
> +		.sname		=3D "smps1-in",
> +		.vsel_addr	=3D TPS65917_SMPS1_VOLTAGE,
> +		.ctrl_addr	=3D TPS65917_SMPS1_CTRL,
> +		.sleep_id	=3D TPS65917_EXTERNAL_REQSTR_ID_SMPS1,
> +	},

> +static int tps65917_is_enabled_smps(struct regulator_dev *dev)
> +{
> +	struct tps65917_pmic *pmic =3D rdev_get_drvdata(dev);
> +	int id =3D rdev_get_id(dev);
> +	unsigned int reg;
> +
> +	tps65917_smps_read(pmic->tps65917,
> +			   tps65917_regs_info[id].ctrl_addr, &reg);
> +
> +	reg &=3D TPS65917_SMPS1_CTRL_STATUS_MASK;
> +	reg >>=3D TPS65917_SMPS1_CTRL_STATUS_SHIFT;
> +
> +	return !!(reg);
> +}

A lot of these functions look like they could be implemented using the
standard helpers rather than open coded - the helpers now support
multi-bit enable fields.

> +	if (selector =3D=3D 0)
> +		return 0;
> +	else if (selector < 6)
> +		return 500000 * mult;
> +	else
> +		/* Voltage is linear mapping starting from selector 6,
> +		 * volt =3D (0.49V + ((selector - 5) * 0.01V)) * RANGE
> +		 * RANGE is either x1 or x2
> +		 */
> +		return (490000 + ((selector - 5) * 10000)) * mult;
> +}

This looks like the driver could just use linear ranges.

> +static struct of_device_id of_tps65917_match_tbl[] =3D {
> +	{ .compatible =3D "ti,tps65917-pmic", },
> +};

Missing null entry at the end of the table here.

--xB0nW4MQa6jZONgY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTXhluAAoJELSic+t+oim9I7oP/2pUPLf/OOqO32ZbQQrrR+3u
BH13w5qj54pULhI4IEOumANTyGRicGTiprpO/VHrtk4ql6dPXbST4kQtJPDvAScs
Q5SS7fSt0gv8McdtKx4XUXTicOTKK/gOvWrHBYGdGXTBNiM9fit8oDF2ULjrtIz3
nrGXS8dX/hfmKyYreta5diKR7Yi/fBU4Wj6iqhUlHNdzn4Ej7tfjTZicuHLp2yO3
gqcvOszkUfaKdC4PxpJQlyHMEIh1ZkYCRV6bd004CcuIO1s0oEEaguI7F5hOX+IN
lP/Tm6hKfaFvCEOTNW2irKMcSIIHgelfetWPxlyaolQ4qITTTFGC0K4cr6JIpGOi
j4QRsj4KabjaURVc+lGlZsz/jvTOBew5gBI5CN0azmtxmIRdyEGGRilESisJh4OR
1nbO6Xp+UEdeY/iUTEz8QllUYN2errNTGpWZMyKZvBT8zzkBcm2zwGxkouCXBwcA
HXvvMm+yf2i7rs+lQ8mM2oCsi+U+2hXFcwRR+wTMPD4opcif9R7jmm+SsSPdnuCq
92+XGlxPZUGLZwznTooSveERAj/LW39W5iKSWQYXAWcDz8tuPjcW4+l6ltWRdhxG
qsKJnrKUMbFxg+I7o3zoF00i7kIqKX99ERAXDB0QhqaioO0Pa2pGhvkqP40vz/+E
TDgcY5dvzoTaWsN3KuSK
=4Tls
-----END PGP SIGNATURE-----

--xB0nW4MQa6jZONgY--
