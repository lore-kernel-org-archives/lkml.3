Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbaKCPhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 10:37:08 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:55807 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579AbaKCPgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 10:36:04 -0500
Date: Mon, 3 Nov 2014 09:35:33 -0600
From: Felipe Balbi <balbi@ti.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: Felipe Balbi <balbi@ti.com>, David Cohen <david.a.cohen@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        stable <stable@vger.kernel.org>, <mathias.nyman@linux.intel.com>
Subject: Re: [PATCH] pinctrl: baytrail: show output gpio state correctly on
 Intel Baytrail
Message-ID: <20141103153533.GF27425@saruman>
Reply-To: <balbi@ti.com>
References: <20141013193618.GD29810@saruman>
 <CACRpkdYDiFvwsPwqACXS2bZU9peUyJEn-fpzVqZKYXseuEFGGA@mail.gmail.com>
 <20141028144249.GD8123@saruman>
 <CACRpkdaN5hNWFUOFbHLm8HgZEKVSETUgVF4Cn4UbMQxNEg46Vw@mail.gmail.com>
 <20141031132005.GB1273@saruman>
 <20141031162339.GA7136@psi-dev26.jf.intel.com>
 <20141031184509.GA2224@psi-dev26.jf.intel.com>
 <20141103092402.GA1304@lahna.fi.intel.com>
 <20141103150048.GB27425@saruman>
 <20141103152743.GB1618@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rMWmSaSbD7nr+du9"
Content-Disposition: inline
In-Reply-To: <20141103152743.GB1618@lahna.fi.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--rMWmSaSbD7nr+du9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Nov 03, 2014 at 05:27:43PM +0200, Mika Westerberg wrote:
> On Mon, Nov 03, 2014 at 09:00:48AM -0600, Felipe Balbi wrote:
> > On Mon, Nov 03, 2014 at 11:24:02AM +0200, Mika Westerberg wrote:
> > > On Fri, Oct 31, 2014 at 11:45:09AM -0700, David Cohen wrote:
> > > > > I think adding the module exit + allowing this driver to be a mod=
ule
> > > > > would be a good approach. Then we don't need to force generic x86=
 kernel
> > > > > binaries to always have this driver. Unless Mathias or Mika knows=
 a
> > > > > constraint to force this driver to be builtin only.
> > > >=20
> > > > It helps if I CC them when asking for feedback :)
> > > >=20
> > > > Mathias, Mika, do you know any constraint that forces pinctrl-baytr=
ail
> > > > to be bool?
> > >=20
> > > The only constraint that has been keeping this driver as bool is that
> > > some machines like, Asus T100, uses ACPI GPIO operation regions for
> > > toggling GPIOs to get things like sensor hub powered on. The GPIO
> > > operation region code does not yet handle -EPROBE_DEFER so only way to
> > > ensure that the operation region is there is to have the driver compi=
led
> > > in to the kernel.
> >=20
> > But that's not enough excuse to have every single x86 in the market
> > shipping with this driver. Think about a distro kernel, most likely this
> > gets enabled and it's wrong in 80% of the cases.
>=20
> True, but see below.
>=20
> > It would be nicer to add EPROBE_DEFER support, convert this into
> > tristate and have default =3D M if BAYTRAIL, or something.
>=20
> If it were simple as that we would have done that already. Please check
> drivers/gpio/gpiolib-acpi.c:acpi_gpio_adr_space_handler() and tell me
> how we can do that.
>=20
> The problem is that it is *firmware* code that decides to use the GPIO
> at some random point in time and we have no way to tell it to retry
> later when the GPIO is available.

which means that even with the driver built-in, there is still the
possibility that firmware will try to access it before
pinctrl-baytrail's init function is called and you'd end up in the same
situation.

The fact is that currently you're forcing every x86 (even non-Intel) to
ship with this driver statically linked into it just because a small
percent of x86 systems might need to have this ready-to-go early enough.

Unfortunately I don't know ACPI enough to tell you if there is a way to
tell firmware "hey, you can use GPIOs now", so I'l refrain from
commenting on that. But that doesn't change the fact that this is wrong.

--=20
balbi

--rMWmSaSbD7nr+du9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUV6DFAAoJEIaOsuA1yqREhlEP/j+DPv+44nXaklYhSW4S0tdL
GB4Yd5J9F2nc+z33drogERFT4P4k1Yq92WeW7rOpKI3KbKHNXL40BaUVicl3i+Lr
xiZkQs/sHnSTvSrRLydgzc97XHyqqsIp9+WQmiPYZ6V7z11KhJ2gy80noCs0fwEn
f7m9B/APReEO0vuE134p16avB5xtPhAYh+A4HYkCezQMxtCxXBPRAW9+c7urn9zj
qhJoI1rN8x4v4RtE7cbH5oltZ3lyIlV3pQ/CyDcmFV798vzgtNJZr5wwaP7QTjxZ
PZquj2gNYX7Q4IIFjVcozjBSTOKdYhY8KiKkk2MwGqbFwEB6q3e3e+uH7L0kA/9O
eyObtZ1185QJN69f4QIbYQlNzIJbJBrD/XFv5dQ3+CTXSjM1O7/Jw9d+tvD+R0BE
nYGLIDbXrn3MV8VRUJNRB5dX0I/6/K4Uy7hUk/Jpxmfu8+nMvO/gWCYgmwbSBZsV
M2rPQZNw0BZ9sP8AInzY7EnpEQzGT2hX7LF+MBHdIbzMEAOKRdukPzytB3YPRPK5
fja8hjXce5UjqSKhvlCmroinhNrj1EA9qpWsQunfw2ESSKGpzu8tD+lMUZUrZ866
qKFSEdsnglM18PehjYKsRpC2/9TFVAslYa+ZPxpTBmRiU71YWAnFLL41OmNBxL0+
NGvROFT3mpPncVM0ICbu
=bfI3
-----END PGP SIGNATURE-----

--rMWmSaSbD7nr+du9--
