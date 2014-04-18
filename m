Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbaDRRYQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 13:24:16 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38102 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbaDRRYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 13:24:12 -0400
Date: Fri, 18 Apr 2014 18:23:58 +0100
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Message-ID: <20140418172358.GO12304@sirena.org.uk>
References: <1397565276-31288-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ApjBx6AZ5mqANisx"
Content-Disposition: inline
In-Reply-To: <1397565276-31288-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: Use devres for releasing
 of_regulator_match of_nodes
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ApjBx6AZ5mqANisx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 15, 2014 at 01:34:36PM +0100, Charles Keepax wrote:
> Rather than requiring individual drivers to put the of_nodes returned
> from of_regulator_match use devres to put them. This also has the
> benefit it makes the life-time of the of_nodes match the lifetime of
> the init data also contained in the of_regulator_match structure, which
> seems more consistent.

Applied, thanks.  It'd have been good to have explained that we were
already using managed allocations - allocating things without an explict
method for freeing if required is normally bad form, though it's
harmless and like I say already done here.

--ApjBx6AZ5mqANisx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTUV+rAAoJELSic+t+oim9wfEP/iALHr82Ilv5mr6r5vC8/2La
FBfovTo4Y25KjNFXKVDynCyZzOStVcFqeJto68jRr4DoPRHRcfASRB58Mbcb2rkg
NvUx+7BvZtTQ9tXnjRgfGmIHA29tRrOzvrADCWwYdmR2+MKasCmJNWilTSt9k6OG
9Ww3uGin57ziGgMkdLHb0m5kIAncLl9DFDdXgE1tR7xRXYY3fnVPqDgtlFgAksBS
pEaIDHp/yYzSjMm3OT8BuOzorv3KvMvjHdRItg0MEj7iHb5JhgDVzI6Ivc8e360v
w+s/jLAsxTpA1oeJzrdCCN3XZ2ouo99lPVrngv35G1c+TAFJ+eTjd7Gz1kt4j+Ap
xp7WuiUyQ63rfpcy+M6OY9DUoxyMXJP/VQOznlpZUUMCeC8eqRhxbKNeci7FavjI
wRxwLBbkcaiNJNYVfgG1c8xf7snpmrTJEjnCWYZYsFpe78cRkVZrd2cdNDf9C2so
pe4/fGbrmIleXLaBuw/aEIxil6BIJFrO9IVz1paasUkrLMsrvDDMH7+6QgSNJYzM
v9Vbo0sKqlLRAKHrDbyJT9IfE9Ldw9CwPysodhYOYY1SFb5FXbySU5o9iGaFGC/K
wcEBcFNU7R6CIuYaoFuhFHlwsbUj63th/lmNhJzHZUNM015IZRPf4p7JUZjDWK4P
C1iXT0vKqP5/C/YcZ+fB
=uzll
-----END PGP SIGNATURE-----

--ApjBx6AZ5mqANisx--
