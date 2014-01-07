Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbaAGMfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 07:35:20 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:58838 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865AbaAGMfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 07:35:11 -0500
Message-ID: <52CBF476.3070306@ti.com>
Date: Tue, 7 Jan 2014 14:35:02 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
CC: "pali.rohar@gmail.com" <pali.rohar@gmail.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: OMAPDSS: DISPC: horizontal timing too tight errors
References: <52CA7ABB.4010401@gmail.com>
In-Reply-To: <52CA7ABB.4010401@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="lGQ1roxwHfHpkNkOBQ19098348nTVtRM1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--lGQ1roxwHfHpkNkOBQ19098348nTVtRM1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2014-01-06 11:43, Ivaylo Dimitrov wrote:
> Hi,
>=20
> commit 7faa92339bbb1e6b9a80983b206642517327eb75 "OMAPDSS: DISPC: Handle=

> synclost errors in OMAP3" introduces some limits check to prevent
> SYNCLOST errors on OMAP3 in a specific usecase. The problem I see here
> (on Nokia N900, Maemo 5, linux 3.13-rc6, DSP accel video decoding) is
> that those checks effectively prevent fullscreen video playback of
> anything above lets say 640x350 with "horizontal timing too tight"
> errors spit in dmesg log. If I hack check_horiz_timing_omap3 function t=
o
> always return true, I can happily play videos up to (and including) 720=
p
> resolutions, with no SYNCLOST errors.

I never worked with the patch in question, but my understanding is that
the core issue is quite difficult to solve optimally for all cases.
There are so many variables involved. So it may well be that the patch
in question does it a bit over-safely. Then again, it might as well have
a bug =3D).

One option is also to increase the blanking timings and pixel clock,
presuming the panel is fine with it. That would allow some more time for
the DISPC to manage scaling.

So are you saying that you can't even play any video in the LCD's native
resolution (i.e. no scaling needed) with fullscreen?

> So, a couple of questions:
>=20
> Where do the values in static const u8 limits[3] come from? Are those
> documented somewhere?

If I remember right, these horizontal check timings information came
from some non-public TI guides. Not from the TRM.

> Commit message says "This code is written based on code written by Vill=
e
> Syrj=E4l=E4 <ville.syrjala@nokia.com> in Linux OMAP kernel.", is that c=
ode
> publicly available and where (if it is).

It should be in the Nokia's kernel for N9.

> Besides compiling DSS driver with DEBUG enabled and providing the log
> (yeah, I know I should've done it already and have the logs included in=

> this mail, but... :) ), is there anything else I can do to find the
> culprit for those errors.

You could look at the original patch in the Nokia kernel to see if the
mainline version is ok. Or maybe even better, try the same use case on
Nokia's kernel to see if it works.

 Tomi



--lGQ1roxwHfHpkNkOBQ19098348nTVtRM1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSy/R2AAoJEPo9qoy8lh71J0gQAIuYRFk4VfUOWvEb/+RoF4OG
oCOnEEzjiJRg1810kZJ7ww6mkppxv568O6BuLiW4bCfF0BDuAwYKie0pa/YB7JSh
eShaSafkuRMvMetaD8ay0VYkmtzfxNMT/yA+bQ3woeNYVk4+1Z38bmOakCM6dzMD
8zBLEw6YvDB4tlONmoMe8Tp0t6vj2vPrOkCSWh3+J1PLe8R6WRhs5BZXbZZWZ1zY
jZo8Ho7rOlHBFFF3v0izzWANcZ9iAJc70ytZj7YWALfSz9qLuH+c5qlDTLQuf83X
8i912uaSjlhYMOQ6KXIxNooOXR2p1nW4K8yvd5v66PmE+Ceq04HatDnnYhswLLPq
Bq7+kaNDac5MfgICFkassrRV4a0UL+xg+yZFR3G1sjDSQxr80W0+82RFNgwPip2b
PHU2nxoV98uAMmE8+cHSMcVh5Xjwn3QT3RJ9CJmm2K/CfbaoOv75G20IzK2A6Av6
wvoU15hMXBUSFkktFJM6K1H465lwtjORWVXh8Xmkf53X+VaZBd3qonl7cn8VM9nF
836UuHhGw7oyM4KprBccNzSDRA52TzTqRBZNpXBJPP1ie7u9zNSBL1BAZCVmc4UL
HfEeZnJjN2KyJcfCD+xL6/HdB2iviW+CxIQvSCFAgYKmjdTkTW1j+XLFmBBXgJrl
+a4h3kNobNQfDFqXTVxp
=xCeT
-----END PGP SIGNATURE-----

--lGQ1roxwHfHpkNkOBQ19098348nTVtRM1--
