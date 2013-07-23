Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798Ab3GWRQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 13:16:56 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36014 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756760Ab3GWRQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 13:16:54 -0400
Date: Tue, 23 Jul 2013 18:16:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jean-Francois Moine <moinejf@free.fr>, alsa-devel@alsa-project.org,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@vger.kernel.org
Message-ID: <20130723171650.GJ9858@sirena.org.uk>
References: <20130723104615.3696f1a9@armhf>
 <20130723123444.GW9858@sirena.org.uk>
 <51EE7E1A.3040301@gmail.com>
 <20130723132016.GC9858@sirena.org.uk>
 <51EE8591.7060005@gmail.com>
 <20130723150150.GH9858@sirena.org.uk>
 <20130723151956.GX24642@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IqkiyIW+g96++y1l"
Content-Disposition: inline
In-Reply-To: <20130723151956.GX24642@n2100.arm.linux.org.uk>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH v3] ARM: kirkwood: extend the kirkwood i2s
 driver for DT usage
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IqkiyIW+g96++y1l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 23, 2013 at 04:19:56PM +0100, Russell King - ARM Linux wrote:
> On Tue, Jul 23, 2013 at 04:01:50PM +0100, Mark Brown wrote:

> > Why would platform data have anything to do with this?  To repeat again
> > the way the clocks are mapped should be totally transparent to the
> > driver requesting them, if it isn't then the driver is not using the API
> > properly.

> Total rubbish.  Of course the driver needs to know what the clocks are,
> so that it can program its hardware accordingly.

Of course, but why through platform data?  Though reading your mail I
think we're talking at cross purposes here...

> In this case, it has always been the rule with the clock API that it
> shall be used as:

> 	clk_get(device, "internal");

> to get the internal clock, and:

> 	clk_get(device, "external");

> to get the external clock - or whatever names are appropriate to name the
> clock _inputs_.

This is exactly what I'd expect, yes - but it doesn't need the driver to
have platform data as far as I can see.  As you say the driver should be
requesting the two clock inputs the IP has by name which doesn't need it
to have any platform data, it just needs code like you have above.  The
board specific configuration is all handled within the clk_get() calls.

--IqkiyIW+g96++y1l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR7rp/AAoJELSic+t+oim9lx8P/A6zd6JnPW1PT7sNnz28wjlj
nI6vbPOYAwmpEUFWj82LUBUYAYiPMFa6hdZ0CHjwgiMnOunuIW+nYnuDJ4RTfdxF
TeMH+4VJygPNefIGnOTjRr+V+Lh1zeH2lP/zo3CzmS4c8MoGDRV+HN+A45qZ0XO0
3WfVv1hL2fyw/+3hEdE+4tuJ1RcxS4P+GCXCpqCeEQA/aPgt923PQtIWpH0/5306
11MnyYvaxy236SAicTKem/JabvwsdJ2yjEBjXgZoAG2HnMuqkSrHLsDHwA+kES8W
mRd7aXfT907Mxxvcs6pM4n/kon59TAOevIt2M4oEktFHz3E0L5hXxVGr5iDmNjRg
AtZohC5rqLzsoc/n5yVQs8rdmDDaxsYTbBbN2iV4FxKUhYut6H3YR8P9tdfzECaK
P7Rnt9HNvfMUoNtQcMr2DOamn5reynxZJwOIg157uR/jt0/UeaPd8U3uRs/gOyEv
LgrgPo8SIgbCvacNHujUolIWCYxCLgBK6jL9WxPiJEeL9YvxLU64yeYTRaaytyPi
4NT3NjqkOPLS4OlJnLDRunogj6iwFMxYBZsxo/rbF9FW6h66c2LtAe+AC1AgZCX9
+hsKjoR4hH5FH3mmMGGxCOpBV3zY1uE2xeks1sV7YcUuNawEzEJpnjba2UcC3tXs
pVSgHLdYAUPekmlEJrMJ
=ba8D
-----END PGP SIGNATURE-----

--IqkiyIW+g96++y1l--
