Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbaBLPuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 10:50:25 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40873 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaBLPuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 10:50:24 -0500
Date: Wed, 12 Feb 2014 15:44:14 +0000
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, dmitry.torokhov@gmail.com, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Message-ID: <20140212154414.GW28112@sirena.org.uk>
References: <20140210110536.GB6856@opensource.wolfsonmicro.com>
 <20140210120803.GS1757@sirena.org.uk>
 <20140212112409.GD16684@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cbsCxbAnPLQXdgdB"
Content-Disposition: inline
In-Reply-To: <20140212112409.GD16684@opensource.wolfsonmicro.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: dapm: Add locking to snd_soc_dapm_xxxx_pin
 functions
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cbsCxbAnPLQXdgdB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 12, 2014 at 11:24:09AM +0000, Charles Keepax wrote:
> On Mon, Feb 10, 2014 at 12:08:03PM +0000, Mark Brown wrote:

> > Unfortunately the fix needs to be in the callers to some extent - there
> > are situations where you want to do atomic updates of multiple pins so
> > that we don't end up bouncing the power up and down too much, we need
> > the unlocked version for things that care.  This means we need to at
> > least preserve an unlocked version and translate those callers that
> > might care over to it (not sure if any of them are in mainline).

> There are indeed none in mainline at the moment, or at least if
> there are any they are not holding the lock at the moment so it
> is not obviously they require atomic update.

Anything doing this off jack detection probably falls into that category
so the core jack detection code ought to be doing a bulk update.  For
safety I'd say that anything that's doing multiple updates at once
should be assumed to expect them to go through together (that is the
most likely outcome after all and the whole update then sync idiom means
the code looks that way).

> How would you feel about adding an extra functions that allows the
> caller to hold the lock and adding locking into the DAPM core for
> the existing users? Feels like the intention would be more clear
> and will allow out of mainline users requiring atomic updates to
> still do that.

That was roughly what I was suggesting, yes.

--cbsCxbAnPLQXdgdB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+5bLAAoJELSic+t+oim9/4MP/A+0jGucB4EKFe296N/4qHer
yY8MtRk9PZso7v+hf72I/ta7Qdvl2VE0Fz4e6RiCUn3m0LiHnEE8FNX25Qy6WgJK
9aDVZkMx1su9Kx8heCT2yPXlQX4w91XM/92CyT/Iz/to83GEssat9dXXXPKo56Z0
yQHQ7oj7DVO1BRrPnuofaMjn6MknjWkqNkQ9AbaND4b5DeGL4zlUmrE30qCTLtNH
zJwJs5b4Vs5ixJpNSNI7uQKXWC5WONWoLyUDjFRAiZV1eEGNGg1+ThHFW/oHKq9/
uNOZCmvIRtkOxd4X5XRZTWE6ljSHPGvYwEdncrRmi5/3t5iG9TkGAvBAeJ8coRCU
poLQuuRW9IHFw7khdNLMdbQ+CfxAlaVNgmJdBEemzP+DNbi7N2HqM/1boVmhO5kf
IhsczHx026qS0mZQ6QaDLAtMhglpvDzt8ajb37oOlkFFWrmpSr2kJYJMM44Huaq1
2I7DIbsj0rmC04tRwFJrgQ9M0Rh2KPYnHuVCCF8C/hW6jwz4QsJauMGF6wU/ZA85
RVqe3dOHnC2smnmcL79YyUIbSpmPyyVkoLkEOPhfUFISMcypU2tHGyCHrH4ZEMk6
NWaMOpJzJT61HuFCmaJscUdFSXpc8mLqJLDbZ4cWJWcbryb6UF1yaN6WLrZxcSJH
H9OiCziX+PWUumJnlJpD
=rv9+
-----END PGP SIGNATURE-----

--cbsCxbAnPLQXdgdB--
