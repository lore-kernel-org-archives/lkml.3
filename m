Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808AbaAGLU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 06:20:29 -0500
Received: from top.free-electrons.com ([176.31.233.9]:58397 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751322AbaAGLUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 06:20:03 -0500
Date: Tue, 7 Jan 2014 12:19:54 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Roger Quadros <rogerq@ti.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH v2 2/2] reset: Add GPIO support to reset controller
 framework
Message-ID: <20140107111954.GA2849@lukather>
References: <1389030903-27684-1-git-send-email-p.zabel@pengutronix.de>
 <1389030903-27684-2-git-send-email-p.zabel@pengutronix.de>
 <20140106181422.GS3144@lukather>
 <1389088341.4815.9.camel@pizza.hi.pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
In-Reply-To: <1389088341.4815.9.camel@pizza.hi.pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Philipp,

On Tue, Jan 07, 2014 at 10:52:21AM +0100, Philipp Zabel wrote:
> > > +	const char *gpio_con_id =3D "reset";
> > > +	struct reset_controller_dev *rcdev;
> > > +	struct reset_control *rstc;
> > > +	struct gpio_desc *gpiod;
> > > +	bool asserted =3D false;
> > > +	char scratch[48];
> > > +	int ret;
> > > +
> > > +	if (id) {
> > > +		snprintf(scratch, 48, "%s-reset-boot-asserted", id);
> > > +		assert_prop =3D scratch;
> > > +	}
> > > +
> > > +	asserted =3D of_property_read_bool(dev->of_node, assert_prop);
> > > +
> > > +	if (id) {
> > > +		snprintf(scratch, 48, "%s-reset", id);
> > > +		gpio_con_id =3D scratch;
> > > +	}
> > > +
> > > +	gpiod =3D gpiod_get(dev, gpio_con_id);
> > > +	if (IS_ERR(gpiod)) {
> > > +		dev_err(dev, "Failed to get GPIO reset: %ld\n", PTR_ERR(gpiod));
> > > +		return ERR_CAST(gpiod);
> > > +	}
> > > +
> > > +	ret =3D gpiod_direction_output(gpiod, asserted);
> > > +	if (ret < 0)
> > > +		goto err_put;
> >=20
> > What happens if the GPIO is active low? I see no way in your binding
> > and driver to give that information, and that would change the
> > behaviour quite a bit.
>=20
> I was under the (wrong) impression that gpiod_direction_output takes a
> logical value as gpiod_set_value does. Will fix that.

I don't think gpiod_set_value does either unfortunately.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSy+LaAAoJEBx+YmzsjxAgurkP/j1S/53OnITJ/mXhsokQDhX2
Xse9Ah+5fytIyI7A7DWWP1LmQiQZl17SOdHrTOLbGKpWFybeMC6G6Zx4E086vGWR
AIAfKye7Y9MHcgm40QiNr570JrgffL38GP0zr16kKyeszT6wAHvy5vQET599+l9f
akr+g7FIbe1uslsmf0uFBFr6s9Z01Tg1FWCFbx5w1LzYrTI0fO9fM50s7vRDEv0C
r/OE0IGSmqXYMKKPPjnCpdHIBgOasRBPam1VjM62TrRoi+X8GldrkqAEGAutcUWX
csCKKpC1S9W50/PvkNljW/ykvy3hkI4PTWMryA8xGSE+d4ywfG+HKCkFIVAPtcIr
wIWX4tKqWOMcDZ66F/3PklnrbrfCBMG4/YxERgXsrJeJwD1bQrQnY5J8L9cOtBr9
MULletcIHBivsE/etvE3AxaMnpDAHFhJOO9VcElWYLrTaH/NFX5O9qy/Zon5szKA
nJLkAd62dF9AhrsjpfSuOCRx7YTVoCn6nKQ+l3pczv+zUbVByvQEa9j97OVvRajI
rl1O12w0V30wFpsBvEwGLAhHiSV1u17+YEfScmoMWRGU13ci2wESXf9WdcxWoL7I
g22rXLKd8BaXKVHztvs74dpwePUHgDOg0vzVyto+bniLqpnnX12ZAYqittUqqFl9
YQpRSS7V28FiPJQFPUK7
=jtX/
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
