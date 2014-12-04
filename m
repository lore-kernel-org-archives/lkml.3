Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbaLDOaK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 09:30:10 -0500
Received: from down.free-electrons.com ([37.187.137.238]:47819 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753826AbaLDOaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 09:30:04 -0500
Date: Thu, 4 Dec 2014 15:27:41 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Benoit Parrot <bparrot@ti.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [Patch v2 1/2] gpio: add GPIO hogging mechanism
Message-ID: <20141204142741.GQ30256@lukather>
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
	protocol="application/pgp-signature"; boundary="mzmkN2k+aDjaU9Rr"
Content-Disposition: inline
In-Reply-To: <CAAVeFu+Gms6ptyK6j1Zy_wWg+9URs+9zBu=pOiwiEERO=8NjNw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mzmkN2k+aDjaU9Rr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Dec 04, 2014 at 11:15:38PM +0900, Alexandre Courbot wrote:
> On Wed, Dec 3, 2014 at 1:12 AM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
> > On Tue, Dec 02, 2014 at 03:29:46PM +0100, Linus Walleij wrote:
> >> On Tue, Dec 2, 2014 at 3:13 PM, Alexandre Courbot <gnurou@gmail.com> w=
rote:
> >> > On Tue, Dec 2, 2014 at 1:36 AM, Maxime Ripard
> >> > <maxime.ripard@free-electrons.com> wrote:
> >>
> >> >> The only thing I'd like to have would be that the request here would
> >> >> be non-exclusive, so that a later driver would still be allowed lat=
er
> >> >> on to request that GPIO later on and manage it itself (ideally using
> >> >> the usual gpiod_request function).
> >> >
> >> > Actually we have a plan (and I have some code too) to allow multiple
> >> > consumers per GPIO. Although like Benoit I wonder why you would want
> >> > to hog a GPIO and then request it properly later. Also, that probably
> >> > means we should abandon the hog since it actively drives the line and
> >> > would interfere with the late requested. How to do that correctly is
> >> > not really clear to me.
> >>
> >> I don't get the usecase. A hogged GPIO is per definition hogged.
> >> This sounds more like "initial settings" or something, which is another
> >> usecase altogether.
> >
> > We do have one board where we have a pin (let's say GPIO14 of the bank
> > A) that enables a regulator that will provide VCC the bank B.
> >
> > Now, both banks are handled by the same driver, but in order to have a
> > working output on the bank B, we do need to set GPIO14 as soon as
> > we're probed.
> >
> > Just relying on the usual deferred probing introduces a circular
> > dependency between the gpio-regulator that needs to grab its GPIO from
> > a driver not there yet, and the gpio driver that needs to enable its
> > gpio-regulator.
>=20
> I don't get it. According to what you said, the following order should
> go through IIUC:
>=20
> 1) bank A is probed, gpio 14 is available
> 2) gpio-regulator is probed, acquires GPIO 14, regulator for Bank B is av=
ailable
> 3) bank B is probed, grabs its regulator and turn it on, probes.
>=20
> What am I missing?

It would be true if bank A and B were exposed through different
drivers (or at least different instances of the same driver), which is
not the case.

In our case, banks A and B are handled by the same instance.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--mzmkN2k+aDjaU9Rr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUgG9dAAoJEBx+YmzsjxAgRwgP/iM8E5KZkUVV41J0U/z9uK39
Quye8cUd15D9cdiFWGve7smzun9kFXJDmTJaqWjb7buwvl80KxR+UQEnQeaU7Kzc
0ZH5M0qH9Kq6QySMzdGYUEAgdryKpRFbBglyfypQJUEfijk/iKIuFNs4EG5/9I/L
6X+DJabUOf21DfHvQwl2Hn8Xy+0j3uPTLodG00+WfxAokxqRqE3JpRnBwmXwAcBd
L5LyFhPudJaSrTaHfDbdQFWo3E0MknJq2hpjw8Di4H8cOs98UD47kYyst2naIZr+
0b98pHtucXVuiJi6Q3SX/75q4bB/uAP9Ve/STitLe+xHGLW7UD5t/dZaTVFUPnCC
cI/4d8wZgyujgMU6PAkIS+wTGxUfOVvWeZ6FcXziHanhoWC25SCg6GwASq0OC92s
zM1vPRpXeaWUWBnmTRwzaSizOJCnJ8HTrYVJs0T7pqOhwZXyNYCgltZdePqYszJ2
qlJkSSjf4zNzj+MMtGWvDgYLe2jSjUACvq1eqy+bb4gPtp1Pq0j6QFByauyFrJeY
E6fD+IAqqNSphPCO1VN20XJnh4WQSDSqsrpSTwyMSNz4X/EvXlavU328nln2ABal
pi8DarqO86NJVfhGnnvviS4rsewVzmvvIo25TDxvuiopMXzkAtIvZQ7AIlSw8tEf
ujHEEDJiu3f1kFAQy4bl
=6JAx
-----END PGP SIGNATURE-----

--mzmkN2k+aDjaU9Rr--
