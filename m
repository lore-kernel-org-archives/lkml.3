Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbaL2PlC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 10:41:02 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54202 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbaL2Pk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 10:40:58 -0500
Date: Mon, 29 Dec 2014 15:40:30 +0000
From: Mark Brown <broonie@kernel.org>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, linux-ide@vger.kernel.org
Message-ID: <20141229154030.GJ17800@sirena.org.uk>
References: <1419614799-5770-1-git-send-email-gregory.clement@free-electrons.com>
 <1419614799-5770-2-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ss+0cqQwq/UQoUvX"
Content-Disposition: inline
In-Reply-To: <1419614799-5770-2-git-send-email-gregory.clement@free-electrons.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 86.128.155.20
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: core: Add a sanity check on the
 regulator_ enable/disable functions
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ss+0cqQwq/UQoUvX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 26, 2014 at 06:26:38PM +0100, Gregory CLEMENT wrote:
> These two functions use the pointer passed in parameter without any
> check. By adding a NULL pointer check, it allows using those functions
> from a driver in a more generic way. It is useful especially for the
> disable case if the regulator is optional.

No, especially in the case of regulator_enable() this is deliberate -
we're trying to ensure that if people are using regulators they're being
careful about it, checking error codes and so on.  I'd really want to
see some persuasive use case for this.  What you're saying here sounds
like the consumer shouldn't be treating the regulator as optional at
all but should instead be using a normal regulator.

--Ss+0cqQwq/UQoUvX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUoXXtAAoJECTWi3JdVIfQQ4YH/10bXMdYTF9pD3MjYdT2VlcU
gQ9jHKyxXu+vZIhuVGBfu6OOcJKCe5ZjSTK5keH9C5lyb+IZ4zMrBp1pHRei1BcT
l16RNYX9GuLzbRUHSY3bijzUs+JJlznMOdI7PKYkoKGLB9gsGYe9tM0O1xvh3z7C
dKBHNim+G9/Y4ftpS338CqQvzJbsWOjNph7WSnUoG4Ah92BVP2ecjXibwm8Rzie6
vd1g1twz6J3McjYTzlG40sS0/tdGkV7VFHWoq0sG5yfVwGTzdmb0FN8KXrigtnBb
H0uqrR79Dp1UfT/DCnLR2e5LprUYJaVIdE7LttWkD/X/SeaDkMYFnSmUxtSIILQ=
=u9aP
-----END PGP SIGNATURE-----

--Ss+0cqQwq/UQoUvX--
