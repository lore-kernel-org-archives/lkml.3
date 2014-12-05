Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751085AbaLEKZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 05:25:17 -0500
Received: from down.free-electrons.com ([37.187.137.238]:53161 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750743AbaLEKZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 05:25:14 -0500
Date: Fri, 5 Dec 2014 11:24:27 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Benoit Parrot <bparrot@ti.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [Patch v2 1/2] gpio: add GPIO hogging mechanism
Message-ID: <20141205102427.GU30256@lukather>
References: <1416527684-19017-1-git-send-email-bparrot@ti.com>
 <1416527684-19017-2-git-send-email-bparrot@ti.com>
 <CAAVeFu+VZiuzobB7McSAUehKUHJjBv1o8ZpYjSHJAKjr3o5wTA@mail.gmail.com>
 <20141201163639.GI25249@lukather>
 <CAAVeFuLTupDenZdSi8KO+dYsf-ekcqjsDaQ2GEzYpBG34oF7Zw@mail.gmail.com>
 <CACRpkdZcNcPBYQM438CZJx1gYst9BFBSTj-3Qv2aPGF9pdWa5g@mail.gmail.com>
 <20141202161227.GH30256@lukather>
 <CAAVeFu+Gms6ptyK6j1Zy_wWg+9URs+9zBu=pOiwiEERO=8NjNw@mail.gmail.com>
 <20141204142741.GQ30256@lukather>
 <CAAVeFuJTjWPzQYYkV3jW3+h6uigzzeKS9d7pY2cQ-dK119msXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UC+RhZhEc8lcmajv"
Content-Disposition: inline
In-Reply-To: <CAAVeFuJTjWPzQYYkV3jW3+h6uigzzeKS9d7pY2cQ-dK119msXg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UC+RhZhEc8lcmajv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 04, 2014 at 11:49:19PM +0900, Alexandre Courbot wrote:
> On Thu, Dec 4, 2014 at 11:27 PM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
> > Hi,
> >
> > On Thu, Dec 04, 2014 at 11:15:38PM +0900, Alexandre Courbot wrote:
> >> On Wed, Dec 3, 2014 at 1:12 AM, Maxime Ripard
> >> <maxime.ripard@free-electrons.com> wrote:
> >> > On Tue, Dec 02, 2014 at 03:29:46PM +0100, Linus Walleij wrote:
> >> >> On Tue, Dec 2, 2014 at 3:13 PM, Alexandre Courbot <gnurou@gmail.com=
> wrote:
> >> >> > On Tue, Dec 2, 2014 at 1:36 AM, Maxime Ripard
> >> >> > <maxime.ripard@free-electrons.com> wrote:
> >> >>
> >> >> >> The only thing I'd like to have would be that the request here w=
ould
> >> >> >> be non-exclusive, so that a later driver would still be allowed =
later
> >> >> >> on to request that GPIO later on and manage it itself (ideally u=
sing
> >> >> >> the usual gpiod_request function).
> >> >> >
> >> >> > Actually we have a plan (and I have some code too) to allow multi=
ple
> >> >> > consumers per GPIO. Although like Benoit I wonder why you would w=
ant
> >> >> > to hog a GPIO and then request it properly later. Also, that prob=
ably
> >> >> > means we should abandon the hog since it actively drives the line=
 and
> >> >> > would interfere with the late requested. How to do that correctly=
 is
> >> >> > not really clear to me.
> >> >>
> >> >> I don't get the usecase. A hogged GPIO is per definition hogged.
> >> >> This sounds more like "initial settings" or something, which is ano=
ther
> >> >> usecase altogether.
> >> >
> >> > We do have one board where we have a pin (let's say GPIO14 of the ba=
nk
> >> > A) that enables a regulator that will provide VCC the bank B.
> >> >
> >> > Now, both banks are handled by the same driver, but in order to have=
 a
> >> > working output on the bank B, we do need to set GPIO14 as soon as
> >> > we're probed.
> >> >
> >> > Just relying on the usual deferred probing introduces a circular
> >> > dependency between the gpio-regulator that needs to grab its GPIO fr=
om
> >> > a driver not there yet, and the gpio driver that needs to enable its
> >> > gpio-regulator.
> >>
> >> I don't get it. According to what you said, the following order should
> >> go through IIUC:
> >>
> >> 1) bank A is probed, gpio 14 is available
> >> 2) gpio-regulator is probed, acquires GPIO 14, regulator for Bank B is=
 available
> >> 3) bank B is probed, grabs its regulator and turn it on, probes.
> >>
> >> What am I missing?
> >
> > It would be true if bank A and B were exposed through different
> > drivers (or at least different instances of the same driver), which is
> > not the case.
> >
> > In our case, banks A and B are handled by the same instance.
>=20
> Ok, so both banks A and B are part of the same device/DT node. Now I
> think I understand the issue. You need to hog the pin so that bank B
> will work right after the device is probed.

Exactly.

> But you will still have the problem that the regulator device will
> *not* be available when your device is probed, so you cannot call
> regulator_get() for bank B anyway. I guess your only choice is to hog
> that pin and leave it active ad vitam eternam.

Hmmm, indeed.

I'll stop boring you with this then :)

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--UC+RhZhEc8lcmajv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUgYfbAAoJEBx+YmzsjxAgmpsP/R3WiGc4Ttc7NDAtwfbgkOo2
OPWrvJ4xE6vJn+kEzD4Ku3MVvW7AZdJXB5pQjYsUp0upEWVfIf8K3OL3hAW9qcg8
rn7HQJZube7cTbMuR4MR4+pyJmjyWyRAeHKtEdNu/VeOYGQDzFeCCINQElE7EjmL
BAe7fr0cZfdJgXxOFibAUWFHF+4ADRE0ApOj+MnIzf0PiDCiziAqmtxI6tZxNB3g
Zbz83pDrzui2+NCnP+qAMluCEDn82Wb0GCbC3CH1k33Q/wzX0uR5SyRpULfdrZWe
nZW2c0CxcAFElpAol1r+89JpKdyF7M0bBcLnVAGy2+jchdrTDPQ/gLZvh5/7L5+2
GqE7NTuTqTO6iJlIccI9+dnYprrDuD2oIdnywp6NVpswYGSVEZntMhqKLzlptj9z
UIN4HIeCbzNy8057GErgNJL8rBrAXn5ThfF+ADCrSWKkA2G+KVrexQEQgVN34jwB
rPILYBihRjSz03s1b22uNJZpUt0+vgdU9O3k7oKPz+KSD0YM2Yqxrj3uEqNYfJia
K+0c5WoLg7HLSxfbT73a/HqFxYVX9QlbQiAlPkol9YtHne6lqz3s6eacc3KmfjKd
i09bbdbw/6TtiqE8G2w0QsCvdgsKkNpo8k+etXSzI2mW+rYu52WISMMhp/klZkOi
r/gLhjZoZ65iAiCaN4Z1
=3zZ9
-----END PGP SIGNATURE-----

--UC+RhZhEc8lcmajv--
