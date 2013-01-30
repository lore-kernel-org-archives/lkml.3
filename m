Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab3A3C5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 21:57:45 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39477 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751344Ab3A3C5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 21:57:43 -0500
Date: Wed, 30 Jan 2013 10:57:34 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linus.walleij@linaro.org
Subject: Re: [GIT PULL][FOR REVIEW] Regulators: Bring the AB8500 into the
 20th century
Message-ID: <20130130025726.GG4945@opensource.wolfsonmicro.com>
References: <20130129164131.GN18212@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DNUSDXU7R7AVVM8C"
Content-Disposition: inline
In-Reply-To: <20130129164131.GN18212@gmail.com>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DNUSDXU7R7AVVM8C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 29, 2013 at 04:41:31PM +0000, Lee Jones wrote:

> If you'd like me to sent the patches to the MLs for a better review
> platform I can do, but I'd like to get permission before I go and
> start upsetting people.

> This branch contains 111 patches and has already gone though multiple
> cycles of fixing-up, squashing, splitting and revert removal.

So, some highlights from a quick scan through:

 - Most of the OF stuff needs to go, OF isn't just a dumping ground for
   typing in all the platform data with no thought about abstraction.
   Things like -input-microvolt for example, and the mode switching
   needs to be completely reworked.

 - Send the arch/arm stuff separately, supplies with NULL for the device
   are generally not a good sign though.

 - The -debug code looks like it's all NIH stuff, large chunks of it
   are reproducing stuff that's already there, it looks to have copies
   of all the data defining the regulators that must be duplicated in
   the regulator drivers themselves (which isn't a triumph) and the
   overwhelming bulk of it looks totally generic so it really shouldn't
   be in a driver.

 - I can't help but think this would get a lot less verbose with regmap,
   there's a lot of functions that .
   The no-bus support just merged would make that a lot easier.

 - dbx500-prcmu looks worrying, it appears to be replicating bits of the
   core regulator API for some unclear reason.

So probably no point in posting the series as-is.  I'd recommend
starting off by pulling out the core feature additions to the regulator
driver and the -ext driver, that should make things a lot smaller.

--DNUSDXU7R7AVVM8C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRCIwOAAoJELSic+t+oim9MzUP/jBOgeM/4R4nauZl7796b3sl
aozpJ//UzjV2vvkETxYzfOQ/AbekeqemloOoOWv2jm2X+IahuPbN/qCIT3nwlLRW
48PIwJADF8cnuLDUxsNuBJ8+AXSXsh4MtiF1+OBfMXLVsPuJ0Gmq+cBhCUJkZEaU
Iozai24pGbEEagRqOcN63kDPARNuxYYb500wa0g4jfLcpC6htDj6rPZjo6opAsjw
FBeyLq5qTbG3abzU8SIreC0AX0P8pTsAgS+UJSeMpLPXxjJ2SxavnaffY7A9nrRC
x7ZInZYK7lxF/EtqprfX883ZIm5M7b++VCx7BI+h7leU8i2GJvaidB2RL4l4NMa4
kjxPpRViUb1O4k9HNPvthjUTeiivI7+0laj0rlIZnlynzKMQ2wJ2TUDdmqsuGkvx
cYc6vgNaaw/4BtrnV/46aFq3kbfA9l5sEX+5Xzdk7OSrVZ/R6JLoxaucsI5tLU71
0UX/qNjalTezE6BNjYjf/IyUpUuml2lsxe6Kvxd035c+4DZaaaY1eSK6KkoCMD5A
VlObTgTfeulgqFgQzxR3ewodJlwCUM3m7nHEKUzAUHAKCDQaB9gKWhcMkw26dvBY
g7ICsBQM1kLRQ/gN+HKfHAtV3xlc5POP11dLIPxkYwGYcb9snMrETWJQZ/q7+aO7
vLYfDLlfKym74kiIRHdM
=BlIc
-----END PGP SIGNATURE-----

--DNUSDXU7R7AVVM8C--
