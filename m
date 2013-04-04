Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933150Ab3DDHS4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 03:18:56 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33518 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933116Ab3DDHSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 03:18:54 -0400
Date: Thu, 4 Apr 2013 10:18:32 +0300
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Felipe Balbi <balbi@ti.com>, Vivek Gautam <gautamvivek1987@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vivek Gautam <gautam.vivek@samsung.com>, <linux-usb@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <sarah.a.sharp@linux.intel.com>, <rob.herring@calxeda.com>,
        <kgene.kim@samsung.com>, <dianders@chromium.org>, <t.figa@samsung.com>,
        <p.paneri@samsung.com>
Subject: Re: [PATCH v3 01/11] usb: phy: Add APIs for runtime power management
Message-ID: <20130404071832.GD30287@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130403141831.GJ14680@arwen.pp.htv.fi>
 <Pine.LNX.4.44L0.1304031410320.2027-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qGV0fN9tzfkG3CxV"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1304031410320.2027-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--qGV0fN9tzfkG3CxV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Apr 03, 2013 at 02:14:02PM -0400, Alan Stern wrote:
> > > Lets suppose DWC3 enables runtime_pm on USB 2 type phy,
> > > it will try to go into suspend state and thereby call runtime_suspend=
(), if any.
> > > And PHY will come to active state only when its consumer wakes it up,
> > > and this consumer is operational
> > > only when its related PHY is in fully functional state.
> > > So do we have a situation in which this PHY goes into low power state
> > > in its runtime_suspend(),
> > > resulting in non-detection of devices on further attach (since PHY is
> > > in low power state) ?
> > >=20
> > > Will the controller (like EHCI/OHCI) be functional now ?
> >=20
> > ehci/ohci need to cope with that by calling usb_phy_autopm_get_sync(),
> > right ? (so does DWC3 :-)
>=20
> Maybe you guys have already got this all figured out -- if so, feel=20
> free to ignore this email.
>=20
> Some subsystems handle this issue by calling pm_runtime_get_sync()=20
> before probing a driver and pm_runtime_put_sync() after unbinding the=20
> driver.  If the driver is runtime-PM-enabled, it then does its own=20
> put_sync near the end of its probe routine and get_sync in its release=20
> routine.

sounds a bit 'fishy' to me... So a separate entity would call
pm_runtime_get_sync(), even when we don't have registered dev_pm_ops,
then drivers need to check if runtime_pm is enabled and call
pm_runtime_put*() conditionally before returning from probe(). One
remove, we might have another issue: device is already runtime_suspended
(due to e.g. autosuspend) when module is removed, a call to
pm_runtime_put_sync() will be unbalanced. No ?

--=20
balbi

--qGV0fN9tzfkG3CxV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRXSlIAAoJEIaOsuA1yqRElv0P/12ZZ4vFPIEZF/x9oG/tkVWL
1K6LppqzBCuy8TTV+OuD1HAZWvXlVbJU/x+ZhVZVV5utclGhEVb8CqmhZAtZOTLY
AcFMWI12iQIv1qDl96Ex3I2J+JK285clj0o8v6HkSJ2IeFPypRl9LdLfsWywmy2T
gmjaSLaMG2J1CAYrEOsXuCab4APlfv4FGdYMeeGv1vsNmYYyGfG+Ytcq/TMcZQkA
eNedoN25cEN+VKphZRIv69lArt3CFI2ZjgYYfW+CPdyuJM2inx3WrcBxqrxTKpzZ
bULR7qy0zDvP6A2C6x+d+cMP43pe6vxUEBAIr4IplblV3h2sM3IJEXDUUeWrfM0C
1Rb5mBjtU7ZVQeDZNMsUQDrVjFffrhhk0Dnmb18XQLEROA+ztp7eP8MlS2ckg1cY
FCz/MLI4Kyk1W22ago5mYBy1objBPC91xe425vvlrgZfuS9sUXdSvU0djEzvo5Nw
XXrV8YFlEABIszdwlj8DHh2ucM7nGR/Y5ulQHrnlK51oGr5bFGU7qTl4XQ5Lwl8B
0guk30k/cimeZUuYT2xgjNiOz3JTOGbrHSVmKSKXpkhL6aqd6j0Z+Z8Wszj+XSWW
uoE5rZnvNW8rxL1Q+EfJhrD3BwlQOww2Peu12QcTLFDqusM6vvFcBWgU32VSzBlr
WusyCHMGnUqYqyFAecUY
=xC+b
-----END PGP SIGNATURE-----

--qGV0fN9tzfkG3CxV--
