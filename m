Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751111AbaK0SbZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 13:31:25 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:41139 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbaK0SbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 13:31:24 -0500
Date: Thu, 27 Nov 2014 18:30:58 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Kukjin Kim <kgene@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-ID: <20141127183058.GB7712@sirena.org.uk>
References: <1417087253-12306-1-git-send-email-k.kozlowski@samsung.com>
 <1417087253-12306-3-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4802fQj3DlSA+WXC"
Content-Disposition: inline
In-Reply-To: <1417087253-12306-3-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 2/7] regulator: dt-bindings: Document the ena-gpios
 property
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4802fQj3DlSA+WXC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 27, 2014 at 12:20:48PM +0100, Krzysztof Kozlowski wrote:

> +- ena-gpios: GPIO to use for enable control. Actual implementation depends
> +  on regulator driver. The bindings documentation for given driver describes
> +  which regulator actually supports it.
> +- ena-gpio-open-drain: GPIO is open drain type.

I'm relly not a big fan of adding a fixed name property here with no
override capability, it means that the naming won't reflect the specific
regulator design so closely and in practice for many of the PMICs the
GPIO control can do rather more than just control enables and supports
reprogramming.  The latter case where we've got a signal which can
sometimes be simply and enable but sometimes more makes it especially
worrying to have the property always be there, it's something that might
work in some configurations but could easily be broken if we try to
exploit more advanced functionality (things also triggering other
configuration changes at the same time).

Factoring out the code is good but it seems better to have it be
something which drivers can control, for example by having them
explicitly specify a property name to use or perhaps a flag to enable
the default name.

We also need an invert option.

--4802fQj3DlSA+WXC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUd23hAAoJECTWi3JdVIfQay8H/jIeCloCCEW8WC1Fzf3AW8ft
F2rYuuVJnc7vDyzFLIrN6V9pYN2IE2HHdwzat5NCUipdHkZIO0fDXez4Y+YYsdPO
nSq7o3UxMEwawaxcxjOiGNzVuEwl80PQCGh1Gzn2bvZpwUDsZvBbT/vnRGMe75dr
ywom1+xXPOCiaxatdvNmWJShQOgQwMfvXIDOh78qbx5baSvlAatShRB3Cr745lb1
YDHun+mZ/EDarhwPaH9/oS5BjMsPjItVQqHO6ep3JrFHy8faJTdW5yypuW9RdbUS
hh75PD9fLXoHApI0y4zEXZvytxnlgcSNJChDFBumjir69Ji3V1jYftFRGG94g1M=
=7Ncs
-----END PGP SIGNATURE-----

--4802fQj3DlSA+WXC--
