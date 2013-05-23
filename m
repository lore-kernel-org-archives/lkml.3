Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604Ab3EWOJE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 10:09:04 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51171 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694Ab3EWOJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 10:09:02 -0400
Date: Thu, 23 May 2013 09:08:56 -0500
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Davide Ciminaghi <ciminaghi@gnudd.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org
Message-ID: <20130523140856.GE2412@sirena.org.uk>
References: <1369314377-22873-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KlAEzMkarCnErv5Q"
Content-Disposition: inline
In-Reply-To: <1369314377-22873-1-git-send-email-lars@metafoo.de>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 144.188.69.1
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regmap: regcache: Fixup locking for custom lock
 callbacks
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KlAEzMkarCnErv5Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 23, 2013 at 03:06:15PM +0200, Lars-Peter Clausen wrote:
> The parameter passed to the regmap lock/unlock callbacks needs to be
> map->lock_arg, regcache passes just map. This works fine in the case that no
> custom locking callbacks are used, since in this case map->lock_arg equals map,
> but will break when custom locking callbacks are used. The issue was introduced
> in commit 0d4529c5 ("regmap: make lock/unlock functions customizable") and is
> fixed by this patch.

I've applied this but can you please also generate a version that
applies against v3.10-rc2 since this should really go in as a bug fix
but the patch depends on recent changes in the regcache code.

--KlAEzMkarCnErv5Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRniL1AAoJELSic+t+oim9T6MP/3eYDhqei4coTPgMH+3hkU+a
RouCxbHORN1xsg/QYCpv0I6GhroUEUanjU4T2IdDLwnEYyIMalnlEb/xHOdft704
CWWXadV75jC1I9OrGNiuXSINsOzbQuJ97fccDfj+0kA/J7NF0uqqa17ObROcKGBs
kxDFA/TaHdW0+bkGdDSxaxJv2tBJm6V7Hxu1+0U9y6CJzFeB/yv8icJhc9zSF+mP
ONTJydVQIteKLHQXBB7tK2YZnwwTQ1jtCbstuOhUUrvGIaXeics9LOzKVx25M+wF
sTIYT/G8/pMhEoXh7Lf2U8PLkieBWiuQ73myY/vRGt1owML/xToqtVUqLXLVEmY3
BbvvHtbBT+nHq3BY9uipiymSOMHFrocALEgI6dA6fAKeW075YR+DPnslaegEFlQa
yw2zBEC2huriIBQRs2oCCZ3SDRDAt/WnfrbfiBxZUNfXxVNRfOnWPRW1TZ9QE00N
Zza+S4xkkOzMietz0Q4h2gsZj5jgVYGSkoAaaH/NsXR+SDM0+ESqHsELBi/uaQvK
ifANp6WNYxhIICvltsFBocQFlMcdjt88rji7vKmwbFYw05CgQ70j6KKrJwIbu1r9
snRHOoI2qpNtXRzRY6IFbnDLXA13DEOwP47FpZlk40Q2RxPOMe19UZ16YsaI/Z3p
SVQrtgLwLxdtdryuKFHe
=C6n4
-----END PGP SIGNATURE-----

--KlAEzMkarCnErv5Q--
