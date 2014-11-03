Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbaKCPuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 10:50:44 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:41540 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbaKCPul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 10:50:41 -0500
Date: Mon, 3 Nov 2014 09:50:11 -0600
From: Felipe Balbi <balbi@ti.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: Felipe Balbi <balbi@ti.com>, David Cohen <david.a.cohen@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        stable <stable@vger.kernel.org>, <mathias.nyman@linux.intel.com>
Subject: Re: [PATCH] pinctrl: baytrail: show output gpio state correctly on
 Intel Baytrail
Message-ID: <20141103155011.GH27425@saruman>
Reply-To: <balbi@ti.com>
References: <CACRpkdYDiFvwsPwqACXS2bZU9peUyJEn-fpzVqZKYXseuEFGGA@mail.gmail.com>
 <20141028144249.GD8123@saruman>
 <CACRpkdaN5hNWFUOFbHLm8HgZEKVSETUgVF4Cn4UbMQxNEg46Vw@mail.gmail.com>
 <20141031132005.GB1273@saruman>
 <20141031162339.GA7136@psi-dev26.jf.intel.com>
 <20141031184509.GA2224@psi-dev26.jf.intel.com>
 <20141103092402.GA1304@lahna.fi.intel.com>
 <20141103150048.GB27425@saruman>
 <20141103152743.GB1618@lahna.fi.intel.com>
 <20141103154207.GC1618@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tT3UgwmDxwvOMqfu"
Content-Disposition: inline
In-Reply-To: <20141103154207.GC1618@lahna.fi.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--tT3UgwmDxwvOMqfu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Nov 03, 2014 at 05:42:07PM +0200, Mika Westerberg wrote:
> On Mon, Nov 03, 2014 at 05:27:43PM +0200, Mika Westerberg wrote:
> > On Mon, Nov 03, 2014 at 09:00:48AM -0600, Felipe Balbi wrote:
> > > On Mon, Nov 03, 2014 at 11:24:02AM +0200, Mika Westerberg wrote:
> > > > On Fri, Oct 31, 2014 at 11:45:09AM -0700, David Cohen wrote:
> > > > > > I think adding the module exit + allowing this driver to be a m=
odule
> > > > > > would be a good approach. Then we don't need to force generic x=
86 kernel
> > > > > > binaries to always have this driver. Unless Mathias or Mika kno=
ws a
> > > > > > constraint to force this driver to be builtin only.
> > > > >=20
> > > > > It helps if I CC them when asking for feedback :)
> > > > >=20
> > > > > Mathias, Mika, do you know any constraint that forces pinctrl-bay=
trail
> > > > > to be bool?
> > > >=20
> > > > The only constraint that has been keeping this driver as bool is th=
at
> > > > some machines like, Asus T100, uses ACPI GPIO operation regions for
> > > > toggling GPIOs to get things like sensor hub powered on. The GPIO
> > > > operation region code does not yet handle -EPROBE_DEFER so only way=
 to
> > > > ensure that the operation region is there is to have the driver com=
piled
> > > > in to the kernel.
> > >=20
> > > But that's not enough excuse to have every single x86 in the market
> > > shipping with this driver. Think about a distro kernel, most likely t=
his
> > > gets enabled and it's wrong in 80% of the cases.
> >=20
> > True, but see below.
> >=20
> > > It would be nicer to add EPROBE_DEFER support, convert this into
> > > tristate and have default =3D M if BAYTRAIL, or something.
> >=20
> > If it were simple as that we would have done that already. Please check
> > drivers/gpio/gpiolib-acpi.c:acpi_gpio_adr_space_handler() and tell me
> > how we can do that.
>=20
> Actually the above is not the problem because we already have registered
> the GPIO chip and hence we have the GPIO available to the firmware code.

what happens before you registered the gpio chip ? It takes some time
=66rom head.S to gpiochip_irqchip_add(). Anywhere between that time,
firmware could try to access gpios and the same problem would occur.

> The real problem is that if the ACPI GPIO operation handler is not there
> at the time firmware decides to do something it will just skip things
> that depend on the operation region. So if it has a GPIO that is used to
> turn on sensor hub or touch panel or whatever, this will not be done and
> it results that the device in question might not work properly.

that's an issue that needs solving, but forcing every x86 kernel to ship
with this driver, is not a proper solution.

--=20
balbi

--tT3UgwmDxwvOMqfu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUV6QzAAoJEIaOsuA1yqRE66QP/1rC0KgtEScVJCq8+I14sHEN
jyw6vwxXPsFpMmhJPKDoaVk6ZGkYmLgY4Xkq3R5yfy/pmg2NPh4FZzYfX58xpuT4
HdeLE8aejAsf2DZ83vp0mHwyBVh7xBXjkiZCj+jBrPpFwlGG9WktovZjZ+E91vzA
qD5MWVdK8cHMwS570O8WcDebEhco84KWqZpcAi+lh277ldkXdDgrWmPQgKxiw1G/
H+WUJyUNBrZnCJQp2oKDuzD2deOnxx5aPIrQih3zRQ+7Zwozp5mHuN1bdGV4+KtN
3eLB4KjGC3aVqmSGoNIiHCaXD+EBMvrDKWR7Q2XzP+ex8RCK9InEU0WVvL9lpmPV
TN54ILhPPSxpr4o3l/tXQdbIq1fxi2Y+CYElAT3umjWqROmg1M/qMVlkjAt76GaK
pyqAWKXs6GoILYCxiY89dqZhegMAdpAPxJHDwSDsmrTKMpFHHyqyROFxDT1g9i/b
ez0LcNTR5pTtcnm1JSY2gbY+iTsaROxouFVzXlq/vWd8SqYO1AwEyHMgwg7W2AS1
zLG9mbpR3I/r2Y7uTkEHScJJE/YmL8uYozmAyH6HN21eUgk4TIhWHnVTHGy4nqcZ
QZgxHtooO7J6/FOrNTlfsOuhvblW83cT5+1RIDgkQmDPApKOP6Ux7/EGY6RkJuiB
+EIS/BKkvSt8IUr1nQfy
=l3w5
-----END PGP SIGNATURE-----

--tT3UgwmDxwvOMqfu--
