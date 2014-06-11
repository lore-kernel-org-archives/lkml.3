Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbaFKXnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 19:43:09 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37671 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694AbaFKXnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 19:43:06 -0400
Date: Thu, 12 Jun 2014 00:42:12 +0100
From: Mark Brown <broonie@kernel.org>
To: Chew Chiau Ee <chiau.ee.chew@intel.com>
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org
Message-ID: <20140611234212.GR5099@sirena.org.uk>
References: <1402502222-19520-1-git-send-email-chiau.ee.chew@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kwyOAufsvjrbDa1R"
Content-Disposition: inline
In-Reply-To: <1402502222-19520-1-git-send-email-chiau.ee.chew@intel.com>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi/pxa2xx: fix incorrect SW mode chipselect setting for
 BayTrail LPSS SPI
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kwyOAufsvjrbDa1R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 11, 2014 at 11:57:02PM +0800, Chew Chiau Ee wrote:

> It was observed that after module removal followed by insertion,
> the SW mode chipselect is not properly set. Thus causing transfer
> failure due to incorrect CS toggling.

> -	value &= ~SPI_CS_CONTROL_SW_MODE;
> +	orig = value &= ~SPI_CS_CONTROL_SW_MODE;
>  	writel(value, drv_data->ioaddr + offset + SPI_CS_CONTROL);
>  	value = readl(drv_data->ioaddr + offset + SPI_CS_CONTROL);
>  	if (value != orig) {

This is a *really* non-obvious fix, I'd have expected the original value
to be re-read from the hardware here rather than just tweaked, or at
least some comment explaining what's going on.  Possibly also saving to
a differently named temporary variable would do it but whatever I had to
go look at the context to figure out what was happening and even there I
was unclear.

--kwyOAufsvjrbDa1R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTmOlQAAoJELSic+t+oim9Wv8P/1Gz0KrR669OKT2VF81LbZY9
E4bFy442ARqHkro+hmUCOb+M2W5rah01S6e7GAzWlbWTnDoOQthFe3ei7t/yrhO3
hGTqvyx6Sca5vreAy7hAQ6YUFJAhI1XxydsrlzdjMXHnwGwvp36D/uRMrG0JUQ+e
TXiRfFZgRe2ezIsUa/R7rjaFGlCm0UBv3N5izVr2aifz5kvC1bqusx+XcmZDBuYu
ODpSKNvxerzcqVio+vtMgPoQlszmRbh5f2pupqlgcYTsU66zWRfz9SIrgJGEzUcN
Z1SKJAfQDb3LZUxO9YGlWYC0v6782Ol/FAnh2V3/9N0DxM0pgKb+ZhdTyCvF2/Fe
1KLyLLtk063149XJqATk5lt2Vbi2gvrPxDBq/gHZGdOcFqfL0zYbIyPZRzFmLLwc
Lnc0RR6hwzUZNdgXLkAQdcz6bY8zGOkVOgCJ436QSG14lJhtV4YZ/XkCogBBB9k6
XZjYp0WQKyCBGDe3NISSgbudvGrjfTg+bF4Bohx/69nWfFtU0v/dXLy/iSiESCdO
k4wUCKCJV1wqxoF6SXhzWdL8IYWcidArS9xKEYUh8ZbHqFCqzt09piNkccYaaKSy
a+OQJEl4hm7AgBGf1vcT9GCiDZzfOujAm3jamRqHUuEVYEpmTp8m7jBRS/1DrSAD
g4AoojhZtsg5mf0uaEuQ
=tqR6
-----END PGP SIGNATURE-----

--kwyOAufsvjrbDa1R--
