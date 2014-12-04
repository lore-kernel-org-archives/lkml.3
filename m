Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340AbaLDOzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 09:55:07 -0500
Received: from down.free-electrons.com ([37.187.137.238]:47973 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932176AbaLDOzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 09:55:04 -0500
Date: Thu, 4 Dec 2014 15:52:06 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Benoit Parrot <bparrot@ti.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [Patch v2 1/2] gpio: add GPIO hogging mechanism
Message-ID: <20141204145206.GR30256@lukather>
References: <1416527684-19017-1-git-send-email-bparrot@ti.com>
 <1416527684-19017-2-git-send-email-bparrot@ti.com>
 <CAAVeFu+VZiuzobB7McSAUehKUHJjBv1o8ZpYjSHJAKjr3o5wTA@mail.gmail.com>
 <20141201163639.GI25249@lukather>
 <CAAVeFuLTupDenZdSi8KO+dYsf-ekcqjsDaQ2GEzYpBG34oF7Zw@mail.gmail.com>
 <CACRpkdZcNcPBYQM438CZJx1gYst9BFBSTj-3Qv2aPGF9pdWa5g@mail.gmail.com>
 <20141202161227.GH30256@lukather>
 <CAAVeFu+Gms6ptyK6j1Zy_wWg+9URs+9zBu=pOiwiEERO=8NjNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kAOhhqH5290wydqT"
Content-Disposition: inline
In-Reply-To: <CAAVeFu+Gms6ptyK6j1Zy_wWg+9URs+9zBu=pOiwiEERO=8NjNw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kAOhhqH5290wydqT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi again,

It looks like I missed some part of it.

On Thu, Dec 04, 2014 at 11:15:38PM +0900, Alexandre Courbot wrote:
> > GPIO hogging needs to be the ideal solution for that, since we can
> > just enforce the GPIO14 value as the driver is probed, which provides
> > the guarantee that any driver using the bank B will actually drive the
> > GPIO it might use.
>=20
> At this point I start wondering if such initial setup should not be
> the job of the bootloader? GPIO hogging ought to be simple and
> definitive, adding the possibility to have it just as an initial value
> would considerably complexify it. E.g. when is the gpio chip driver
> supposed to release the hogged descriptor in such a case?

Relying on the bootloader for such trivial (and critical) things may
not work at all. You don't always have the option to replace it,
either because you physically can't, or just because you don't have
any alternative.

I agree that in general this is something that should go in the
bootloader, but we should have a way to deal with the case where it's
not done.

> Note that if the multiple GPIO consumer feature we are planning goes
> through, you should be able to use both hogging *and* a regulator on
> the same GPIO and achieve what you want. The expectation of multiple
> consumers is that the board designers know what they are doing, and
> this case would certainly fit (chip hogs the line and doesn't touch
> the value after that, letting the regulator control it without any
> conflict afterwards), although it would of course be better to solve
> the issue through regular probing...

If such an effort is on-going, then I'm totally fine waiting for it
and leaving that outside the hogging mechanism. As long as it works,
I'm happy.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--kAOhhqH5290wydqT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUgHUWAAoJEBx+YmzsjxAgTBoP/0cyxruXX3Z2vhWeZIQ/Hy0b
y8bh9eN+pvm4/d0X/qyf6RgfOS+brBOPaQfsMykaRs4QrKwa433a6W0xWk3lP/zR
evZQZhWxij/QsnXmlLt6jEkXrX+Eqrgro7pb5X2FHyV6RuXBumKxitx/bXpnN1qt
9GLBOxdZtXW3xukbDPawaDEu5OxazT87bd7PtVRRdhEvqiVSnPGShQXY7kDWbGvd
uFybcTt79awAxEJwOivCKWuA2NQufGo/xbSa68Kl3/dwIEKI+vRf/aUhvg2ATM8x
XWs8X4eZaHpofC1lKlBdOKo40rkcqrpW7NrFo6VEv/euf/I841BRo9tM/CoAgqD5
LchQ8BBlraOK0SZiPd+zKURrYQN7uC0NLX1G/paU2dWnWM6ncADVWS1ywqPH5q1z
0OEtlkLORhjcxVd/BkHcZEVyvioQaR98kS7AKqeN7L57+bYktRM5KCGA4q1WZi1Q
+l5ry9xGBlu8pw5jY5o9UHgd+2TcGnve7kcUY4K/koir75IgEFfBmCkVJDeeJ3j7
xcGF2XwORQS8Vlse4/CPZ5kO/I+9+IIpw43O8R3vB2dkJASGzrp/6qIbuRXvJNvJ
wRapCKuG1lrer/AQtG9pe0ftbw6+z49jQYfesYroxljutjopxZUM7Mviv6S49UY6
TQJk65eCo8DitpMSxlMi
=gYz0
-----END PGP SIGNATURE-----

--kAOhhqH5290wydqT--
