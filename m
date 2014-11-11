Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbaKKSBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 13:01:13 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33647 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbaKKSBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 13:01:09 -0500
Date: Tue, 11 Nov 2014 17:59:43 +0000
From: Mark Brown <broonie@kernel.org>
To: Thor Thayer <tthayer@opensource.altera.com>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20141111175943.GC3815@sirena.org.uk>
References: <1415442589-29434-1-git-send-email-broonie@kernel.org>
 <546214F7.1040007@opensource.altera.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ky36DnKXfPqepASA"
Content-Disposition: inline
In-Reply-To: <546214F7.1040007@opensource.altera.com>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: spidev: Don't mangle max_speed_hz in underlying spi
 device
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ky36DnKXfPqepASA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 11, 2014 at 07:53:59AM -0600, Thor Thayer wrote:
> Hi Mark,

Please delete irrelevant context from mails, it makes it much easier to
find any new content you've added.

> On 11/08/2014 04:29 AM, Mark Brown wrote:

> >  			if (retval < 0)
> >-				spi->max_speed_hz = save;
> >+				spidev->speed_hz = tmp;
> >  			else
> >  				dev_dbg(&spi->dev, "%d Hz (max)\n", tmp);
> >+			spi->max_speed_hz = save;

> I think the test should be if (retval >= 0) otherwise the value is only
> updated on an error. With this change, I was able to successfully change the
> SPI speed without affecting the max speed. This was tested using
> spidev_test.c on a Altera Cyclone V which includes the DesignWare SPI IP
> (spi-dw.c).

Yup, misleading code.

> >  	if (status == 0)
> >  		spi_set_drvdata(spi, spidev);
> >  	else

> The echo command calls spidev_write() directly. Although the speed can't be
> specified in the echo command, it did prompt me to look at that path.

> In that case I think we'd need to add the .speed_hz element in
> spidev_sync_write() and spidev_sync_read().
> struct spi_transfer    t = {
>             .rx_buf        = spidev->rx_buffer,
>             .len        = len,
>             .speed_hz    = spidev->speed_hz,
>         };

Yup, looks that way.

--ky36DnKXfPqepASA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUYk6PAAoJECTWi3JdVIfQx9wH/A63e3wpnb4wPhEBPgNs8gfs
MxeWw6y6LibsDs6Mlg5O/tLwgD0LaWmPHumFd3t8BOkhPNX4DeDdIOIyIP+IRyJA
0uouKCaFmOr5SB3yg9cAbA/nTHcfe9zWC5brLa1CMIDi/f7Fkpwi20PgR+wvWXB8
CSQYYxzB/IXEydzI38L6ePhQbUuhDnHT9ExeESBZOxxLqnzp0GGBxpPK+VXXl5kI
0Qvls5WptYVtHIcaB5kXTWkHXhjMAlbCbXea5XqB4aVqGzyI2dhf2S1HYuEIHhLl
MANf5KEh3ctUbt612gAdMtJiiRanOqcbgM2OKccnY0Ya6G0rF4h/R7WRkU21I5c=
=0CXa
-----END PGP SIGNATURE-----

--ky36DnKXfPqepASA--
