Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540Ab3G3G3X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 02:29:23 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57044 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754723Ab3G3G3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 02:29:21 -0400
Date: Tue, 30 Jul 2013 09:28:44 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <balbi@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <eballetbo@gmail.com>, <javier@dowhile0.org>,
        <gregkh@linuxfoundation.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 2/2] arm: omap: remove *.auto* from device names given in
 usb_bind_phy
Message-ID: <20130730062844.GH9155@radagast>
Reply-To: <balbi@ti.com>
References: <1374829418-27503-1-git-send-email-kishon@ti.com>
 <1374829418-27503-3-git-send-email-kishon@ti.com>
 <20130729150638.GD3063@radagast>
 <51F68A56.8060805@ti.com>
 <20130729175413.GC4964@radagast>
 <51F74BC8.7020903@ti.com>
 <20130730060134.GD9155@radagast>
 <51F7590B.4020705@ti.com>
 <20130730061830.GE9155@radagast>
 <51F75C40.4060406@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WRT3RXLOp/bBMgTI"
Content-Disposition: inline
In-Reply-To: <51F75C40.4060406@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--WRT3RXLOp/bBMgTI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 30, 2013 at 11:55:04AM +0530, Kishon Vijay Abraham I wrote:
> > On Tue, Jul 30, 2013 at 11:41:23AM +0530, Kishon Vijay Abraham I wrote:
> >>>>>>>> diff --git a/arch/arm/mach-omap2/board-2430sdp.c b/arch/arm/mach=
-omap2/board-2430sdp.c
> >>>>>>>> index 244d8a5..17bb076 100644
> >>>>>>>> --- a/arch/arm/mach-omap2/board-2430sdp.c
> >>>>>>>> +++ b/arch/arm/mach-omap2/board-2430sdp.c
> >>>>>>>> @@ -233,7 +233,7 @@ static void __init omap_2430sdp_init(void)
> >>>>>>>>  	omap_hsmmc_init(mmc);
> >>>>>>>> =20
> >>>>>>>>  	omap_mux_init_signal("usb0hs_stp", OMAP_PULL_ENA | OMAP_PULL_U=
P);
> >>>>>>>> -	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
> >>>>>>>> +	usb_bind_phy("musb-hdrc.0", 0, "twl4030_usb");
> >>>>>>>
> >>>>>>> how about moving usb_bind_phy() calls to omap2430.c ?
> >>>>>>>
> >>>>>>> diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2=
430.c
> >>>>>>> index f44e8b5..b6abc1a 100644
> >>>>>>> --- a/drivers/usb/musb/omap2430.c
> >>>>>>> +++ b/drivers/usb/musb/omap2430.c
> >>>>>>> @@ -544,6 +544,9 @@ static int omap2430_probe(struct platform_dev=
ice *pdev)
> >>>>>>> =20
> >>>>>>>  		pdata->board_data	=3D data;
> >>>>>>>  		pdata->config		=3D config;
> >>>>>>> +	} else {
> >>>>>>> +		/* bind the PHY */
> >>>>>>> +		usb_bind_phy(dev_name(&musb->dev), 0, "twl4030_usb");
> >>>>>>
> >>>>>> This looks like a hack IMHO to workaround the usb phy library. oth=
erwise it is
> >>>>>> similar to get_phy_by_name.
> >>>>>
> >>>>> actually, this is a workaround to the fact that we're not creating =
all
> >>>>> platform_devices in arch/arm/mach-omap2/ :-)
> >>>>>
> >>>>> If we had the musb allocation there, we could easily handle
> >>>>> usb_bind_phy()
> >>>>>
> >>>>>>> so that's temporary. It might be better than to reintroduce the I=
DR in
> >>>>>>> musb_core.c.
> >>>>>>
> >>>>>> that=E2=80=99s needed for generic phy framework anyway :-s
> >>>>>
> >>>>> right, but generic phy framework can handle everything just fine, t=
he
> >>>>> only problem is that names are changing.
> >>>>
> >>>> right. But if the names change, PHY framework wouldn't be able to re=
turn the
> >>>> reference to the PHY.
> >>>
> >>> with my suggestion they can change whenever they want since we're usi=
ng
> >>> dev_name() of the just-created musb platform_device. Right ?
> >>
> >> right. But the PHY device can be created in a different place from whe=
re the
> >> musb devices are created. And in the PHY framework, the PHY device sho=
uld have
> >=20
> > this shouldn't be a problem. As long as the phy is created, all should
> > be good.
> >=20
> >> the list of controller device (names) it can support (PHY framework do=
es not
> >> maintain a separate list for binding like how we had in USB PHY librar=
y). e.g.
> >> http://www.mail-archive.com/linux-omap@vger.kernel.org/msg92817.html. =
In such
> >=20
> > this has nothing to do with $subject though. We talk about generic PHY
> > framework once all these PHY drivers are moved there :-)
> >=20
> >> cases how do we pass the device names. Also will the MUSB core device =
be
> >> created before twl4030-usb PHY device?
> >=20
> > and why would that be a problem ? We're telling the framework that the
> > musb device will use a phy with a name of 'twl4030'. If musb calls
> > usb_get_phy_dev() and doesn't find a phy, it'll return -EPROBE_DEFER and
> > try again later.
>=20
> I think we are talking about different problems here ;-) I'm trying to te=
ll
> using idr in MUSB core is needed for Generic PHY Framework. So in a way, =
the
> Generic PHY Framework series depends on this patch series or else MUSB in=
 OMAP3
> platforms wont work after Generic PHY framework gets merged.

then you just found a limitation in your framework, right ? :-) I mean,
imagine if now we have to add an IDR to every single user of your
framework because they could end up in systems with multiple instances
of the same IP ?

Now consider that you aim to have your framework be used by Network,
USB, SATA, Graphics, etc... Have you really only considered DT
platforms ? DT is quite easy since you can require folks to pass the
proper phandle, but drivers will want to use PLATFORM_DEVID_AUTO and
your framework needs to cope with that.

--=20
balbi

--WRT3RXLOp/bBMgTI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR910bAAoJEIaOsuA1yqREgQ4P+we8b7ZPyz5Vj4OaPTnmmv5p
PFOgeb2+emM7sCILleJFlmq0Pn63jNnjdrGi+VfREUbdoFYasdkpnsuYVOBimYWX
W62fSm0kzXaL89RFoRjfGAfhhXSEQbDE48gFdm3PgREQlrzb9gvuKjg/Ab49fx97
dgEjDqDW3vJb9EJOYEhQbSrTTozh+2Blp6+0l+XA0x76j1zQNVqF84b5oIx3LWZM
XiI8zTYB7Zbe1A6RqkaxKdZxAgH5rWYkvCNIjWFjn43JWSuKTBfNaAjSAxzq8+nP
oNYJ4nqRZrbPH+uiWIy4HAUijBT1wVErQ5qXH3tac4e72OayuOwv4oS3eHonWudn
wr7xuqTmel1/SAsnHKhGDTraCibKU8bZLeOUsI5HCDZkl9XBgY7OvzRV3FxV/5j7
eJuBS2bl6FTFjNFm9a1O3u0U2cQ2AUAhfKXX3E9T3B3Bd5F/dV3mpaqTw1vqYsJn
ez0SMV/rXhA+Jay5Qc5h6gjcADnf+pMxyQDJBJs26lhciPnVXO4JGcosK8u+MCPH
bzphorXzrcoWF9qF+O0LNsxx8WGLUlwzIjaKNvc+1k7lmw4VtejYvG4fZZB/fLcw
S9GzNEnALh4aDBmpPXvXpN+7bKnCd5y4M5vVFytKvHCHF++SNZ4WZZbVUnH0tVLb
pE+uL46w9XK3HHD/2zkH
=/Iy8
-----END PGP SIGNATURE-----

--WRT3RXLOp/bBMgTI--
