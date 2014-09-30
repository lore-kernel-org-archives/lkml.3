Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbaI3R0D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:26:03 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55096 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbaI3R0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:26:00 -0400
Date: Tue, 30 Sep 2014 18:25:43 +0100
From: Mark Brown <broonie@kernel.org>
To: Dan Murphy <dmurphy@ti.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Message-ID: <20140930172543.GG4273@sirena.org.uk>
References: <1412093220-24690-1-git-send-email-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="df+09Je9rNq3P+GE"
Content-Disposition: inline
In-Reply-To: <1412093220-24690-1-git-send-email-dmurphy@ti.com>
X-Cookie: So you're back... about time...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: Allow read_reg_mask to be 0
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--df+09Je9rNq3P+GE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 30, 2014 at 11:07:00AM -0500, Dan Murphy wrote:

> -	if (config->read_flag_mask || config->write_flag_mask) {
> +	if (config->read_flag_mask == REGMAP_NO_READ_MASK)
> +		map->read_flag_mask = 0x00;
> +	else if (config->read_flag_mask)

This breaks the symmetry in handling of read and write masks which isn't
great, please make the equivalent update for the write mask too.

> +#define REGMAP_NO_READ_MASK		0xff

An actual out of band value might be preferable here though that'd
involve changing the type and more checking so perhaps inessential.

--df+09Je9rNq3P+GE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUKueWAAoJECTWi3JdVIfQj/UH/ihlFG5agQ2kSMwNkBZFRWvo
6f3JAZdUMk3ShLcTN3/Ftld5ml3yBccfPUMgtqTuqVuNpByHc3eklpwVj3deBvsQ
19x4rxLrOdWXVa6i8SL9yihubBtFKUluC5ZptmpNEUQUcHjiy4vr64dzNrJoF+5F
gugYeXI18zXkKQb1soi2Q5N1A9jPIduQpZIfgpSSIJEVR99Ud3f8jM2Kl8/EbI4s
U21kxwrNxwpFbfM62MetyMdHYpOU3jYhDEYiAXOp8yWLlvE5JwDMGC0bCVdF93ZR
b5Sz0OAMfjrnfuc5Uw2AtwrldKYcWasoVhZUuP2nqHOR9Uuf6X8Rpm8EX+HQP9U=
=hVyD
-----END PGP SIGNATURE-----

--df+09Je9rNq3P+GE--
