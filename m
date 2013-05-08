Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab3EHNy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 09:54:27 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40033 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383Ab3EHNy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 09:54:26 -0400
Date: Wed, 8 May 2013 14:54:13 +0100
From: Mark Brown <broonie@kernel.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Message-ID: <20130508135413.GR7478@sirena.org.uk>
References: <1367997261-32048-1-git-send-email-fabio.baltieri@linaro.org>
 <1367997261-32048-4-git-send-email-fabio.baltieri@linaro.org>
 <20130508105124.GA7478@sirena.org.uk>
 <20130508114216.GB29130@balto.lan>
 <20130508123225.GK7478@sirena.org.uk>
 <20130508131020.GA30503@balto.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="azZrKF05zqlgub2L"
Content-Disposition: inline
In-Reply-To: <20130508131020.GA30503@balto.lan>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 212.183.132.60
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/6] ASoC: ux500: Drop pinctrl sleep support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--azZrKF05zqlgub2L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 08, 2013 at 03:10:20PM +0200, Fabio Baltieri wrote:
> On Wed, May 08, 2013 at 01:32:25PM +0100, Mark Brown wrote:

> > I'm saying that if functions like enable_msp() don't work reliably then
> > removing some but not all of their functionality isn't an obviously good
> > approach to fixing that.  Why does the other functionality work well but
> > not this bit?  It sounds like there's some reference counting bug here
> > is all...

> Yes, it started as a reference counting bug, due to the actual counter
> not being shared between ux500-msp-i2s instances.

> That said, the actual fork of this driver deployed by STE internally
> does not handle I2S pin sleep state, and I was not able to find any
> other ASoC driver that does that, which seems reasonable to me as I
> can't come up with a reason to put those pins in hi-z anyway.

But why does the rest of the code work well if the reference counting is
wrong, it's in the middle of a big block of code?  This all smells like
this change is papering over a specific symptom of some underlying issue
- if that's not the case then it needs to be clearer why.

> If I understood the problem correctly you do that when you want to cut
> power completely to some peripherals to avoid spurious current paths,
> and that should not be the case for the audio codec, especially in this
> case where it's part of a big multifuntion IC.

Being a MFD should have nothing to do with this?

--azZrKF05zqlgub2L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRilkCAAoJELSic+t+oim9RxMP/iNvYxtpQOGX2VZRTtYh+LBJ
+LQ2wJ3ENPH9heZQZ4caOQnEACpV4+tMUgfORw3lSwBibtHzkGK0Sdz2fDFiUB6i
0fvQbH3KE2Q/0ScjnEPlNxtIJJOTLAd684yu0oQeO7fS4OIpA2a/6WAaFLpabYr0
1ShScZ/yxdD5u5bLvJFZy50AtHGfw0aSv3p5iL2MGgKY8JtNo3kX2m5KE3pj4CkF
ECzr8a/N69YnMuLrTJ/QkHqfK48xquNHfZ+WJ/hLdVyEcz9BnbtSut8riIbbs3YU
eca1VPoLH3eGgMGoCRNC1GxzSNCUTWulorRqhEhT8bfO38fXU7l3Xxkf3vU1zeEt
6MGbqaAliu9IYcGqVL9ugjqy8hs+qLI9DOfxyx7KkYUgaEM7aL5HUT1ie4tvdWzH
rCJ6L05vh6wWjPfcHeX1fKtiNHrmlL8t+/1EorGPiThuyNOXFPF4StDbWhM7W9OS
x7QLTSmW9x3zYxA7cBnA7lDPJhDIVvPkyEaamvSaw3sQAh2s/gyh/jwVfGBXZkIK
ScwIvUbtepEduK7/TVXK2hpPLzMCTLtWLtDsN2DGzPvct+exKNeluogj3mD2Zb3q
Xye6Iaip6HeRCX4hsXRyg1Of6JlbRXBVTCgXIWvZ7FIzSbiiUdffu3yTr8Vuqb6g
FRTco79dRbD72vBrlSo/
=Y8+r
-----END PGP SIGNATURE-----

--azZrKF05zqlgub2L--
