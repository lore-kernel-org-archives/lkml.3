Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbaHKRfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 13:35:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49354 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752694AbaHKRfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 13:35:05 -0400
Date: Mon, 11 Aug 2014 19:33:56 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Houcheng Lin <houcheng@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, sre@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Vikas Sajjan <vikas.sajjan@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH v3] reset: Add a defer reset object to send board
 specific reset
Message-ID: <20140811173356.GN15297@lukather>
References: <1403098673-3058-1-git-send-email-houcheng@gmail.com>
 <CACRpkdYfu8HmVCkn9JFh+YP5OPdr8o9nTfoCnkJ7SSpGoenQUg@mail.gmail.com>
 <20140708080535.GJ13423@lukather>
 <CACRpkdbFPAsu1gE-AVyD=-RxyE7mUJPSbFga7HLh0mxjE-mQuQ@mail.gmail.com>
 <1407507789.3354.20.camel@paszta.hi.pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jdM5ZcN/ZcXXVwZs"
Content-Disposition: inline
In-Reply-To: <1407507789.3354.20.camel@paszta.hi.pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jdM5ZcN/ZcXXVwZs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 08, 2014 at 04:23:09PM +0200, Philipp Zabel wrote:
> Am Dienstag, den 08.07.2014, 11:38 +0200 schrieb Linus Walleij:
> > On Tue, Jul 8, 2014 at 10:05 AM, Maxime Ripard
> > <maxime.ripard@free-electrons.com> wrote:
> > > On Tue, Jul 08, 2014 at 09:52:03AM +0200, Linus Walleij wrote:
> > >> On Wed, Jun 18, 2014 at 3:37 PM, Houcheng Lin <houcheng@gmail.com> w=
rote:
> > >>
> > >> > The Problem
> > >> > -----------
> > >> > The reset signal on a hardware board is send either:
> > >> >     - during machine initialization
> > >> >     - during bus master's initialization
> > >>
> > >> I just thought about this a bit, since there isn't already a generic=
 GPIO
> > >> reset driver, just call this drivers/reset/reset-gpio.c and make the
> > >> ability to deferral just a configuration detail of the GPIO reset dr=
iver.
> > >
> > > Philipp has been working on one for quite some time. See
> > > http://www.spinics.net/lists/arm-kernel/msg321927.html
> > >
> > > However, it seems to progress slowly, and we don't seem to be able to
> > > reach a consensus here.
>=20
> Mostly because Maxime and I seem to have a completely different opinion
> and nobody else argued one way or the other.

Yep, mostly because I don't see how a generic approach can work.

The existing reset-gpios property only provide the gpio to use, but
some informations are encoded in the driver, such as the reset
duration, or a reset sequence if any.

How do you plan on giving that information to your generic driver?

The only solution I can think of would be to add an extra property
that your code would parse. But then, you break the existing DT
bindings.

And if we're going to break those bindings, at least do it in a way
consistent with reset bindings.

Plus, your approach doesn't cover the weird corner cases such as:
  - reset-gpio
  - wlf,reset-gpios
  - phy-reset-gpios
  - snps,reset-gpio
  - the drivers that need several gpio and expect the reset one as a
    positional argument.
  - etc.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--jdM5ZcN/ZcXXVwZs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT6P6EAAoJEBx+YmzsjxAgeykP/2GNQxfk2wdXbNum225uiKFe
qIkEVovztjBUQUyLePq4dltRSGqm3dXKNDVymcvCsv5RaNqgQAxXuDr/ElhGnOHr
KyCMZjYpDh6ta7LdJmH5vkr3UBhmCdtpKM9j3W5j5yjc6YqaykzNCwOAxrMenDsY
VG0FpmRe4XsGBUCi/au8cfNMdGGNeyF3jidPZrz8LKz1KsWqtIv4+gnwZzkxWYjW
NioFXRjPl8BA+nLdKUCRib/gcK1Ok6TKI4+ehPw13sF8sSbfVgSAbSuH6SXa/89I
rePDvKYOStnBcwANqMZa3MGPqb3/KER+5krTPKr1UduQn+OQ23UlhjIVMpkpqIiq
bXIbUNmjBCAqTpLN4E8LrNmmjRFeDNfdLUjwG/RalFfpciq4JoEaohgRQ0F2Eppk
1kC8pZWE8B+0iBe7CE29Wj5fK6IqKwldncBZMy7315H1AqrTbtkXXt8VZGmjebZH
BfvS5bsVkKXL5Bqe83m5CcfYCFBsVwAkLcAirWxDPiqZzoM0eDDSkLKVXq/x2eCb
kWe4VDrW1FPWYUXhjGhzYLWdYvq06hpP4w2ScJo4ii4O9vvPS8fWdhOxhAu56JoU
/5OQRc32DQlq0o/TxjGDAmIJFQheuYWncstSvTgcgKxYkn9pgjGMrq8G9AGzZrlZ
PC59BjM75QyuZs4K5Irk
=Cba6
-----END PGP SIGNATURE-----

--jdM5ZcN/ZcXXVwZs--
