Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbaBGM6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:58:48 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37803 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbaBGM6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 07:58:43 -0500
Date: Fri, 7 Feb 2014 12:58:31 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Guenter Roeck <linux@roeck-us.net>
Message-ID: <20140207125831.GL32298@sirena.org.uk>
References: <cover.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
 <6a398d176b0b2bf8792d27bd5e2995fd96afb32d.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
 <20140207105657.GL14727@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+IojnoBMdP/qo3gc"
Content-Disposition: inline
In-Reply-To: <20140207105657.GL14727@lee--X1>
X-Cookie: Take it easy, we're in a hurry.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/8] ASoC: da9055: Fix device registration of PMIC and
 CODEC devices
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+IojnoBMdP/qo3gc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 07, 2014 at 10:56:57AM +0000, Lee Jones wrote:

> > +/*
> > + * DO NOT change the device Ids. The naming is intentionally specific as both
> > + * the PMIC and CODEC parts of this chip are instantiated separately as I2C
> > + * devices (both have configurable I2C addresses, and are to all intents and
> > + * purposes separate). As a result there are specific DA9055 ids for PMIC
> > + * and CODEC, which must be different to operate together.
> > + */

> I'm not sure this comment is required.

They are, we've already had the suffixes removed from both PMIC and
CODEC drivers by people doing code review causing the drivers to fail to
load for several kernel releases (this should be tagged to stable as a
result).

> Most device IDs are named this way.

Having the suffix on a subdevice would be normal but it's not normal for
the primary I2C device, usually you can just put the part number in.

--+IojnoBMdP/qo3gc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS9Nh0AAoJELSic+t+oim99loP/ij+WZiRpWPTJR3oSmGFkKko
p89l4D93sB+ovRJaq8g6Rs7+ArknmFv8UW7UcAuTPWS1P99JAJi9+XSmLhz7i2rB
bwWPIFPnwb8UMR1OeVlb8Ph2Ej+5CC4iPctoeaWsxPvNnrVp0bUiY0sGwLK/Z2hQ
PhVQFH1OgcPMK48ISHtOaT1ENDWWS2znF/Aj9FY4q4zgMym/2eAGezxoDH3Z7H+w
7Bvzy6W6azWwmqPR+0MRzkwu3JjUCrt2fOBfVclGs8XEuUHENNqyDND7/uuv/Ny7
AQwRa128efWSovKbE89uGiVG/crvjdslFrf+f3AsxVrsAWWNeHtzcs3eEF+HMDOa
HOMquXXCEj4xJjcjqgynO1KVywjkPu1PJneQ2hINVvB4rf5ci+ByvBkRUpJd+tIF
pIpOODsmUICpJYZoyZE6V0SH2RgPjYkIYE5a4kfe9K7JM7KHQNT8nHIfNZm9rYqc
HxGVvh7q0BHLevFFk/ka71wNWbR0yZ9Iw5NNWQbxwwYLBPeAOep/BhOTVZ79bpbL
Xnu+QU1BlnYmmm9BuqYPHpASFrI/kRVxqLk6X2PEvFytvXUqCUJmc4U0KUeko8Z3
zn1/gBhH+B0pV9FjvSMeL4Y/ZR6jDGy8W2pQDHoYefGxWpYFaRZYDVvkxKQZLYHm
kwzJGtJZpfxmBfBD2TGh
=DYFT
-----END PGP SIGNATURE-----

--+IojnoBMdP/qo3gc--
