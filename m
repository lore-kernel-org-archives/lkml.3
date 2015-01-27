Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759104AbbA0SMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 13:12:30 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36566 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723AbbA0SM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 13:12:27 -0500
Date: Tue, 27 Jan 2015 18:12:14 +0000
From: Mark Brown <broonie@kernel.org>
To: Paul Osmialowski <p.osmialowsk@samsung.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kukjin Kim <kgene@kernel.org>, linux-i2c@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Message-ID: <20150127181214.GD21293@sirena.org.uk>
References: <1421419194-1849-1-git-send-email-p.osmialowsk@samsung.com>
 <1421419194-1849-2-git-send-email-p.osmialowsk@samsung.com>
 <20150116162314.GB3856@sirena.org.uk>
 <alpine.DEB.2.10.1501161811280.21618@AMDC1262.digital.local>
 <20150116183635.GH3856@sirena.org.uk>
 <alpine.DEB.2.10.1501191031080.13777@AMDC1262.digital.local>
 <20150119192557.GI2809@sirena.org.uk>
 <alpine.DEB.2.10.1501201214200.8428@AMDC1262.digital.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="PQOEDtqHNYuC9sWW"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1501201214200.8428@AMDC1262.digital.local>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC 2/3] regmap: Use the enhancement of i2c API to address
 circular dependency problem
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PQOEDtqHNYuC9sWW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 20, 2015 at 12:14:31PM +0100, Paul Osmialowski wrote:
> On Mon, 19 Jan 2015, Mark Brown wrote:

> >OK, so that's what should go in the changelog (along with an explanation
> >of why this preparation is required at all) - but I still don't see the
> >async bit of this I'm afraid.

> I don't think preparation stage should be exposed for asynchronous transfer.
> Due to its nature, it shouldn't cause circular lock dependency as we can
> observe for synchronous io. Since i2c does not support async transfer anyway
> (so (map->async && map->bus->async_write) will be always false for i2c
> transfers), let's use spi as an example.

Again I come back to explaining this out of the context of this
particular issue in terms of something that's comprehensible at the
regmap level.

> With spi we have curious situation where both sync and async are handled by
> the same __spi_async() function, though for sync transfer
> wait_for_completion() is called soon after __spi_async() in order to ensure
> that transfer is completed.

That's not actually that strange really, in general synchronous
operation can always be implemented as a simple wrapper around
asynchronous operation.

> Actual transfer is handled by spi_transfer_one_message() called from
> spi_pump_messages(). Note that spi_pump_message() before it calls
> spi_transfer_one_message() also calls prepare_message() callback (if
> provided):

We are *massively* into implementation details here, if we're relying on
these things then they could change at any time (and in fact what you
say above is partly specific and is not true even in the default case
for current code).  Think in terms of abstractions and locking
guarantees rather than the details of the current code.

--PQOEDtqHNYuC9sWW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUx9T9AAoJECTWi3JdVIfQJvwH/RuGx4/yLYw+wCetvLdU1fwS
/oPsQgtY10opH+KmQOH0CxWR26W76iFxOExdPcD7YOPQDsE45Lw6cl8zdSlYDHkW
GcXWXKB0Qw6uPWbf3m3fcmx5LZSaaTbM5gxnifsi4oOnpJ6mx1eNCeM6w+inf5Cq
rG58MPDNgS5timYqUyFmNAeMJ5WtqQ32ytnDuED0o2nqlF3sD9xr5/nWYlqcWmHI
VT/uDY0qMiSzr2yCNuOd5v2Y/LXKaBR9oFM1PBA2Rd21AMKHoAAPdwOy6+wNXiCe
hcyCZN2+pUa2agiAxhEp/fMvMxudazzF4OTuf+21hJRaCMdNemHGUiNzjES3EF0=
=dlI5
-----END PGP SIGNATURE-----

--PQOEDtqHNYuC9sWW--
