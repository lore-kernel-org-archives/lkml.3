Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbaKHJXa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 04:23:30 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51290 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbaKHJX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 04:23:27 -0500
Date: Sat, 8 Nov 2014 09:22:42 +0000
From: Mark Brown <broonie@kernel.org>
To: NeilBrown <neilb@suse.de>
Cc: Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        GTA04 owners <gta04-owner@goldelico.com>, devicetree@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20141108092242.GB2722@sirena.org.uk>
References: <20141108002637.6561.19002.stgit@notabene.brown>
 <20141108003803.6561.42934.stgit@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VrqPEDrXMn8OVzN4"
Content-Disposition: inline
In-Reply-To: <20141108003803.6561.42934.stgit@notabene.brown>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 188.29.164.249
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] ASoC: twl4030: don't report EBUSY if no change
 requested.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VrqPEDrXMn8OVzN4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 08, 2014 at 11:38:03AM +1100, NeilBrown wrote:

> +	int val = ucontrol->value.integer.value[0];
> +
> +	if (!!(twl4030_read(codec, TWL4030_REG_CODEC_MODE)
> +	       & TWL4030_OPTION_1) == !!val)
> +		/* No change */
> +		return 0;

We shouldn't be accepting attempts to set out of range values so there
should be no need for the !! on val (which confused me when I was
reading this).

--VrqPEDrXMn8OVzN4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUXeDhAAoJECTWi3JdVIfQ1XcH/RJqfPlYEBnb4iLaKsPfm8tN
RyoEOUlJYmg//4n3ndaam/M6dllUyR3JXRJq2iaE9ZonUGHdMhtaLSFuJb3UmZsU
9BO6uqYe09HMgZobAsk4YTbu9dzFgVKpZsbFD19n5MpScO2EKnSimUyi9iMBztcN
G+YAQ3feVyAgnGJWIZx4DMWBdZ4ACiCYW8G+G4vnA3unefdMfybPn4LVDN6+ekDh
7YaQ+5K6wMtmLcF5hGsXAhr2vH0FY4WZKUYnCKvO6s2/EX0jP1yegMwe6d+irBvR
LucPyGXjJNGDX2//gUgyuWMfHLWBXp0qDbfvcYD5EWAEonnMyydN19HXkoHJqaE=
=E2Wg
-----END PGP SIGNATURE-----

--VrqPEDrXMn8OVzN4--
