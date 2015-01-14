Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbbANUGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 15:06:52 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57522 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbbANUGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 15:06:50 -0500
Date: Wed, 14 Jan 2015 20:06:26 +0000
From: Mark Brown <broonie@kernel.org>
To: Ken Wilson <ken.wilson@opengear.com>
Cc: thomas.petazzoni@free-electrons.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        ezequiel.garcia@free-electrons.com, gerg@uclinux.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org
Message-ID: <20150114200626.GN3043@sirena.org.uk>
References: <1421032440-15335-1-git-send-email-ken.wilson@opengear.com>
 <1421032440-15335-3-git-send-email-ken.wilson@opengear.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="SgT04PEqo/+yUDw3"
Content-Disposition: inline
In-Reply-To: <1421032440-15335-3-git-send-email-ken.wilson@opengear.com>
X-Cookie: To program is to be.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv2 2/2] spi: orion: Add multiple chip select support to
 spi-orion
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SgT04PEqo/+yUDw3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 12, 2015 at 01:14:00PM +1000, Ken Wilson wrote:

> +- num-cs     : The total number of chip selects used by this platform.
> +		If unset, this defaults to 1.

So, this is intended to be the number of hardware chip selects that can
be configured but the first commit mentioned GPIOs as an option too so
we should at least say that this is specifically the controller
supported ones.  However...

> +#define ORION_SPI_CS_MASK	0x1C
> +#define ORION_SPI_CS_SHIFT	2
> +#define ORION_SPI_CS(cs)	((cs << ORION_SPI_CS_SHIFT) & \
> +					ORION_SPI_CS_MASK)

...given that we have a fixed bitfield here which we know and doesn't
appear to depend on configuration do we even need this to be
configurable - given that we're going to need an explicit node for any
slave can't we just accept any sane chip select for a slave without
extending the binding?

--SgT04PEqo/+yUDw3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUtsxCAAoJECTWi3JdVIfQON0H/1W+W9OIt4nQmp4YmrbbORPs
TyEnxWbjrhVVjaktUcm9ChTnVXpvtirsvTrjRCTHJKOT0hrLBbE7wcwvyICpggY4
gAT5MlBrVavPL44zZB3f36FxrrN+86dKwfeQ+XrWJ8XM6QA3gV136zVQuGmJ6j50
35JAYVSJY3v2zwmD99Qzl3hIzpST++xZkmw7jAgXT9g/V7fU707aJ8PJIl0LaSdU
WC7CoA10rcCX9PMxtzfGvH1cN8svY7MiEmaZx2pb7YVndt9qMzTn/IrR7DqJKNJc
mkSa0Mtm6Tds4wZedpc96/XLNlfdKBGZpceYcTo+mbBnSfv9fwTh/5lKE+fJWE8=
=nyM7
-----END PGP SIGNATURE-----

--SgT04PEqo/+yUDw3--
