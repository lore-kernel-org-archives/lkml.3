Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab3IDKGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 06:06:31 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35939 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab3IDKGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 06:06:30 -0400
Date: Wed, 4 Sep 2013 11:06:06 +0100
From: Mark Brown <broonie@kernel.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hennerich, Michael" <Michael.Hennerich@analog.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <20130904100606.GU3084@sirena.org.uk>
References: <52209D1D.3080102@metafoo.de>
 <20130903232229.10934.60438@quantum>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bKO1kftFne8qVRsx"
Content-Disposition: inline
In-Reply-To: <20130903232229.10934.60438@quantum>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Clock framework deadlock with external SPI clockchip
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bKO1kftFne8qVRsx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 03, 2013 at 04:22:29PM -0700, Mike Turquette wrote:
> Quoting Lars-Peter Clausen (2013-08-30 06:24:45)

> > === Clock chip driver ===        === SPI master driver ===
> >  clk_prepare_lock()
> >  spi_sync()
> >    wait_for_completion(X)

> Is there a synchronous equivalent to spi_sync()?

spi_sync() is synchronous?  Obviously everything is asynchronous up to
that point but the only way the driver can tell if the I/O completed is
using spi_sync() or the equivalent thereof.

If you're asking if there is a way of doing SPI I/O that isn't multi
threaded then there isn't, in order to keep pushing transfers into the
SPI controller to saturate the bus we have a high priority task to push
more data in.  SPI buses can be quite high bandwidth in some
applications.

--bKO1kftFne8qVRsx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSJwYLAAoJELSic+t+oim99LsP/RXG03uakYHHWgPiMfx35aWz
fHHAxsuzYX5xUC4EBXoxU2N5xvhtM+k9ztNSnhGxTIChuVbZsQDZ73zAIvG5Fuf0
qlq5YBb5izUCpPFsn7Iye801SAesYQVo9iFCnTzMMx3cSXnVLxJOC0Pf37qx2Mwu
YFddJmmIiSuMRrjdhof8DFsLm+/1/W2re6mwckhLgxsd3SmHYnCPY+TjbsCTB4WX
QYpSbdL9WyqxlfySxQgaIBi3GFb+QlOx31SO6ZjO8psS4qXcbn7I52A+U0dcHrAj
nLTfOBz9yELSFUs2gaOAJX643Q2YlQmYnigVDunQs5KduY/Fp7MsnZ6HRTLxu15y
UYGmE5rbzYTHlvM/eXfFxpQalaEGY84qsn/f5pGPe6/r+TF1dmVvWAiRt+0Bg7Mx
FJZD+xl9a5fVHRELsi5PtYRUyR1J31k5CY9YUTiAzQY6ZI26LO2T8UWOBOL/A/cr
sAJGj7z646gZTZ8RbwoSVwaTjFqqvcMw7MtcEzbrdDKrIik5Hk6GVkay+/bEv2AZ
pw6QuaWncJmlRyR5H4gYd/6PaIOF6KYOVQJz2jXbhmFZJfNM62Fs/bpe3kbeVE5F
3UZvQu8sr0BvCa1XJe28zqUzOQB1B9YrzfRmC3cFoL8cfc1rDbD36UuiG7ML03up
73ZyZ+JoK+AkSYkvoffW
=OO50
-----END PGP SIGNATURE-----

--bKO1kftFne8qVRsx--
