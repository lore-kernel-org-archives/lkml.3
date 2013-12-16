Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab3LPVCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 16:02:19 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40348 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab3LPVCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 16:02:17 -0500
Date: Mon, 16 Dec 2013 21:01:53 +0000
From: Mark Brown <broonie@kernel.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Srinivas Ramana <sramana@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20131216210153.GA3185@sirena.org.uk>
References: <1386718523-2587-1-git-send-email-sboyd@codeaurora.org>
 <1386718523-2587-4-git-send-email-sboyd@codeaurora.org>
 <20131210235000.GK11468@sirena.org.uk>
 <52A7AE1B.3040201@codeaurora.org>
 <20131211005106.GL11468@sirena.org.uk>
 <52A7C0C3.2070805@codeaurora.org>
 <20131211132729.GT11468@sirena.org.uk>
 <52AA42FD.4040503@codeaurora.org>
 <20131213104128.GT11044@sirena.org.uk>
 <20131213213707.GO21983@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9Q79yvCDNTHf0qBd"
Content-Disposition: inline
In-Reply-To: <20131213213707.GO21983@codeaurora.org>
X-Cookie: Yow!  I threw up on my window!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/8] regmap: Add support for using regmap over ssbi
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9Q79yvCDNTHf0qBd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 13, 2013 at 01:37:07PM -0800, Stephen Boyd wrote:

> I came up with this (possibly ugly) patch. It works for my
> specific case but I'm not sure if unpacking the val bits into an
> unsigned int and passing that to _regmap_write() is sane. What do
> you think?

It's not lovely but it's about as good as it gets.  I'd probaly just
drop the raw single write case so it's simpler - just either raw write
the lot or write a register at a time with unpacking (and so refactor
the the loop that does the in place formatting into the raw case only
and not bother for the single write).

--9Q79yvCDNTHf0qBd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSr2o+AAoJELSic+t+oim9QKcQAJnlulAIeCsbeSFd2NL9RpbI
YniDalJ3zz/XHRnPq2zggbdaBDRDuzia/tRY+OR+FmAhKPPjQHDgQc7kwt3LvjV5
Fie3APrh9Pz1pUJJDjX1THhIqyZrwErxlm12mLAEUsAFcs6P2cqe25+EQ73UojUH
TLhIa7PUfolq71sdiI+vk3sdrqPob+rrAw9yFoghbrxpwpFLKFa/TNXl+bZDN1Ed
od3mK4O3a020tmI8YH8aEllAd55gUBp23AZhxSwsBxGeZIif+p9OUUdM0zWjrUtV
oJFPqhbWb5XgGv2VHi7+XpmyI2lopxQlPzvOTJBuaL3xWvDdVlizaVsoh8OU1ww5
rbXH+7Q2YEBBwyLeeqjz0aP4Nr0LHvNGW22EVjowZRj9C/QdBKRs4+oIOhbxOTot
furJQdsj+mwreFRffP2fKcT9PGmy8AmRK3Ip8ncGXeJYtdeutFJKOuSMwv+bAF17
ltL1ql/kg1MuvyNJ/bbVpgy9irm283fhpFGrlYpcH230js4vgExmTqXjHms5fiaO
cDyxtvUM0iy7joULmDQomhIDj+qlvlpjJmpSkbJgw88uXwDA3/WrvYwmPzaxEDau
IyiBe8SH/8akcQfDpdXSNfdf9Tg1EB/cvX3bq2qH+HxaZ9iGlJzHtZnm9r7W9XOY
dvgKP95pgHJWYj4h0RNx
=prbv
-----END PGP SIGNATURE-----

--9Q79yvCDNTHf0qBd--
