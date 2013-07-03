Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964864Ab3GCOYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 10:24:08 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33123 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932915Ab3GCOYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 10:24:01 -0400
Date: Wed, 3 Jul 2013 17:23:11 +0300
From: Felipe Balbi <balbi@ti.com>
To: Luciano Coelho <coelho@ti.com>
CC: <balbi@ti.com>, <linux-wireless@vger.kernel.org>, <tony@atomide.com>,
        <nsekhar@ti.com>, <mturquette@linaro.org>, <mark.rutland@arm.com>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <nm@ti.com>
Subject: Re: [PATCH v3 2/8] wlcore: set irq_flags in the board files instead
 of hiding behind a quirk
Message-ID: <20130703142310.GT15056@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372860209-3504-1-git-send-email-coelho@ti.com>
 <1372860209-3504-3-git-send-email-coelho@ti.com>
 <20130703141332.GO15056@arwen.pp.htv.fi>
 <1372861094.21065.118.camel@cumari.coelho.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eNjIDde0W37E3OQP"
Content-Disposition: inline
In-Reply-To: <1372861094.21065.118.camel@cumari.coelho.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--eNjIDde0W37E3OQP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 03, 2013 at 05:18:14PM +0300, Luciano Coelho wrote:
> On Wed, 2013-07-03 at 17:13 +0300, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Wed, Jul 03, 2013 at 05:03:23PM +0300, Luciano Coelho wrote:
> > > diff --git a/arch/arm/mach-omap2/board-4430sdp.c b/arch/arm/mach-omap=
2/board-4430sdp.c
> > > index 56a9a4f..953f620 100644
> > > --- a/arch/arm/mach-omap2/board-4430sdp.c
> > > +++ b/arch/arm/mach-omap2/board-4430sdp.c
> > > @@ -703,12 +703,30 @@ static void __init omap4_sdp4430_wifi_init(void)
> > > =20
> > >  	omap4_sdp4430_wifi_mux_init();
> > >  	omap4_sdp4430_wlan_data.irq =3D gpio_to_irq(GPIO_WIFI_IRQ);
> > > +
> > > +	ret =3D gpio_request_one(GPIO_WIFI_IRQ, GPIOF_IN, "GPIO_WIFI_IRQ");
> > > +	if (ret) {
> > > +		pr_err("error requesting wl12xx gpio: %d\n", ret);
> > > +		goto out;
> > > +	}
> > > +
> > > +	ret =3D irq_set_irq_type(gpio_to_irq(GPIO_WIFI_IRQ), IRQ_TYPE_LEVEL=
_HIGH);
> > > +	if (ret) {
> > > +		pr_err("error setting wl12xx irq type: %d\n", ret);
> > > +		goto free;
> > > +	}
> > > +
> > >  	ret =3D wl12xx_set_platform_data(&omap4_sdp4430_wlan_data);
> > >  	if (ret)
> > >  		pr_err("Error setting wl12xx data: %d\n", ret);
> > > +
> > >  	ret =3D platform_device_register(&omap_vwlan_device);
> > >  	if (ret)
> > >  		pr_err("Error registering wl12xx device: %d\n", ret);
> > > +out:
> > > +	return;
> > > +free:
> > > +	gpio_free(GPIO_WIFI_IRQ);
> >=20
> > actually, you should leave this GPIO requested in order to use it as
> > IRQ.
> >=20
> > ditto for all others
>=20
> Actually, I don't need to use the GPIO if something goes wrong (ie.
> setting the IRQ type or setting the platform data).  Notice that in the
> normal cases (ie. without errors), I return before the gpio_free() is
> called.

hah, missed the 'return' call, my bad :-p

Reviewed-by: Felipe Balbi <balbi@ti.com>
Corrected-my-broken-eye-sight-by: Luciano Coelho <coelho@ti.com>

--=20
balbi

--eNjIDde0W37E3OQP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR1DPOAAoJEIaOsuA1yqRE+w8P/0vQAxjiyRYAtmuG7gTmnMGz
u2DloE0dnB4ex82cDGkDd5bWRNrmZ21MD4CTY5Dpb/i8k5mVnPr/IxNpp7ewJTWZ
WRNlHD7Trwx0B6Bxl93GSpf+rLUWjWsWkch1bWobCl1QjbBHiG+zSSFEtrgq9VCi
rMJTkbgIH0P52O06d0LUU7TuexoRQ6kkXE1yL+EV+y4eZs8UCRd4vkVbRfVloBkr
YGh2k7GIInGfNCjw2g1V83zVrBYKom+qVu4QgomDjEmNFBaLt6lVKDGra5dcXtbA
7WjX+tTgyL9uzDhixQrmzAbe+xyFTdb4iRm2ewyBSzqiTe4Tp5B8FLjyHN4lYVfv
QjIV+cbidsTbFRc/2cBQ3X8OAUEGbR9lPIibF0msQtsM0teNJcd/FJYY09nHn9BV
AIBfxUHmNPOFCHjvhOJQZy4w6MBfIWPY6/OSqNSYqpb+C6WgQbq/asJDw2XMJWdN
4TWxMOC4XXTWrkN8+2pwunSKE0jb9loadmpPcthZOUD6CPcT/LCpJ9THWhX1d+wn
WsXy3q6NZFLMMAEjr+PhydloWmPPiaQbJGoQbuy4OKin1iKjevcmZ1K1AFj1fory
XiUYhF0vmn/aGqMu+yVfma4CJg8ZIYQb+ewAY0985gYLwKOh4bn4tE6U70WTZJJy
y1OlYToV2A0Zkq0R0XJI
=6rpb
-----END PGP SIGNATURE-----

--eNjIDde0W37E3OQP--
