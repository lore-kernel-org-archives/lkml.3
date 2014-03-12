Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbaCLMtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 08:49:17 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47608 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbaCLMtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 08:49:15 -0400
Date: Wed, 12 Mar 2014 12:49:01 +0000
From: Mark Brown <broonie@kernel.org>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: linux-xtensa@linux-xtensa.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Chris Zankel <chris@zankel.net>, Marc Gauthier <marc@cadence.com>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20140312124901.GQ28112@sirena.org.uk>
References: <1394626865-15105-1-git-send-email-jcmvbkbc@gmail.com>
 <1394626865-15105-2-git-send-email-jcmvbkbc@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NckIF66D29mqubFO"
Content-Disposition: inline
In-Reply-To: <1394626865-15105-2-git-send-email-jcmvbkbc@gmail.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/3] spi: add xtfpga SPI controller driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NckIF66D29mqubFO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 12, 2014 at 04:21:03PM +0400, Max Filippov wrote:

> +	case 16:
> +		/* Bytes that should go out earlier have lower addresses,
> +		 * but the hardware operates with 16 bit words and transmits
> +		 * higher bits first. Thus data in memory is in BE order.
> +		 */
> +		xspi->data = (xspi->data << 16) | be16_to_cpu(v);
> +		xspi->data_sz += 2;
> +		break;

Are you sure you need to do this byte swap?  SPI words are big endian so
if you are running on a little endian processor if you are transmitting
16 bit words you should see the data getting swapped on the bus (this is
why I say you should never have more than 8 bits per word for regmap).

--NckIF66D29mqubFO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTIFe5AAoJELSic+t+oim9oVQP/RrJLM2g8TR6xGpJAxppmMIT
XAy0MDJLEA60MVKEnCZdmvniijoB/hcxBXGoO7prUZNKYXbyHyC9LK4YrdwWW0S3
xhn2mYMw4GBVxNYK6VQW/AT6gNmqLdcuhBcWzjcrBJKYR2e227ZwhSFzPORYI6rT
IKUVpBWd4P/tFOZBYtGSJc4/8DMx+aZNbxQqWD62zsu1jNy7375ysvqFfLS5FXxC
8Hb1S+UjK7pY/zxKxXh6FgIyrtQ6n0CALGC27x1cfMz6LSmbhiyrP7rKSDNZjZ/c
TNBNJitc2GZmVx8jDGTaCJ4DxPMUhFgSBbgcZ9MZkivz0l+gbTyhOSfQuDYVASLZ
lRwwi/gscngCR75M0zP4GnXfJdZcwCfUNqx8QXi5sZuEuCCVp5RvU+/qHyT0AmxR
BiStg9zIaAm2D6IU2zhjigJ0MxTJwm7GwbvihPx76UxiAi1TQ0gY+EnARi7oKRD4
i+RnWwFi+F3U8uC8WWqb2KfNMn+SV1ZkT/Uzo/bB6ZpAywtU4CE1TYK7RFIYmIIB
KeZfppHCiIhSjV1naMwENySyhLdvDpm9cwFzGhQrm9B+zsF7k/6D3rwM/1PdqcB5
LMCfrdYWSxT1RaN0Q6TAR22ZFlyM5hetAbB1hoXzRnLZwHrnNn0YGmc7Rlr57+VJ
tvEGpdDGbbbwXyP2LIDM
=QloZ
-----END PGP SIGNATURE-----

--NckIF66D29mqubFO--
