Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283AbaCLBLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 21:11:25 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49230 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145AbaCLBLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 21:11:24 -0400
Date: Wed, 12 Mar 2014 01:11:16 +0000
From: Mark Brown <broonie@kernel.org>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        linux-spi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Chris Zankel <chris@zankel.net>, Marc Gauthier <marc@cadence.com>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20140312011116.GJ28112@sirena.org.uk>
References: <1394541891-26469-1-git-send-email-jcmvbkbc@gmail.com>
 <1394541891-26469-2-git-send-email-jcmvbkbc@gmail.com>
 <20140311194959.GB28112@sirena.org.uk>
 <CAMo8BfLTn+pneF6_7XkP66+LzpZgcefnAo_FkwxpvtYdt9yduA@mail.gmail.com>
 <20140312003401.GE28112@sirena.org.uk>
 <CAMo8Bf+dePYf0jW6zaH-4Qiy5oF-bBzHjkfzL1u6pyTS1OE46w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IaU6t3Sui9pnIBPM"
Content-Disposition: inline
In-Reply-To: <CAMo8Bf+dePYf0jW6zaH-4Qiy5oF-bBzHjkfzL1u6pyTS1OE46w@mail.gmail.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] spi: add xtfpga SPI controller driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IaU6t3Sui9pnIBPM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 12, 2014 at 04:59:47AM +0400, Max Filippov wrote:

> And tlv320aic23 has the following regmap:

> const struct regmap_config tlv320aic23_regmap = {
>         .reg_bits = 7,
>         .val_bits = 9,

> and its SPI interface accordingly does the following in .probe:

>         spi->bits_per_word = 16
>         spi->mode = SPI_MODE_0;
>         ret = spi_setup(spi);

So I just looked again - the SPI code isn't in mainline, there must
be some out of tree patches here that can't have been tested since the
driver was converted to regmap (or the byte swapping you're doing in the
controller is buggy for 16 bits per word).

--IaU6t3Sui9pnIBPM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTH7QxAAoJELSic+t+oim9sAQP/j30vaX/EyFbjLRGQOkM4erp
43sZ823B1uKTDuYgrDq8TxjwpjDCJmUPy1YiUghaJB/1DhrFeRePXDYq9M9d8kku
ld9Y+dCQD+ybZuQKK0ZbGaTyGSsKCVQ/+TZ/hkMDQLwXAhQmcYpIb5/1Cf9765hS
AjdmeHe2CN75XPGq7k0HvWPYjY9zxeJqaWgkorkxlVVjQPQ6U5V8SJrvDSmbaUCv
GR6UBGZNhm3bCIgdLW/IJpwGWWZTThMe3tPHFaruGQyXRNMC0zP6T3rimp/VKP3n
+SkavK8nipAqJOo1eVCiEyCbhBJMZIBAbOLwQE5yQI6qYOIxVaSdtRQHptbqRjPp
ectG//6fUFVL0zHWm1OqoZ0V+mFOW/N4hxXgRjKpxvrbNNAGC1i4hLQ/741PvNIi
aJ0B80y1ttcEjYdYtuklruQ5fxbtoKY70942wM0rle3/vNts7BF2MLhS+m81VfM0
sWWfzBwrYRrOZKebShuiQW+jHKw+s3fRBi3N80U2s0Eq8BDRVmQEB6Ovb+Y+GzXD
eNKOyZv90naZpKS7hxnfVbvQm3y98fen5a2wycTeEoJZdzLcWGSJr1gLX4z+jWs9
FOlylHTujawdnQKsHxjpTVvONY2Bf98PptwCsX8ch0AjpvsE2WwtpbfOJF87IHFz
azfnoE1KaWrCch2nBUl2
=6HCY
-----END PGP SIGNATURE-----

--IaU6t3Sui9pnIBPM--
