Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbaAZWCQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 17:02:16 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59770 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbaAZWCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 17:02:15 -0500
Date: Sun, 26 Jan 2014 22:01:26 +0000
From: Mark Brown <broonie@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Jean Delvare <khali@linux-fr.org>, LM Sensors <lm-sensors@lm-sensors.org>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Wei Ni <wni@nvidia.com>
Message-ID: <20140126220126.GM11727@sirena.org.uk>
References: <52E561D0.4040308@roeck-us.net>
 <20140126211357.6fa68909@endymion.delvare>
 <52E573B6.9040903@roeck-us.net>
 <20140126205216.GJ11727@sirena.org.uk>
 <52E5825D.9090104@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eUGqGfkt69yEwRle"
Content-Disposition: inline
In-Reply-To: <52E5825D.9090104@roeck-us.net>
X-Cookie: Please ignore previous fortune.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: lm90 driver no longer working on PCs in 3.13
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eUGqGfkt69yEwRle
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 26, 2014 at 01:47:09PM -0800, Guenter Roeck wrote:

Please fix your mailer to word wrap within 80 columns, I've reflowed for
legibility.

> You have a solution for that in dt configurations. I don't think you
> have one for non-dt systems - you simply assume that all regulators
> are there. For dt, you even have a constraint to tell the kernel if
> regulator configurations are fully specified, and you automatically
> return success if not and if a regulator does not exist.  So you know
> that there is a problem. For non-DT configurations you simply assume
> and expect that regulators are all declared. I don't think that is a
> feasible approach for non-DT systems.

To repeat the mechanism that's there for other platforms is to either
flag that they've provided full constraints or provide the supply
mappings.  This has always been the case, there's nothing new here - the
only change there's been in this is that in v3.13 we refactored how
systems using DT flag that they have full constraints.

I agree that it's not going to work terribly well if neither of these
things has been done, it never has done and that's why the API has stubs
when it's disabled - they allow us to avoid a hard dependency on it in
drivers so people only need to turn it on if they're actually using it.
I'm very surprised to see anyone doing that to be honest, if you're not
using it it's just going to waste cycles and RAM.

--eUGqGfkt69yEwRle
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5YWzAAoJELSic+t+oim9OCEP/jvQujHqAnGkwS1uUkl8qMzN
WMvnr8xicGWxEb6IN6SrfdgROA9xg3J/X1zQ4YBOwt1JnG8cj4CJnvXPwZkAk/T5
5/e3b2cJQ/HqM6CO54wgYilw2xB1Oai0LusMkN0nkkpLG6JiYuqF6y6CqZMjIBxC
A8gvQGHh2/agMf4UXKBgZRbryD6S7NMGoyHxzIGaW4SJJqHBRrH6LYl+FnHkN11+
nQMqPD2ORSLKtls4XgKTGlFmcGeOJCNRIY50nqZgA8deHKCnlCQG/kpGxIFF8ehz
yhrYXCksJPulm+B0zqHWS5K+SrdVfSRU8Z3tQaMDM2YGjLbEBNXBTxAGn0kWo6e4
y1HvTdaPQmGAbGGVQ6P2BGdoo1SECEYGxp8x/x9Vfp6iPPZs5wgGbKV50mAHnwTy
SVCP96UzX1AOMp1eT2JrvZ5SG0ynNFX7bZjYuOAI52RjyBlTQ3kKGGR0cYJQfDms
7f5wOHp+gftN4ALzDRUhqRd9JNC3Dk8uF58kHeofq9RSpiL6gN9JgRCABEhS2F7B
UFQy2h0NJ+hFtw6IdtDmoYOTEl4efqwO/wpj2eMeMdHZwY/LSOv3ZSj4XjowChoU
p8F/ImYtUecP44pBYi8cO3+6WNxsBO3GLnTULftC+paTWo1Cqnuj9fqKX4ieG+z3
bTb4Nq73DsKiDHhgn1iF
=9khg
-----END PGP SIGNATURE-----

--eUGqGfkt69yEwRle--
