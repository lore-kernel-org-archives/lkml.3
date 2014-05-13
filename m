Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbaEMTw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 15:52:56 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38154 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbaEMTwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 15:52:49 -0400
Date: Tue, 13 May 2014 14:52:16 -0500
From: Felipe Balbi <balbi@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 4/8] usb: phy: fix isp1301-omap dependency on tps65010
Message-ID: <20140513195215.GB1151@saruman.home>
Reply-To: <balbi@ti.com>
References: <1399557141-1346645-1-git-send-email-arnd@arndb.de>
 <1399557141-1346645-5-git-send-email-arnd@arndb.de>
 <20140513152631.GI1151@saruman.home>
 <7581425.j2FgrCi2P6@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mZSo2Zk6iB5ZAp9g"
Content-Disposition: inline
In-Reply-To: <7581425.j2FgrCi2P6@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--mZSo2Zk6iB5ZAp9g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, May 13, 2014 at 09:48:27PM +0200, Arnd Bergmann wrote:
> On Tuesday 13 May 2014 10:26:31 Felipe Balbi wrote:
> > On Thu, May 08, 2014 at 03:52:17PM +0200, Arnd Bergmann wrote:
> > > The isp1301-omap driver cannot be built-in if the tps65010 driver
> > > is a module, otherwise we get a link error from the reference to
> > > the tps65010_set_vbus_draw function.
> > >=20
> > > There is already a hack in the driver to work around the problem
> > > of tps65010 being not available at all. This patch extends that
> > > hack to ensure that the real tps65010_set_vbus_draw() function
> > > is only called when it's avaiable.
> > >=20
> > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > > Cc: linux-omap@vger.kernel.org
> > > ---
> > >  drivers/usb/phy/phy-isp1301-omap.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >=20
> > > diff --git a/drivers/usb/phy/phy-isp1301-omap.c b/drivers/usb/phy/phy=
-isp1301-omap.c
> > > index 6e146d7..35a0dd2 100644
> > > --- a/drivers/usb/phy/phy-isp1301-omap.c
> > > +++ b/drivers/usb/phy/phy-isp1301-omap.c
> > > @@ -94,7 +94,7 @@ struct isp1301 {
> > > =20
> > >  #if defined(CONFIG_MACH_OMAP_H2) || defined(CONFIG_MACH_OMAP_H3)
> > > =20
> > > -#if  defined(CONFIG_TPS65010) || defined(CONFIG_TPS65010_MODULE)
> > > +#if  defined(CONFIG_TPS65010) || (defined(CONFIG_TPS65010_MODULE) &&=
 defined(MODULE))
> >=20
> > nack, I would rather see a real fix, possibly also fixing the original
> > hack.
>=20
> Any suggestion how?

well, that driver shouldn't depend on a particular PMIC. It should use
regulator framework to enable and disable vbus regulator, to start with.

In fact, isp1301-omap.c shouldn't even exist. isp1301 is a generic
device and not OMAP-specific.

cheers

--=20
balbi

--mZSo2Zk6iB5ZAp9g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTcnfvAAoJEIaOsuA1yqREq7YQAK+4606C+29sc+6U4Tf/at5v
lIlWb3UmLi673HUzhtCR6Zku0eTE/GeYE6E7aWY29l6Q+kB0KAgTmxnKGLxqRIUe
Jw7+mU8HvolTCWWrbSyMxOkdzpwl6wQEr4t7p5enl/VBMdMvsENjmzRUUgHVjewb
pP0heIAG3i9ASvVHW6dzTWXWlMSNqKAjVK27bGVbvbOMshmoX87FaI9RyU9SJ0Ss
zA6ux/YuWF/FwTuKYpK1UUs/gqLDgg0P91/WXCuTOg0xeLNQ1Mb89XqdMI/IjChf
85C3Gg+jFatWqHtw4tfZawA5c3+GOVEdZNEjqgO7l74eTx5FKv1Nz3ubwOywlt0f
PbCY8LPJ83GLI0twTEqQwC04r18iAGFtjLqz6cHJJ1bgYXVo3Pg+ouU6hHTR7h/d
cEdifgALvzL+Gbe9rOVogjQ4OkrPjwkkU9IoXQw4WGo6shaOB9i73VDTIfnk8kog
axmsUTUUIUkPmE0MyA8uT4SLbDyYwcr8hyGqdcq0l+AK0IZaAXdFTVlIu+IqhMTI
bpyUzBY6Teaw140WN9AC3lECm9+bNDPeYyuQXfYFp88EkRorMtUyFg4QHKwnJCTz
skQQoFIvnO2mQBEB/HF/h0NsanzGrKLw9HFHze7CbChbJXbUEmRxL0mRJFwUuHmy
JzT0duO2Uopv37YP2xfH
=qLJg
-----END PGP SIGNATURE-----

--mZSo2Zk6iB5ZAp9g--
