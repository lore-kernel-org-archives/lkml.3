Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967831AbaLLNAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 08:00:32 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56695 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967589AbaLLNAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 08:00:30 -0500
Date: Fri, 12 Dec 2014 12:59:51 +0000
From: Mark Brown <broonie@kernel.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Alexandru Stan <amstan@chromium.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20141212125951.GE11764@sirena.org.uk>
References: <1418245085-9754-1-git-send-email-dianders@chromium.org>
 <20141210235347.GT11764@sirena.org.uk>
 <CAHNYxRy2t0OVj-+CqQFOfj0zWAGG0j8rmd8SxdNWgBMA2iAfXQ@mail.gmail.com>
 <20141211123106.GU11764@sirena.org.uk>
 <CAD=FV=U4RFYx9NXOACrXJZK2bKkosyYnmTZRHkXuaSz-FS9kNQ@mail.gmail.com>
 <20141211170934.GZ11764@sirena.org.uk>
 <CAD=FV=WBAuF0+BVMG9rp53Zt851Ou0kZ6xgTe9mjmgxyugWteg@mail.gmail.com>
 <20141212002410.GB11764@sirena.org.uk>
 <CAD=FV=W1r2MXNHXTRiO1pBPWurvgqq+dSoOPgpSJ_zAbpU7T4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UfG5WHkLxnCKLvnH"
Content-Disposition: inline
In-Reply-To: <CAD=FV=W1r2MXNHXTRiO1pBPWurvgqq+dSoOPgpSJ_zAbpU7T4Q@mail.gmail.com>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4] regulator: core: Support trying to get close to a
 certain voltage
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UfG5WHkLxnCKLvnH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 11, 2014 at 07:31:43PM -0800, Doug Anderson wrote:
> On Thu, Dec 11, 2014 at 4:24 PM, Mark Brown <broonie@kernel.org> wrote:

> > I mean the latter - what happens if more than one consumer is trying to
> > use the regulator?  This is IIRC why _set_voltage_tol() uses the cheap
> > and nasty implementation it does.

> Ah, I see.  I don't think I've ever encountered a case where there
> were two consumers for a regulator that actually requested voltages...

> ...but isn't regulator_set_voltage_tol() broken there?  If you have
> two clients, A and B and a regulator that can go 1.0V to 5.0V in .05V
> increments:

> A requests 1.8V +/- .1V.  We get 1.8V
> B requests 1.7V +/- .05V.

> The above could be achievable with a voltage of 1.75V but it won't
> work with the current regulator_set_voltage_tol() I think.

Yeah, it's not perfect but it'll work most of the time.

> > There's also the potential
> > performance considerations for the DVS type applications now I think
> > about it.

> Iterating through voltages is really that slow?  If so, perhaps we
> could add some caching to keep track of what voltage we actually got
> last time...  I could also add an optimization to try the exact
> requested voltage right away...

Applications like DVS get pretty performance sensitive and for a
regulator with high resolution if you're trying to hit a voltage at the
top of the range you could be iterating over a hundred or more values.
Perhaps doing something based on the various factorings out of the
voltage mapping would do the trick, add a new op for getting to the
closest voltage?

--UfG5WHkLxnCKLvnH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUiubHAAoJECTWi3JdVIfQCJgH/2ad10vNHIV3RbLAQPwtVb/e
C7Mv9O19a/rHAaoAKpkSneZtD5cZcx48g3LOW95NTfLyqTiysIcqJ3wK/VgfFgUS
sGJK8yE5XYatuBv2XJKKQNoGeRDkNdg2XCiAVsORQMunHK/qeLmvY2JYXWY63YWA
mzBdHqaffdoyHLR+U7wgi7bmcMmBH6bzqfLFNtlex5pjDK7bCVlgRD5qsfnRqt48
6o3nBJB8kax7PWLpWrEjVMMZ/W6Nb5EtYalMbauchW7VXfQaZa71WlYYj8oAvlB8
RZTk7X7yX7nXPrB+MDMx9Dvt5OLXlw7U3cIxq4GTXi1zH5MgpXM9+6S3vYFF+6c=
=5gW+
-----END PGP SIGNATURE-----

--UfG5WHkLxnCKLvnH--
