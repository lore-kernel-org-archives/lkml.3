Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbaBRAeF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 19:34:05 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35513 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439AbaBRAeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 19:34:01 -0500
Date: Tue, 18 Feb 2014 09:09:38 +0900
From: Mark Brown <broonie@kernel.org>
To: Gerhard Sittig <gsi@denx.de>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140218000938.GE2669@sirena.org.uk>
References: <1392444566-23605-1-git-send-email-iivanov@mm-sol.com>
 <20140216142512.GR4524@book.gsilab.sittig.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xJK8B5Wah2CMJs8h"
Content-Disposition: inline
In-Reply-To: <20140216142512.GR4524@book.gsilab.sittig.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.99.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] spi: core: Validate lenght of the transfers in message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xJK8B5Wah2CMJs8h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Feb 16, 2014 at 03:25:12PM +0100, Gerhard Sittig wrote:
> On Sat, Feb 15, 2014 at 08:09 +0200, Ivan T. Ivanov wrote:

> - the total length of the SPI transfer cannot be empty (which I'd
>   consider an optimization, not a violation, and may need a
>   separate discussion)

We probably want to allow that for people doing fun stuff with cs_change
though I'm not convinced anything doing that is actually a good idea.

> - the total length of the SPI transfer must be such that each
>   "word" must be provided within a full 1/2/4 byte entity, with
>   padding bits if the bits-per-word is "odd"

> Is this a misunderstanding on my side?  A terminology thing?  To
> me, the "SPI transfer" is the total payload and may have any
> arbitrary length.  What you check for is a constraint on the
> transfer's length derived from or based on the "word length"
> ('word' in SPI context).

> So the code may be appropriate, yet the description may need an
> update, to not have the next person ask the same questions again.

It seems fairly clear to me - if we're transferring 16 bit words we need
the transfer to me a multiple of 16 bits and so on?  The requirement for
padding is unclear I have to say.

--xJK8B5Wah2CMJs8h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTAqS+AAoJELSic+t+oim92RUP/2YvBAHKWr2T3U8Xft3gbVdB
B+FkgEIansZdOCHzqPIbrnXgEHhS16+0qjWa9/aD4EBxrAFI0hz0GptDZS+tbf93
X+uX8dGRZaDOp1QvNQmJjWCTualTOZiaDBmpLRKq8p39wJv6Hd5Bt02F3UJQ69Mn
N9DWImmFWf32BVeuf0fwKom7XJWld5iAf4PpwDrRlzKumCDfqcAiB8wPiCwlAlwm
w9EbiCYhM4fcJQFStPmZPXTYgH86oj0gi/e5kKw+lUaEIybILSJAAidpngMudSoJ
6R0lzQu77bTtb/gQ+UsiwrOCos5Q3dUenkvqdIaQEDZtVgzl6XSGh3zNqx7jfyd/
HCHL0O8DtnGzJxDXY2ZLea6dnYZmsEZTvuSuDoML43wJYk+I3gZoL7KzrLlCHkWK
adZm2cBoot2NO5pfuxE294/WICSUE22KkYU7e+h1UFkpXd6T9jODkBo75OUX7FRH
Ypz8kGLZ7XDmz22o2S244hPTfbs1xpGw0kwuuP/S3TatyRJKzzVfNYKGE2GX+Xat
gwblF5P0m3XJ+UzAh5t4P6B9GCCdR3XocQv+d8JF+/7hVYPj+p8e8uwLwQ4Gdc1K
1dbdyC4mIqkw5DU1A1EaSdQVO2/kfTxf5pDgkznFr3Tc+fqxrPWMmpSa5xOPJhUB
TsRjXJWxJ3PEI6zbszje
=/2FT
-----END PGP SIGNATURE-----

--xJK8B5Wah2CMJs8h--
