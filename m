Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003AbaLVO1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 09:27:21 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43998 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839AbaLVO1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 09:27:20 -0500
Date: Mon, 22 Dec 2014 14:26:36 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Jackson <andrew.jackson@arm.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141222142636.GT17800@sirena.org.uk>
References: <cover.1418826016.git.Andrew.Jackson@arm.com>
 <2842090b2c7a8a98aed0cfa02addcef0b2e8ec6b.1418826016.git.Andrew.Jackson@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zpd1bWBxfrI+71+6"
Content-Disposition: inline
In-Reply-To: <2842090b2c7a8a98aed0cfa02addcef0b2e8ec6b.1418826016.git.Andrew.Jackson@arm.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 31.51.36.65
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 5/5] ASoC: dwc: Add documentation for I2S DT
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zpd1bWBxfrI+71+6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 19, 2014 at 04:18:09PM +0000, Andrew Jackson wrote:

> Add documentation for Designware I2S hardware block.  The block requires
> two clocks (one for audio sampling, the other for APB) and DMA channels
> for receive and transmit.

You should generally include the binding before the code to parse it,
both because the binding is required in order to tell if the code is
doing the right thing and also because people will often not even look
at code with a missing binding.

> + - clocks : Pairs of phandle and specifier referencing the controller's clocks.
> +   The controller expects two clocks, the clock used for the APB interface and
> +   the clock used as the sampling rate reference clock sample.
> + - clock-names : "apb_plck" for the clock to the APB interface, "i2sclk" for the sample
> +   rate reference clock.

This is a name based lookup of clocks but the code doesn't use
apb_pclk at all; it needs to or the binding needs to say that apb_pclk
must be the first listed clock (which would not be good).

> +	soc_i2s: i2s@7ff90000 {
> +		compatible = "snps,designware-i2s";
> +		reg = <0x0 0x7ff90000 0x0 0x1000>;
> +		clocks = <&scpi_i2sclk 0>, <&soc_refclk100mhz>;
> +		clock-names = "i2sclk", "apb_pclk";
> +		#sound-dai-cells = <0>;
> +		dmas = <&dma0 5>;
> +		dma-names = "tx";
> +	};

This omits a lot of configurability that is in platform data and
replaces it by reading back the parameters from the hardware.  If this
is a viable approach to that configuration you should do this for both
platform data and device tree rather than only device tree.  The point
with keeping platform data is that it's not good to make the device DT
only, improving the usability of platform data in a way that happens to
also make the DT case easier is totally fine.  If we can determine how
the IP is configured from the hardware that's both less work and more
robust no matter how the device is instantiated.

--zpd1bWBxfrI+71+6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUmCocAAoJECTWi3JdVIfQ5K8H/2qmfWmc1+bHnEMStRLbT1J2
WmryCtBf8KzYxQG/5oA4emoi9GlJXQV3eqleBO+2GFd7bUQicw//1mq1UUtPqN8I
gnQC+LC5UvXBXNi7rV9itsLtcokh8xzrC/++cn9myiXG0u2ZPk6cDgczFFOmJT89
JsDJprnVfYG1JTF5iuavbLad49SG6nZ9Gi64nc2R6mMVhAWp9pEqgu5UQrNb3uBE
Xm6i6Y9Eg8BXCeVpbL6dUIoRMK2Y3RgZj+eS/MJLsm0VF7lqwvPrp8UJVXrTco13
jjzBstg1mAwK8uyPyOPeMcPwU2t+xKL2JkOgXlfSUoA+hNWek+dPuzj3mIeJ5cc=
=zrGe
-----END PGP SIGNATURE-----

--zpd1bWBxfrI+71+6--
