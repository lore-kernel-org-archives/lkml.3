Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbaFDNLa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 09:11:30 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:46028 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbaFDNL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 09:11:28 -0400
Date: Wed, 4 Jun 2014 15:08:39 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 2/2] gpio: of: Allow -gpio suffix for property names
Message-ID: <20140604130837.GA28484@ulmo>
References: <1398266889-17489-1-git-send-email-thierry.reding@gmail.com>
 <1398266889-17489-2-git-send-email-thierry.reding@gmail.com>
 <CACRpkdbF3N5bFY1sFkabDHO7J0F8sb1uU0xL+mjkuF-z7VocMQ@mail.gmail.com>
 <20140602230457.GE11004@atomide.com>
 <20140602231423.GF11004@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
In-Reply-To: <20140602231423.GF11004@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 02, 2014 at 04:14:23PM -0700, Tony Lindgren wrote:
> * Tony Lindgren <tony@atomide.com> [140602 16:06]:
> > * Linus Walleij <linus.walleij@linaro.org> [140425 00:53]:
> > > On Wed, Apr 23, 2014 at 5:28 PM, Thierry Reding
> > > <thierry.reding@gmail.com> wrote:
> > >=20
> > > > From: Thierry Reding <treding@nvidia.com>
> > > >
> > > > Many bindings use the -gpio suffix in property names. Support this =
in
> > > > addition to the -gpios suffix when requesting GPIOs using the new
> > > > descriptor-based API.
> > > >
> > > > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > >=20
> > > It appears this can save quite a lot of code in drivers, work that
> > > I trust Thierry to persue based on this to some extent so patch is
> > > tentatively applied unless something comes up.
> >=20
> > Looks like this patch causes a regression where GPIOs on I2C will
> > no longer return -EPROBE_DEFER but seem to return -ENOENT instead.
> >=20
> > This breaks drivers using things like devm_gpiod_get_index()
> > on a GPIO that's on a I2C bus not probed yet.
> >=20
> > Reverting commit dd34c37aa3e (gpio: of: Allow -gpio suffix for
> > property names) fixes things.
>=20
> Looks like something like below fixes the issue.
>=20
> Regards,
>=20
> Tony
>=20
> 8< -----------------------
> From: Tony Lindgren <tony@atomide.com>
> Date: Mon, 2 Jun 2014 16:13:46 -0700
> Subject: [PATCH] gpio: of: Fix handling for deferred probe for -gpio suff=
ix
>=20
> Commit dd34c37aa3e (gpio: of: Allow -gpio suffix for property names)
> added parsing for both -gpio and -gpios suffix but also changed
> the handling for deferred probe unintentionally. Because of the
> looping the second name will now return -ENOENT instead of
> -EPROBE_DEFER. Fix the issue by breaking out of the loop if
> -EPROBE_DEFER is encountered.
>=20
> Signed-off-by: Tony Lindgren <tony@atomide.com>
>=20
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -2614,7 +2614,7 @@ static struct gpio_desc *of_find_gpio(struct device=
 *dev, const char *con_id,
> =20
>  		desc =3D of_get_named_gpiod_flags(dev->of_node, prop_name, idx,
>  						&of_flags);
> -		if (!IS_ERR(desc))
> +		if (!IS_ERR(desc) || (PTR_ERR(desc) =3D=3D -EPROBE_DEFER))
>  			break;
>  	}

This looks good to me:

Reviewed-by: Thierry Reding <treding@nvidia.com>

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTjxpVAAoJEN0jrNd/PrOhrcIP/jzZ/lA7zWPp2tgU7mPOqDPw
AEgN5W622UC3wGzvloUfOp2MxP9YbkrZofoL7vMaoId5maQ4ktvIWBMElM28oKxi
O808R1jY8NYdkh2FRIo+yebxpg63IhRWjJw33Hl3MQpE6dW9/l0YCq7HWiS2fowo
Uqn6yoYwH/3s8l0tPUuu0KawNbVpZMPa5C1GWesnhR42X/DtssIsRzuNFnGspYnD
0+cBXknyg46zHoAzsgGG8LqUe5R5pHFcgPtjGyGpwlX4y8I4by+I6OJWPeS5CyT5
q8jfT3i1BI0CejyDLl5D/zHrSDwNpKyP6/UG2YRUwP/IrSa36aayKjjAb9H9Y9bT
3BSaT504YMjeFLib0EJ6yNB4pgxb7yy41FCYp2x1Je3606kD66CIn/2VxHJY5ran
5zG/xYfxpVy3EvbLGpXCq15tt0T0J+1VWEjcK5o0dsF4hYdWMmiS3IbIVi/L/s+K
/unWI6MFUukE39tGvMOvcbZqRD96LPRTpKbfpnBnIhZaPtG1lliAsPJwFT/MKNWi
tabDB6QCRQxG5gXHDQOXJPqXlL4L9oExl21qZpV/NH7IV6Bs0wkx8QGAvwO0CqVy
c2AdTwRrm+3VOEn/RBMUeU3R/jJgoU7o3S7VCdO+uS/S0I33coXd203ofg8M5TUn
uFAeMSq/LZXdcwlMNPnC
=BaS6
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
