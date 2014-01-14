Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbaANMwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 07:52:53 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53929 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbaANMwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 07:52:49 -0500
Date: Tue, 14 Jan 2014 12:52:42 +0000
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Message-ID: <20140114125242.GE15567@sirena.org.uk>
References: <1389699411-29135-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6Vw0j8UKbyX0bfpA"
Content-Disposition: inline
In-Reply-To: <1389699411-29135-1-git-send-email-geert@linux-m68k.org>
X-Cookie: Marriage is the sole cause of divorce.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH/RFC] spi: core: Fix logic mismatch in spi_master.set_cs()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6Vw0j8UKbyX0bfpA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 14, 2014 at 12:36:51PM +0100, Geert Uytterhoeven wrote:

>  {
> -	if (spi->mode & SPI_CS_HIGH)
> -		enable = !enable;
> -
> -	if (spi->cs_gpio >= 0)
> +	if (spi->cs_gpio >= 0) {
> +		if (spi->mode & SPI_CS_HIGH)
> +			enable = !enable;
>  		gpio_set_value(spi->cs_gpio, !enable);
> -	else if (spi->master->set_cs)
> -		spi->master->set_cs(spi, !enable);
> +	} else if (spi->master->set_cs)
> +		spi->master->set_cs(spi, enable);
>  }

Coding style, braces on all branches of an if statement.

This also pushes the handling of CS_HIGH back out into the driver which
doesn't seem like it's helping anything.  Flipping the sense of enable
when calling set_cs() is probably OK though.

--6Vw0j8UKbyX0bfpA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS1TMXAAoJELSic+t+oim9NTYP/3IwaIOyPWY4GSq4BswuyZWI
o1qVhf72gNin4DQlnV67WRYRGIFL9Z+CTwXZaag+NWFw8tDmeZyfVUBjEpgxM6I+
9U2h1VmXvblCWMlw02kbTesyszFKqsllfOQCwlE0t6gZ8IklYlEmJnnK50bhRvqv
DCDtkgwmSCwiPEtEX/izUoDyMXYrCCSTlT6lt+ddvwmTJ7qo5438JW7U3b2v1N1J
hB/mX/2nJugEX9A2z4vOYMRZDit48l5DD0iNgZIM9A6HycqRA0aOdM7yAdb467IH
Ht6w0LXGA40KONRXaaMhn3C3Exts4XCviMZnE/HahW8UjpS/l2gOftjUqQkVv01S
un6+K7q5Ng8mi99wesCz3M6bYlFXGgS+NKQDHcCA9URYoI526cjZh70tKEgwZYLB
meaNKmicaoL+a2HPgUQORWKHCZtWKHLELUd/7art09k71RKZ7phaMqTP74qifAu1
c+Yn3rt+9TvZax7h5CkayDjtzBZ3syZvvtBcix+P9kBJ0Ksu+S8vCtVL1MqL344a
wUpDH/ZjsOXPzBOFhSiY/s+RnLGC+yGF17a+uhvU4rGW0S0KH5cRmHYWU7y/aai+
Gv9ibMX+YB4DQHDZydTyOq3k93qcrw7ePsrY1O5/SZcoqvxiwgSJOgeJvjm5pemU
VGXhNyBSnzf91PPNkN1h
=KfTb
-----END PGP SIGNATURE-----

--6Vw0j8UKbyX0bfpA--
