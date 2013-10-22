Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab3JVNvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 09:51:11 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57854 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753Ab3JVNvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 09:51:09 -0400
Date: Tue, 22 Oct 2013 08:50:40 -0500
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Reichel <sre@debian.org>
CC: Sebastian Reichel <sre@ring0.de>, <linux-input@vger.kernel.org>,
        "=?iso-8859-1?Q?'Beno=EEt?= Cousson'" <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 1/4] Input: twl4030-pwrbutton - add device tree support
Message-ID: <20131022135040.GN9340@gimli>
Reply-To: <balbi@ti.com>
References: <1382446504-27837-1-git-send-email-sre@debian.org>
 <1382446504-27837-2-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XFI+TFG+M3u0jUjZ"
Content-Disposition: inline
In-Reply-To: <1382446504-27837-2-git-send-email-sre@debian.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--XFI+TFG+M3u0jUjZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 22, 2013 at 02:55:01PM +0200, Sebastian Reichel wrote:
> Add device tree support for twl4030 power button driver.
>=20
> Signed-off-by: Sebastian Reichel <sre@debian.org>
> ---
>  drivers/input/misc/twl4030-pwrbutton.c | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/input/misc/twl4030-pwrbutton.c b/drivers/input/misc/=
twl4030-pwrbutton.c
> index b9a05fd..e450947 100644
> --- a/drivers/input/misc/twl4030-pwrbutton.c
> +++ b/drivers/input/misc/twl4030-pwrbutton.c
> @@ -52,7 +52,7 @@ static irqreturn_t powerbutton_irq(int irq, void *_pwr)
>  	return IRQ_HANDLED;
>  }
> =20
> -static int __init twl4030_pwrbutton_probe(struct platform_device *pdev)
> +static int twl4030_pwrbutton_probe(struct platform_device *pdev)
>  {
>  	struct input_dev *pwr;
>  	int irq =3D platform_get_irq(pdev, 0);
> @@ -106,16 +106,27 @@ static int __exit twl4030_pwrbutton_remove(struct p=
latform_device *pdev)
>  	return 0;
>  }
> =20
> +#if IS_ENABLED(CONFIG_OF)
> +static const struct of_device_id twl4030_pwrbutton_dt_match_table[] =3D {
> +       { .compatible =3D "ti,twl4030-pwrbutton" },
> +       {},
> +};
> +MODULE_DEVICE_TABLE(of, twl4030_pwrbutton_dt_match_table);
> +#define twl4030_pwrbutton_dt_match of_match_ptr(twl4030_pwrbutton_dt_mat=
ch_table)
> +#else
> +#define twl4030_pwrbutton_dt_match NULL
> +#endif

you don't ned this trickery.. just always device the match table.

--=20
balbi

--XFI+TFG+M3u0jUjZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSZoKvAAoJEIaOsuA1yqREH5EP/RS0Nl8ppNk75V08SuxgTsWZ
rCJvBEVX8CQEz2Qc2uEswR1N5YxR47BCjyY4yY2Rx2joUGY+t8jXtiuH+4c/luc5
HOnOS2JbO8AYlRAjqFaLi/vTdfCVw8O7hsL5yGdHYQoHDdZCf2ts0FR4aenryVZG
LRZwXnRIR8KVIsk+yuIMA71ngvpsdBUa5j05RZuNzxyfTqU84ENawBZs31kRVbTQ
v49BJiWHbUtFVpVUgukMTw/WC6Dqzi1x3A4FcbgEFrDhpd+TOQYCencLJPdsIfiE
J7WUmfVA2X5A86Kl9u6TFAgS5p+yo4kOtgnTG9k1QO1LqAGJQu4to1fHd93P99mH
lLEqkLEcjYyxUdOYVLynJT3wRrkkt+8rpCa21mk5ie30Rv7EmHp8arQBcq2Ls39d
j/4QZ4zCeq+m/VNSfKaQeA/aJ7PrD9pOPWlolzxwBAPl2fapxIIRsy8LCvQuM+A8
jXe2iht2ZKUQKHrQJASNcuaboAo/Xe0k9GrYMYTO9mcVEpa6gaqEctPZ9lxlY/3M
PMNQVqeLCG5DoFv+LCLB68CXYnse8H85ZN2GZEJ/jC8Tuc+u6HVn4UeCqq/6gaoG
TR8NnvkAWKqFuSaJkZMkmb6VlZ5V+mOreLm4M5x5ADWE2IXpS2NScm0wuACJSZiC
tPSwYj0hmOYAyZ6b+5kK
=Uejm
-----END PGP SIGNATURE-----

--XFI+TFG+M3u0jUjZ--
