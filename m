Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152AbbAWQSr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:18:47 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33803 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755718AbbAWQSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:18:42 -0500
Date: Fri, 23 Jan 2015 10:18:38 -0600
From: Felipe Balbi <balbi@ti.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: Felipe Balbi <balbi@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Baolu Lu <baolu.lu@linux.intel.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] phy: ulpi: add driver for TI TUSB1210
Message-ID: <20150123161838.GE8585@saruman.tx.rr.com>
Reply-To: <balbi@ti.com>
References: <1421745502-169447-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1421745502-169447-4-git-send-email-heikki.krogerus@linux.intel.com>
 <20150120154539.GB8988@saruman>
 <20150121091749.GB22716@kuha.fi.intel.com>
 <20150122204925.GF22288@saruman.tx.rr.com>
 <20150123081241.GB30522@kuha.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tMbDGjvJuJijemkf"
Content-Disposition: inline
In-Reply-To: <20150123081241.GB30522@kuha.fi.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--tMbDGjvJuJijemkf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 23, 2015 at 10:12:41AM +0200, Heikki Krogerus wrote:
> Hi,
>=20
> On Thu, Jan 22, 2015 at 02:49:25PM -0600, Felipe Balbi wrote:
> > On Wed, Jan 21, 2015 at 11:17:49AM +0200, Heikki Krogerus wrote:
> > > > > +	/* Store initial eye diagram optimisation value */
> > > > > +	ret =3D ulpi_read(ulpi, ULPI_EXT_VENDOR_SPECIFIC);
> > > >=20
> > > > do they *all* use this register for eye diagram optimization or is =
this
> > > > something that Intel decided to do ?
> > > >=20
> > > > (sorry, don't know much about tusb1210 other than it sucks like hel=
l :-)
> > >=20
> > > All I know that somebody needs to save the value. The ones using this
> > > PHY who don't need to save it can most likely live without the driver.
> >=20
> > right, but what I mean is: is it mandatory that Eye diagram
> > configuration be stored in *this* register? Or is it more like a scratch
> > register which Intel just happens to be using for Eye diagram data ?
>=20
> The eye diagram tuning is in that register. Here's the spec:
> http://www.ti.com/lit/ds/symlink/tusb1210.pdf
>=20
> I'll add definition for the register (which is colourfully named
> "VENDOR_SPECIFIC2").

alright, thanks.

> > > > > +	if (ret < 0)
> > > > > +		return ret;
> > > > > +
> > > > > +	tusb->ctx[0] =3D ret;
> > > > > +
> > > > > +	tusb->phy =3D ulpi_phy_create(ulpi, &phy_ops);
> > > > > +	if (IS_ERR(tusb->phy))
> > > > > +		return PTR_ERR(tusb->phy);
> > > > > +
> > > > > +	tusb->ulpi =3D ulpi;
> > > > > +
> > > > > +	phy_set_drvdata(tusb->phy, tusb);
> > > > > +	dev_set_drvdata(&ulpi->dev, tusb);
> > > > > +	return 0;
> > > > > +}
> > > > > +
> > > > > +static void tusb1210_remove(struct ulpi *ulpi)
> > > > > +{
> > > > > +	struct tusb1210 *tusb =3D dev_get_drvdata(&ulpi->dev);
> > > >=20
> > > > completely unrelated to $subject, but we might want to have a
> > > > ulpi_{set,get}_drvdata() at some point.
> > >=20
> > > Makes sense.
> > >=20
> > > > In fact, we might decide to add an entire ULPI bus, eventually, tho=
ugh
> > > > I'm still considering if there's any benefit to that.
> > >=20
> > > I don't think I understand this comment? ULPI bus is what I'm
> > > introducing in this set (the first patch in it)?
> >=20
> > I mean introducing a real struct bus ulpi_bus_type :-) With match,
> > probe, remove, etc.
>=20
> I'm already doing that. Please check the first patch in this set:
> "phy: add bus for USB ULPI PHYs".

yeah, sorry about that.

--=20
balbi

--tMbDGjvJuJijemkf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUwnReAAoJEIaOsuA1yqREGIUQAIiWUi3N54pUgm8TUdmRL+R0
OH+GUweb47Ee9Ni/utOedhaJMD9EEzILk51aZHcHjse/Ax0LCS0IlKXjm6M5PocD
sHOS1Y/NRBFaitVTBCJGi/Ur/ZKNaVslskW5kQtymGudy0TyN38elymPq12dKyGc
qMDnOyiLKKuXn3dZ5oBJdLI3yw5SXh2A0C0VAZx+1rYONLV399qZ0PePvPbQu/j6
dasx+zgiDtnlXZ4dWNu5BCfHOSJDiWx3sd5QtD1GvAXnoAEjsr01XXfOyvl/k0qe
YIK3ct3sWXdF8Bx178of2M26sLkHWiZC7lTETNmgZRsucDiP8c0C3LxjBEwSEbvP
4i+PzRddIC0MTqWlekP4plVDQE8dLQbmzzP6Mfh4x0YJnUyPBRXYyxKIO6N7spdC
lZP6DM/M7C0S4/bQUO/JxyXhTTX8H+CwGnt9bXvCsn7sYo3g+mCprEn9dsAno2Hr
+jbr2Y7eCYcxtvRirsE5S3S6VnxE13bh+tZ/3/X0Ewx6APq00wI4jy6xbvitRmaS
Lf7o2RcmvRfi2hsWYcB5oo3IJuhMj9P/o7X5i6UbhJUZSAMFf4PeMNqZ3/XUeo3L
Jbg9s+eVpa9Owwolq4AdSJehlFe8iT24/sIILWR6BVILnl+DacnyKBaIiZbNpJk3
XoNRfUOONQOGuvBD9Z0f
=B7r3
-----END PGP SIGNATURE-----

--tMbDGjvJuJijemkf--
