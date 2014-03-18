Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbaCRRo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 13:44:57 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39118 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175AbaCRRo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 13:44:56 -0400
Date: Tue, 18 Mar 2014 17:44:30 +0000
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org
Message-ID: <20140318174430.GI11706@sirena.org.uk>
References: <1395163353-1608-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1395163353-1608-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9nxfG+mZwdJSiAE"
Content-Disposition: inline
In-Reply-To: <1395163353-1608-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/5] regulator: arizona-ldo1: Move setup processing from
 arizona-core
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/9nxfG+mZwdJSiAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 18, 2014 at 05:22:31PM +0000, Charles Keepax wrote:

> -	/*
> -	 * LDO1 can only be used to supply DCVDD so if it has no
> -	 * consumers then DCVDD is supplied externally.
> -	 */
> -	if (arizona->pdata.ldo1 &&
> -	    arizona->pdata.ldo1->num_consumer_supplies == 0)
> -		arizona->external_dcvdd = true;
> -

Actually now that I look at this again one issue here - the reason this
is in the core is that if the system is using an external DCVDD it may
not be building the regulator driver at all (it won't do anything at
runtime) so the flag would never get set if it's done by the regulator
driver.

--/9nxfG+mZwdJSiAE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKIX7AAoJELSic+t+oim9K9wP/jknCGlq6W+OxajfxFOUZErH
di0qCNMSmA0vgj50wVHnB80Gol5ofqKKH0TZbeJwDjzSpyF6Y8VrNaY+EX1PY/cW
zQ5KIKUJpDzmgBhUmsnSL6jnW5veWqTXMeUSNOFtNFM9Epvg7oyzM4Ij9WTGkPLR
cuIaLvrg15atU64izC2Au/+zH5Jmy6NnPFvfEIM0Ok7jKRr1H2cuRFU0Tfz8o4Cl
TzPbzHWVDZ/zX2S4/M68Tx8JPU931xwfYmvRPs3Rdto7dDceX4TaI+7CARcIH5st
KR2laEl4XCNgLIEnEwnaJLd8eotrJwSRpZ2blFmhg2pGgBDemuTkl+cv5vIt4ih3
rBmjl0+z36RuTa5ooF4bre0AqTcEfovRIxsXon5yKosM39583FS38KYY6uxDhC0o
qFbaRg+NticXRrRmmLSd1/Ik4pOQ4pDM2ySlnR+0PWcuoJpRotigyBKsCE1iPKkh
fDe9oToqyebhFnE7vbGGoFf7oaXMYYqyzFZ/HRGPu3C2o2xukHdV7ioa2tWezKe9
2gnUaewx8ykfu7pCBU8dM0jfpGVwtS4PHB+zqPz0ZhxCausqvxmRmNPP+P4rL6Me
TOmUzQcbfG+lHDPCcUYwaBnBia0d6RJu9EJlByUJQHjSpVdwTV68wfmThVfm93dB
1gub+KeuZzAN/SV3/rmc
=/GnO
-----END PGP SIGNATURE-----

--/9nxfG+mZwdJSiAE--
