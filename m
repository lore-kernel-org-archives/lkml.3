Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbaCAEHN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 23:07:13 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53896 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbaCAEHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 23:07:10 -0500
Date: Sat, 1 Mar 2014 13:07:02 +0900
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140301040702.GM29849@sirena.org.uk>
References: <c405df11848a40b7beda8d8fe747e7a7@BY2PR03MB505.namprd03.prod.outlook.com>
 <20140228052904.GP9383@sirena.org.uk>
 <1b89016263c84e0297655034a648032f@BY2PR03MB505.namprd03.prod.outlook.com>
 <53102EE4.80702@metafoo.de>
 <d872d0fd60eb4c01b38af98014c802aa@BY2PR03MB505.namprd03.prod.outlook.com>
 <531030C7.2060703@metafoo.de>
 <5d534c2ac77040d9bc373db9e43dde7c@BY2PR03MB505.namprd03.prod.outlook.com>
 <53103787.2020702@metafoo.de>
 <049024c359df495fb8acedd96e574ce2@BY2PR03MB505.namprd03.prod.outlook.com>
 <531045A9.3010502@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Z1Z8UV8BNhgCynIS"
Content-Disposition: inline
In-Reply-To: <531045A9.3010502@metafoo.de>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 175.126.181.238
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH 2/3] ASoC: core: Set the default I/O up try
 regmap.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Z1Z8UV8BNhgCynIS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 28, 2014 at 09:15:37AM +0100, Lars-Peter Clausen wrote:

> Yes, I think that's almost all of them. si476x is missing, but I
> think that one is currently broken, as it doesn't call
> snd_soc_codec_set_cache_io() at all.

Probably, yeah - there were other problems with that driver that make me
question if it ever worked properly IIRC.  There is a default call to
set cache I/O already but it relies on dev_get_regmap().

> As to how to handle those, I think there was a plan to add the
> possibility to assign a regmap to a device, so that dev_get_regmap()
> returns the regmap struct that should be used, even though the
> device itself did not allocate the regmap. But I can't find the
> details. Mark may know more about this.

That's not for this and is likely to create confusion - that's for
handling early init with syscon type devices, allowing the regmap to be
created with no device and then have the device attached later.  I'd
need to look through and see what happens if two devices share a regmap,
perhaps it'd actually be OK, but we can always just allow the regmap to
be overridden at the ASoC level.

--Z1Z8UV8BNhgCynIS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTEVzjAAoJELSic+t+oim9kt8P/iPN9NUjdEMq9T/zn9ANsaQ1
YiVb11Kn+DmU1vmph7wWtGzVhOkznAFh6rpGNbN1BXHqVh8oDHgIOiAA+rj8UKjG
HhOI8P0yk4dRaTpBY7KPYAooJgVRrgZEc/ARla+k6A1EyTB8K7hPdlemMkXgKybC
s38Lp0SMG1fTNZ80LUg45FJ3NrjKLNpA02TBUurE/Pc4FiFh7ofKiUk2aI3TtMBN
poUI7d7FXcnNyVWVVdE+IiCjMQYoF7Urwz9gVePYu8jKjQBr5XRWWt+3/tV5/U6u
0xqEf8l15/fRfSvzMEG7JlRIyELSgQU2vKGyi+y35iVVgjT0kTfjD6uVBwGXoA/o
wAC/BuhhVF8HzNq2hXbTyjeVy4Wp24XxLD7/Zdu7LbxQvJvCqeIhZjPfi7VJAfVE
eigkOSQKqhfAE886pa06l6xtuLDCCVGN/fNDPyNgNOO+tsz5bMd4+4WxWwy3BMkY
Zbq73N2BqpB8T8EV9vsm93s3dFMl2rXeKaFLT+WNRXcFDXg7caVFKFdi5D2fgwOj
9PQ31cCJQ0qvet58ld5NShWQQARaxUJbR+BuIH3KbXH1zVxs9R6SHm2en0LQlYYi
+Pi8SokDX2VoRSHuZMi2E8AQMNqSjvrepqWIZiQ5rt/nwT1YV7m8J6NDr56nL2V+
N5DHKPe94v4nhogSD+2B
=0quB
-----END PGP SIGNATURE-----

--Z1Z8UV8BNhgCynIS--
