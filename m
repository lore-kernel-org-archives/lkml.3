Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbaA1Sam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 13:30:42 -0500
Received: from sauhun.de ([89.238.76.85]:45991 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755047AbaA1Sal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 13:30:41 -0500
Date: Tue, 28 Jan 2014 19:30:35 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: "xinhui.pan" <xinhuix.pan@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        mika.westerberg@linux.intel.com, andriy.shevchenko@linux.intel.com,
        yanmin_zhang@linux.intel.com, bo.he@intel.com
Subject: Re: [PATCH] i2c-designware-pcidrv: fix the incorrect return of idle
 callback
Message-ID: <20140128183035.GC20789@katana>
References: <52E744AC.2050606@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eRtJSFbw+EEWtPj3"
Content-Disposition: inline
In-Reply-To: <52E744AC.2050606@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eRtJSFbw+EEWtPj3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 28, 2014 at 01:48:28PM +0800, xinhui.pan wrote:
> From: "xinhui.pan" <xinhuix.pan@intel.com>
>=20
> i2c_dw_pci_runtime_idle should return -EBUSY rather than zero if it do su=
ccess.

I don't understand...

> Otherwise rpm_idle will call pm_suspend again and that may cause pm_sched=
ule_suspend delay invalidate.
> =09
> Signed-off-by: bo.he <bo.he@intel.com>
> Signed-off-by: xinhui.pan <xinhuix.pan@intel.com>
> ---
>  drivers/i2c/busses/i2c-designware-pcidrv.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/bus=
ses/i2c-designware-pcidrv.c
> index f6ed06c..96e81f6 100644
> --- a/drivers/i2c/busses/i2c-designware-pcidrv.c
> +++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
> @@ -190,8 +190,8 @@ static int i2c_dw_pci_runtime_idle(struct device *dev)
>  	int err =3D pm_schedule_suspend(dev, 500);
>  	dev_dbg(dev, "runtime_idle called\n");
> =20
> -	if (err !=3D 0)
> -		return 0;
> +	if (err)
> +		return err;
>  	return -EBUSY;

=2E.. it does return EBUSY when pm_schedule_suspend() succeeds? It only
returns 0 if it does not succeed (for which I don't know if this is an
apropriate behaviour). Mika?

>  }
> =20
> --=20
> 1.7.9.5

--eRtJSFbw+EEWtPj3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJS5/dLAAoJEBQN5MwUoCm2az8QAJtnTG+xdMODTFr0NnxbpXY/
BAFEmeZvUe3Mw2/NmLI6Tu6KPU9g1cSdHqNCBcjGW78rgVwGJ0KSg2zr/CrvBwXy
bJ8js6hRZmB0CQEPFvgPClvbxy5rTkzhNdXU04hqoS4DFERf/TllUiic92Z81tgx
xqtLqGyomcz3dlVXs3xCAfObqgPKSfMV3NNL6wMcjD1gUuE9LTB+/aLejWtxHVbH
vl4MgjM6vY+EBXMKeYIxit7bPZjyDUgCVgk9x+RpECxf0MqIdZZnTgksv5BE7/PR
gyrqMkmRL55nN7XknwG7LHmFirJt/Z/td8MDgpUq425lMOWEcE21w76Zk8Ntwq0b
O02DIW+znbW0v2GM5kTkM5dWcDVZjZw2hrqXgbK0G+L72b+F9A9TGZlUhUsXApR/
qi3x8A/5lbt1xNwcWrP5SQFCsbWKSaSpQ0OfodLogpISuBwBiym4lH6EVMCWeWlD
fc3s6byZ0dmINv/mraurF9DQd4IpbhiTMzQLOXQZRiw5uTawvm3OaHja0g9irwFT
dVpDXsnelzxpiE9l6mqXFblUVfV9G23/qHfXUAeyzfxqw0OJoVzNXd6JoNcuzW57
sxQ/PAo2icqSdYkUbyppRNUqurLPugl1YgVL3I6qv3fXcZXEdBzTgcJx2YqVrweM
55uoD1JDdQwlVC4RknCy
=2Dno
-----END PGP SIGNATURE-----

--eRtJSFbw+EEWtPj3--
