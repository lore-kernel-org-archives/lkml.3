Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057AbaKYNmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:42:46 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38125 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbaKYNmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:42:44 -0500
Date: Tue, 25 Nov 2014 13:40:48 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: linux-spi@vger.kernel.org, Andrey Yurovsky <yurovsky@gmail.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20141125134048.GE7712@sirena.org.uk>
References: <1416853893-1993-1-git-send-email-andrew.smirnov@gmail.com>
 <20141125124229.GY7712@sirena.org.uk>
 <CAHQ1cqGvDft1t5MkaqT-xsfBygdghA3mK_a7x+Z3L6HtvqrwhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="InMamxIZU0LonZYu"
Content-Disposition: inline
In-Reply-To: <CAHQ1cqGvDft1t5MkaqT-xsfBygdghA3mK_a7x+Z3L6HtvqrwhA@mail.gmail.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC, PATCH, RESEND] spi, spidev: Add support for long SPI
 transfers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--InMamxIZU0LonZYu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 25, 2014 at 05:30:04AM -0800, Andrey Smirnov wrote:

> > No, that's not the case at all.  A spi_transfer can have a length that's
> > an unsigned integer number of bytes which is much larger than 255 bits.
> > What is the actual problem you're trying to solve here?  I suspect the
> > driver you are using is just badly implemented...

> Yes, and you're absolutely right about spi_transfer, however I wasn't
> talking about spi_transfer at all. My point was about SPI transaction
> which is all the bits shifted out on the bus(and shifted in as well)
> during the duration of the CS/SS signal assertion.

A spi_message (which is the thing that covers the entire /CS assert
modulo non-standard fiddling) is composed of multiple spi_transfers
so the above still applies...

> >> +             if (!u_tmp->bits_per_word && u_tmp->bits_per_burst)
> >> +                     k_tmp->bits_per_word = u_tmp->bits_per_burst;
> >> +             else
> >> +                     k_tmp->bits_per_word = u_tmp->bits_per_word;

> > This is setting the number of bits per word which is nothing to do with
> > FIFOs or the lengths of transfers but instead concerns the formatting of
> > data onto the bus.

> I don't believe I said that this commit had anything to do with FIFO.
> I did acknowledge that fact that modern SoC have large FIFO and this
> is relevant because often times the size of that FIFO is what
> determines the size of a single SPI transaction. I tried to be careful

No it doesn't, chip select can frequently be manipulated independently of
data transfers and almost all controllers can support transfers much
longer than their FIFOs either by doing that or by keeping the FIFO
topped up during transfer.

> in my wording of the summary and not use the word "transfer" anywhere,
> but it looks like I slipped twice and that might have contributed to
> this confusion. I apologize for this and hope that my comments
> clarified my meaning/intent

Sorry it's still not at all clear, please re-read what I wrote about
what bits_per_word means since I really don't think you've understood
what it's for.

--InMamxIZU0LonZYu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdIbgAAoJECTWi3JdVIfQqmAH/1pRpFRknqahs8isXDPPnTII
zIcDlkQH4GyFqxDoYDWWOOv4MWkmEjYFWRjsEkO4+4M5l6mzDuoYj9fvK4TmCec1
2hjbh/iJxqAAOGPGAzW8sOZVC1WBFEBSEEXZ3AmVGQCBwx4kH7kljYakOCvCIFZ4
xiNEhlTHiNGVVA0tLht5sYkrcQT8OTnI8c6cTXSzHFoavh2XPMnBy5qUJkB1844J
e47C1XHEqEfNhfPW5YX160NPufjJpYkbDZxW1gBQNWMdsI2D3HbCuEUYtgoY2nml
qQozkMUDJwlX6r8PVjrAj4ahapEZQu9D8Q6V7nMkrkbGubo+ZV1SsjZPvy7EanQ=
=TAT4
-----END PGP SIGNATURE-----

--InMamxIZU0LonZYu--
