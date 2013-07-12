Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017Ab3GLLqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 07:46:17 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50288 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932805Ab3GLLqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 07:46:16 -0400
Date: Fri, 12 Jul 2013 12:45:51 +0100
From: Mark Brown <broonie@kernel.org>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Bo Shen <voice.shen@atmel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree-discuss@lists.ozlabs.org
Message-ID: <20130712114551.GD24508@sirena.org.uk>
References: <1373559359-31607-1-git-send-email-richard.genoud@gmail.com>
 <1373559359-31607-2-git-send-email-richard.genoud@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sk6NRVTC9kZ6Mrgo"
Content-Disposition: inline
In-Reply-To: <1373559359-31607-2-git-send-email-richard.genoud@gmail.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 193.120.41.114
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5 1/7] sound: codec: wm8731: add rates constraints
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sk6NRVTC9kZ6Mrgo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 11, 2013 at 06:15:53PM +0200, Richard Genoud wrote:

Please always try to use commit logs that look like normal commit logs
for the subsystem.

>  	switch (freq) {
> -	case 11289600:
>  	case 12000000:
> +		wm8731->constraints = &wm8731_constraints_12000000;
> +		break;
>  	case 12288000:
> -	case 16934400:
>  	case 18432000:
> -		wm8731->sysclk = freq;
> +		wm8731->constraints = &wm8731_constraints_12288000_18432000;
> +		break;
> +	case 16934400:
> +	case 11289600:
> +		wm8731->constraints = &wm8731_constraints_11289600_16934400;
>  		break;
>  	default:
>  		return -EINVAL;
>  	}

This isn't going to work with systems which have a variable clock as the
input to the CODEC.  If it's imposing constraints the driver needs to
allow setting the clock to zero as a way of removing constraints (and
any existing drivers should be updated to do this if needed).

--sk6NRVTC9kZ6Mrgo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR3+xsAAoJELSic+t+oim9p04P/0T8lf/1EpIj0VFoJQC5LNYD
Pq43japEzv4UhvM0/rrUBE7H5uaNeI1A5vcJNLv42ETeeuTL6/X7GuyzvN3db/IE
oGZOHq8AUS1J1CxnfXRazCdKtu5vl51CwYOHdJlyH4NeWpFZXLk1JODP5YsLfzE3
Kl/42XF004Qc0Qnsv95v0fdw4oCh/ymbdSlQ0+cpfFHwJ7XHh1ctYdeH3hf4RvjG
S35eQphj7y/LW6jbrBOo2kMr0mm8PyJf5l70yGoFvoXkOpjk22Rjp1C+67eDxQui
ZlwoY/Spxg4zkr2Wc5td8+tOh0d3elM9R01sowpSy4tgn0tY3u2CJz/2yeXgOkNI
cmTx5Rib9/SJwhG6VvQ5I653D9+cM6SbG9sEOvqoypQR+KzI+ELlg4SPV/Fiv9jX
91wIusF7t6DZwK2p9OQAy7YkvLGg5exRt8WQXNeWedrf7e7ezyiwxd+kZqJ/BkEc
5p5jDi7DcST8fINE5wJV70dE+vd0Kmks4FvitwMQf9ypWVIw0zIFe3EGX+WsPf7s
rNDihtCWUnssUp4UQRW1hMy4a8bLRdFPL0/FmNZjwt5H4ueEab5j/AoM9WIw3ICV
w0APgcOfCsE52CJ9L+BNJ9k5xWN9EATtBPC7yofsfo4A4EDn96MAuhJB3VFYGk+F
A1kJpJlKr5oPWdNaRuTC
=UTvu
-----END PGP SIGNATURE-----

--sk6NRVTC9kZ6Mrgo--
