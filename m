Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400AbbA0AJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 19:09:15 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35293 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbbA0AJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 19:09:13 -0500
Date: Tue, 27 Jan 2015 00:09:03 +0000
From: Mark Brown <broonie@kernel.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Message-ID: <20150127000903.GM21293@sirena.org.uk>
References: <1422029330-10971-1-git-send-email-ricardo.ribalda@gmail.com>
 <1422029330-10971-12-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="WGHZoVWEtLLpKyPH"
Content-Disposition: inline
In-Reply-To: <1422029330-10971-12-git-send-email-ricardo.ribalda@gmail.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 11/18] spi/xilinx: Remove rx_fn and tx_fn pointer
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WGHZoVWEtLLpKyPH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 23, 2015 at 05:08:43PM +0100, Ricardo Ribalda Delgado wrote:

> +	switch (xspi->bits_per_word) {
> +	case 8:
> +		*(u8 *)(xspi->rx_ptr) = data;
> +		break;
> +	case 16:
> +		*(u16 *)(xspi->rx_ptr) = data;
> +		break;
> +	case 32:
>  		*(u32 *)(xspi->rx_ptr) = data;
> -		xspi->rx_ptr += 4;
> +		break;
>  	}

Perhaps I'm missing something here but we only seem to be incrementing
rx_ptr for the 32 bit case here...

> +	xspi->rx_ptr += xspi->bits_per_word/8;

...which looks to duplicate this which handles all cases.  Also there's
a coding style thing - spaces around the / please.

--WGHZoVWEtLLpKyPH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUxtceAAoJECTWi3JdVIfQfvwH/Amez0zurXwIRYoOV8hzJoyg
jZ4RRfoqe1Of9yn2RGxu1NNN6a4uwAAaXaBba6OkhufGY3/nJNRzp7HpQ2e/BE0T
QjVwHfwKYNoVkjA+tL74NUzxdw7EDtfZnKshluE4TSar9zYFomAddgIl4hH2WFeL
ubvncHsKki0a43m2dXpQhMHmIKe04sCoaAX0nZwB5LTGUUkkkNOC1klN0M8nZSTW
Dtsp3ZP2kIWFhHMYMfXC3Hm6TaPLP1xBYuYv4CFoHFLIQTkMzTE+dqnrnyTMDRuw
tDtCogi9pZV1CU2/TpZw1GqXYF/FQW0U1DX9GzedmPKgn+4yKR+qjG6WQ76ftGY=
=cJT8
-----END PGP SIGNATURE-----

--WGHZoVWEtLLpKyPH--
