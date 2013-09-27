Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750919Ab3I0CnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 22:43:18 -0400
Received: from sauhun.de ([89.238.76.85]:54735 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722Ab3I0CnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 22:43:17 -0400
Date: Fri, 27 Sep 2013 04:43:13 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Vincent =?iso-8859-15?Q?Stehl=E9?= <vincent.stehle@laposte.net>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-designware: define i2c_dw_pci_runtime_idle only with
 runtime pm
Message-ID: <20130927024313.GB3159@katana>
References: <1380234243-23787-1-git-send-email-vincent.stehle@laposte.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8GpibOaaTibBMecb"
Content-Disposition: inline
In-Reply-To: <1380234243-23787-1-git-send-email-vincent.stehle@laposte.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8GpibOaaTibBMecb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 27, 2013 at 12:24:03AM +0200, Vincent Stehl=C3=A9 wrote:
> Make sure i2c_dw_pci_runtime_idle() is defined only when actually used, w=
hen
> CONFIG_PM_RUNTIME is defined.
>=20
> This fixes the following compilation warning:
>=20
>  drivers/i2c/busses/i2c-designware-pcidrv.c:188:12: warning: =E2=80=98i2c=
_dw_pci_runtime_idle=E2=80=99 defined but not used [-Wunused-function]
>=20
> Signed-off-by: Vincent Stehl=C3=A9 <vincent.stehle@laposte.net>
> Cc: Wolfram Sang <wsa@the-dreams.de>

I wonder if this fix is complete? Mika?

> ---
>  drivers/i2c/busses/i2c-designware-pcidrv.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/bus=
ses/i2c-designware-pcidrv.c
> index f6ed06c..2b5d3a6 100644
> --- a/drivers/i2c/busses/i2c-designware-pcidrv.c
> +++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
> @@ -185,6 +185,7 @@ static int i2c_dw_pci_resume(struct device *dev)
>  	return 0;
>  }
> =20
> +#ifdef CONFIG_PM_RUNTIME
>  static int i2c_dw_pci_runtime_idle(struct device *dev)
>  {
>  	int err =3D pm_schedule_suspend(dev, 500);
> @@ -194,6 +195,7 @@ static int i2c_dw_pci_runtime_idle(struct device *dev)
>  		return 0;
>  	return -EBUSY;
>  }
> +#endif
> =20
>  static const struct dev_pm_ops i2c_dw_pm_ops =3D {

Shouldn't this be using UNIVERSAL_DEV_PM_OPS with the suspend and resume
function #ifdeffed by CONFIG_PM_SLEEP?

>  	.resume         =3D i2c_dw_pci_resume,
> --=20
> 1.8.4.rc3
>=20

--8GpibOaaTibBMecb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSRPDBAAoJEBQN5MwUoCm2dyEP/3fZKZNT2R4+dDONc0Sj1VVS
aZaJ8MpVjXQYMkp9W3Q1LsRzy/3o5uZrUOVQRE3s8tF3WHGk1JNzxSJfZUMfaqmm
uN1Wd2yTxDLkb+fRkTC6AAYeIECGKxdVmesQ8ZwDlT/aZr7JQV1DLufH/cYM2Xe7
QmAG/L0pWl97gP3FFpxzrd2yzKMZZQFqfpopUR1lmbFdktCBKY1H38cSNeZ13oAu
p9r16xVbO9I1AK7FR3GauG6wbNfmpBJ5T9wRkxnBxvxjxy4PJ/Hv/ps80UrdO/LE
VTnuII9HSZ1IsT6U5HLA1cZU0tLIwc439WTJcpGG6V/9DgYbE0ypSIjLXPrkUJQ9
g6W8ZvbY/n3z2QU/K8xA67UqADFK4iU7euY21+73mDupjDJ+9VQWSJYE+Zri0EKS
qvfv9c1h0QjlXGutemRmgxSC2M6EFCerYUYHP2YV1ZQPYlHt6fy9TjxWIkCCtP3d
AeSDGiqKOB8mQBZf5utTnNGMILiVeW4VQDYBqTj6piZ8Cram/69UnfiIbyEwmrUh
XzAycRDOjObmGtJZrdq6FhaE+ks3abnpqYh2YTWSYU8agAo6mX21BV+DOxzXzrb7
yY51cEt4xgewFPIFnIHDxrw92vNFO9aoHIZ2GQe6rIZU7FGcOl1k0+6E76rOvRsx
ZPX/FcuseLUs7U1B0Qvg
=VmUk
-----END PGP SIGNATURE-----

--8GpibOaaTibBMecb--
