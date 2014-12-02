Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502AbaLBQPH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 11:15:07 -0500
Received: from down.free-electrons.com ([37.187.137.238]:33678 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932079AbaLBQPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 11:15:04 -0500
Date: Tue, 2 Dec 2014 17:12:27 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>, Benoit Parrot <bparrot@ti.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [Patch v2 1/2] gpio: add GPIO hogging mechanism
Message-ID: <20141202161227.GH30256@lukather>
References: <1416527684-19017-1-git-send-email-bparrot@ti.com>
 <1416527684-19017-2-git-send-email-bparrot@ti.com>
 <CAAVeFu+VZiuzobB7McSAUehKUHJjBv1o8ZpYjSHJAKjr3o5wTA@mail.gmail.com>
 <20141201163639.GI25249@lukather>
 <CAAVeFuLTupDenZdSi8KO+dYsf-ekcqjsDaQ2GEzYpBG34oF7Zw@mail.gmail.com>
 <CACRpkdZcNcPBYQM438CZJx1gYst9BFBSTj-3Qv2aPGF9pdWa5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aYDVKSzuImP48n7V"
Content-Disposition: inline
In-Reply-To: <CACRpkdZcNcPBYQM438CZJx1gYst9BFBSTj-3Qv2aPGF9pdWa5g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aYDVKSzuImP48n7V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 02, 2014 at 03:29:46PM +0100, Linus Walleij wrote:
> On Tue, Dec 2, 2014 at 3:13 PM, Alexandre Courbot <gnurou@gmail.com> wrot=
e:
> > On Tue, Dec 2, 2014 at 1:36 AM, Maxime Ripard
> > <maxime.ripard@free-electrons.com> wrote:
>=20
> >> The only thing I'd like to have would be that the request here would
> >> be non-exclusive, so that a later driver would still be allowed later
> >> on to request that GPIO later on and manage it itself (ideally using
> >> the usual gpiod_request function).
> >
> > Actually we have a plan (and I have some code too) to allow multiple
> > consumers per GPIO. Although like Benoit I wonder why you would want
> > to hog a GPIO and then request it properly later. Also, that probably
> > means we should abandon the hog since it actively drives the line and
> > would interfere with the late requested. How to do that correctly is
> > not really clear to me.
>=20
> I don't get the usecase. A hogged GPIO is per definition hogged.
> This sounds more like "initial settings" or something, which is another
> usecase altogether.

We do have one board where we have a pin (let's say GPIO14 of the bank
A) that enables a regulator that will provide VCC the bank B.

Now, both banks are handled by the same driver, but in order to have a
working output on the bank B, we do need to set GPIO14 as soon as
we're probed.

Just relying on the usual deferred probing introduces a circular
dependency between the gpio-regulator that needs to grab its GPIO from
a driver not there yet, and the gpio driver that needs to enable its
gpio-regulator.

GPIO hogging needs to be the ideal solution for that, since we can
just enforce the GPIO14 value as the driver is probed, which provides
the guarantee that any driver using the bank B will actually drive the
GPIO it might use.

However, an exclusive request will prevent any representation of this
as a regulator, which sounds a bit weird, since it really is just
that.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--aYDVKSzuImP48n7V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUfeTrAAoJEBx+YmzsjxAg7wYQAJjqiXLHrQqwc+skXbprskOn
rcVJePS4tpBlurQ53c3furPKW6R0LQNsyM9pMkllPceFCD7wvsbGvpg1z4yeuUaQ
Wn7Lzu0fipLPHpCZhXc9bU4Db3CemEAhRoUrDwTV8fvSAcIS2zTxQmqcmGlBUCZQ
1+mzoB5w3keBrEtkT7Zl9EZyq5Zs8neortY8/fePrPyE69o0dhZ57/uBgIIfXIbs
BY9QC5Wm5cKMpB9VcERVWzV+VLzCZIJ4pSpWpm9S8qpXtQ/cMOmOT8aNYpNRkant
mTcP0kVMGf81qyAn9ujD++IScXeM6eMaKdafryXMu8jkY7yVONobB7H3kAUFyG0U
066z3SodJZ2jiA1O22Zy3TAXrquEw6xRQGZJq4g04me9W8w1LisfCx6MI6SQuZr2
9rZ7jFgs9LGTtpihacok5xKT2cNafoGYz5U1rfgBkKJDtXGZM7aI4gpM1Td5efRM
oEHmFWmx5tuINJojWVB8VBifad4z9WwPAyMmT7t8CiVsVyksnUIHrb04pZcYTvd7
IMdVwIxqP/A0XTJ8nf/bNvib1hxr+whl/UDpLzpLxliexCaHonr5ADVH4QrFe2WU
NmID1qMhXDAyKGeOElRwY14vQNTC/A/xiMDdcTQ9qFfXOVbozr/EbebiJgkOQWyg
my+TgT1EUKb5R2YW7wyP
=+AOe
-----END PGP SIGNATURE-----

--aYDVKSzuImP48n7V--
