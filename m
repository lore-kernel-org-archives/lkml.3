Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbaJBLUp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 07:20:45 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58475 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbaJBLUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 07:20:43 -0400
Date: Thu, 2 Oct 2014 12:20:11 +0100
From: Mark Brown <broonie@kernel.org>
To: atull@opensource.altera.com
Cc: linux@roeck-us.net, jdelvare@suse.de, lm-sensors@lm-sensors.org,
        lgirdwood@gmail.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, delicious.quinoa@gmail.com,
        dinguyen@opensource.altera.com, yvanderv@opensource.altera.com
Message-ID: <20141002112011.GS4273@sirena.org.uk>
References: <1412190349-16343-1-git-send-email-atull@opensource.altera.com>
 <1412190349-16343-4-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+sObS8/rhx1YpqEF"
Content-Disposition: inline
In-Reply-To: <1412190349-16343-4-git-send-email-atull@opensource.altera.com>
X-Cookie: So you're back... about time...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 3/4] pmbus: add regulator support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+sObS8/rhx1YpqEF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 01, 2014 at 02:05:49PM -0500, atull@opensource.altera.com wrote:
> From: Alan Tull <atull@opensource.altera.com>
>=20
> Add support for simple on/off control of each channel.

This is basically fine but the regulator API has moved on a bit with the
DT handling over the time you've been working on this.

> Signed-off-by: Alan Tull <atull@opensource.altera.com>
>=20
> v2: Remove '#include <linux/regulator/machine.h>'
>     Only one regulator per pmbus device

Put this after the --- as covered in SubmittingPatches.

> +static int _pmbus_regulator_on_off(struct regulator_dev *rdev, bool enab=
le)
> +{
> +	struct device *dev =3D rdev_get_dev(rdev);
> +	struct i2c_client *client =3D to_i2c_client(dev->parent);
> +	u8 page =3D rdev_get_id(rdev);
> +
> +	return pmbus_update_byte_data(client, page, PMBUS_OPERATION,
> +				      PB_OPERATION_CONTROL_ON,
> +				      enable ? PB_OPERATION_CONTROL_ON : 0);
> +}
> +
> +static int pmbus_regulator_enable(struct regulator_dev *rdev)
> +{
> +	return _pmbus_regulator_on_off(rdev, 1);
> +}

I'm not sure factoring out the code actually won much here.

> +	np_regulators =3D of_get_child_by_name(dev->of_node, "regulators");
> +	if (!np_regulators)
> +		return 0;
> +
> +	ret =3D of_regulator_match(dev, np_regulators, info->reg_matches,
> +				 info->num_regulators);
> +	of_node_put(np_regulators);

We now have helpers in the regulator core for this - set of_match and
regulators_node in the regulator descriptor and the core will resolve
this stuff for you and...

> +		if (pdata && pdata->reg_init_data) {
> +			config.init_data =3D &pdata->reg_init_data[i];
> +		} else {
> +			config.init_data =3D info->reg_matches[i].init_data;
> +			config.of_node =3D info->reg_matches[i].of_node;
> +		}

=2E..you can just drop the else case (and check for reg_init_data) here.

--+sObS8/rhx1YpqEF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJULTTqAAoJECTWi3JdVIfQhnUH/AwUcrdQDUulP3HyBFlmY8cW
tUkKjnLlRHGaCcCZMBkBMxDCPWXlGr+e266u5u9u1t/u/TfWfxS8T69H7a1XnCg7
4bEyRMpKgcG5S25xRX3ZicOWpQrELpGiHTf0FCiNnrpbIrxsK3yHiSt6YKRki1pf
XRTcCak9jPyQFHg9NjL18YHJknEjT1qNZYk25B4DliLq9viIS4WNzP90GdEBkgPX
zp2lLw0hMmz4MH9TQCOyW1wdulIdyoMgLmdKnYEFesy9ZJJnpM2eV/ZjXu/RniNg
rLJuBRiFEHxc+Xhdg0qA6O4yxm/KqltVDaEZSUBrjHBYYmJT+BnJxWoIxPi3sM8=
=s8xW
-----END PGP SIGNATURE-----

--+sObS8/rhx1YpqEF--
