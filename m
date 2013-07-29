Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558Ab3G2Ryz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 13:54:55 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51784 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758538Ab3G2Ryx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 13:54:53 -0400
Date: Mon, 29 Jul 2013 20:54:13 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <balbi@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <eballetbo@gmail.com>, <javier@dowhile0.org>,
        <gregkh@linuxfoundation.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 2/2] arm: omap: remove *.auto* from device names given in
 usb_bind_phy
Message-ID: <20130729175413.GC4964@radagast>
Reply-To: <balbi@ti.com>
References: <1374829418-27503-1-git-send-email-kishon@ti.com>
 <1374829418-27503-3-git-send-email-kishon@ti.com>
 <20130729150638.GD3063@radagast>
 <51F68A56.8060805@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RhUH2Ysw6aD5utA4"
Content-Disposition: inline
In-Reply-To: <51F68A56.8060805@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--RhUH2Ysw6aD5utA4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 29, 2013 at 08:59:26PM +0530, Kishon Vijay Abraham I wrote:
> >> Previously MUSB wrapper (OMAP) device used PLATFORM_DEVID_AUTO while c=
reating
> >> MUSB core device. So in usb_bind_phy (binds the controller with the PH=
Y), the
> >> device name of the controller had *.auto* in it. Since with using
> >> PLATFORM_DEVID_AUTO, there is no way to know the exact device name in =
advance,
> >> the data given in usb_bind_phy became obsolete and usb_get_phy was fai=
ling.
> >> So MUSB wrapper was modified not to use PLATFORM_DEVID_AUTO. Correspon=
ding
> >> change is done in board file here.
> >>
> >> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> >> ---
> >>  arch/arm/mach-omap2/board-2430sdp.c          |    2 +-
> >>  arch/arm/mach-omap2/board-3430sdp.c          |    2 +-
> >>  arch/arm/mach-omap2/board-cm-t35.c           |    2 +-
> >>  arch/arm/mach-omap2/board-devkit8000.c       |    2 +-
> >>  arch/arm/mach-omap2/board-igep0020.c         |    2 +-
> >>  arch/arm/mach-omap2/board-ldp.c              |    2 +-
> >>  arch/arm/mach-omap2/board-omap3beagle.c      |    2 +-
> >>  arch/arm/mach-omap2/board-omap3evm.c         |    2 +-
> >>  arch/arm/mach-omap2/board-omap3logic.c       |    2 +-
> >>  arch/arm/mach-omap2/board-omap3pandora.c     |    2 +-
> >>  arch/arm/mach-omap2/board-omap3stalker.c     |    2 +-
> >>  arch/arm/mach-omap2/board-omap3touchbook.c   |    2 +-
> >>  arch/arm/mach-omap2/board-overo.c            |    2 +-
> >>  arch/arm/mach-omap2/board-rm680.c            |    2 +-
> >>  arch/arm/mach-omap2/board-rx51.c             |    2 +-
> >>  arch/arm/mach-omap2/board-zoom-peripherals.c |    2 +-
> >>  16 files changed, 16 insertions(+), 16 deletions(-)
> >>
> >> diff --git a/arch/arm/mach-omap2/board-2430sdp.c b/arch/arm/mach-omap2=
/board-2430sdp.c
> >> index 244d8a5..17bb076 100644
> >> --- a/arch/arm/mach-omap2/board-2430sdp.c
> >> +++ b/arch/arm/mach-omap2/board-2430sdp.c
> >> @@ -233,7 +233,7 @@ static void __init omap_2430sdp_init(void)
> >>  	omap_hsmmc_init(mmc);
> >> =20
> >>  	omap_mux_init_signal("usb0hs_stp", OMAP_PULL_ENA | OMAP_PULL_UP);
> >> -	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
> >> +	usb_bind_phy("musb-hdrc.0", 0, "twl4030_usb");
> >=20
> > how about moving usb_bind_phy() calls to omap2430.c ?
> >=20
> > diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
> > index f44e8b5..b6abc1a 100644
> > --- a/drivers/usb/musb/omap2430.c
> > +++ b/drivers/usb/musb/omap2430.c
> > @@ -544,6 +544,9 @@ static int omap2430_probe(struct platform_device *p=
dev)
> > =20
> >  		pdata->board_data	=3D data;
> >  		pdata->config		=3D config;
> > +	} else {
> > +		/* bind the PHY */
> > +		usb_bind_phy(dev_name(&musb->dev), 0, "twl4030_usb");
>=20
> This looks like a hack IMHO to workaround the usb phy library. otherwise =
it is
> similar to get_phy_by_name.

actually, this is a workaround to the fact that we're not creating all
platform_devices in arch/arm/mach-omap2/ :-)

If we had the musb allocation there, we could easily handle
usb_bind_phy()

> > so that's temporary. It might be better than to reintroduce the IDR in
> > musb_core.c.
>=20
> that=E2=80=99s needed for generic phy framework anyway :-s

right, but generic phy framework can handle everything just fine, the
only problem is that names are changing.

--=20
balbi

--RhUH2Ysw6aD5utA4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR9qxFAAoJEIaOsuA1yqREUNQP/Ryi9cCIBBhNivPwQKtifmVC
Apgp/VKOVUgmmaeO/HBFnpJu08rN/OucgarvM0kCLZfn8KLb2phRsCYiLH9gIieX
iHmf3X/iWuM1XQPLX5P7xX9GAAYL6TmSUQLp8FaFolAW5NX5k8U8FVxafv84+kmn
My/I21L1GezLgk8za2caefscekToMupQvOjR8laB/CS8QlENQpy8cUGoiyg9gseD
3U+o2XP8ET+ZsRI9gcFsdSmKfZTEvP4q3EzWLmYGI20jP3TzrxWz2XKBRxi1u+cY
svv0zm7m88/L0TFp8SVx4t390mNLSODLljPrBYfyGTP+B3oBS1B+8xkjQHAF89k+
z4yUa/OxnVvKn2GtyBcmO+EQuYJDhGG3jJPn/0AnqrdQItmgD0QOw6hq5uWchxhL
duuKIjwroWbfmmlGNl1OL+PeLEVKu25LOCKk2oIKuO9cpxAkVC4yknqBtvkLSH/p
GA4SPT//e6u7g3DEJV6bcZkSBeKf85ep+NK1U4pz1Blw+v6uYIkSgKyUpcclxmyc
O5bNAQPyI3ZxNMJ/G7S+WVhGcpXKEDg4Vvg3ds0YBO6atbZlckZ35H1dWpXn7u2j
/mrkF351wcugFjAlADJGUd1KIf1Qr6u0+8EQgsFpbW4tEIyFxFG7RyJa/Lf+tdXW
lYZkNqn7KJWnzb1pAGeP
=+6DW
-----END PGP SIGNATURE-----

--RhUH2Ysw6aD5utA4--
