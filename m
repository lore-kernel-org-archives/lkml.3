Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbaBNS0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 13:26:21 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46215 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbaBNS0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 13:26:15 -0500
Date: Fri, 14 Feb 2014 15:06:40 +0000
From: Mark Brown <broonie@kernel.org>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140214150640.GE4451@sirena.org.uk>
References: <1392302806-17267-1-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KlAEzMkarCnErv5Q"
Content-Disposition: inline
In-Reply-To: <1392302806-17267-1-git-send-email-iivanov@mm-sol.com>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 149.254.51.37
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: core: Validate lenght of the transfers in message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KlAEzMkarCnErv5Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 13, 2014 at 04:46:46PM +0200, Ivan T. Ivanov wrote:

> +		/* No partial transfers accepted */
> +		if (!n_words || xfer->len & (w_size - 1))
> +			return -EINVAL;

Please write this using % rather than the & - it's a lot clearer what
it's checking for, I had to think what the above meant.  Hopefully the
compiler will make it equally fast either way.

--KlAEzMkarCnErv5Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/jD8AAoJELSic+t+oim9xJoQAISEKUjUtcLd10+GOmF/+rM3
bGtog4t0fzy37ZBejdK7Kn9f5j2RLDWlJsMfMw00ytFVdsqq00VsE+dto5hLePCT
iI7HiCcVR0/5uh8/egvewOjODzstMvJrFNdiI50AERsXxMzl+fzNoimD2v0qflcF
kmaTOdh7nZ8owZfB9kCQQZt+5HzfcBcm35JHLYjjNB8PDahC78xP1548cgyxBTsu
HJ0rQWAhpEBpwHghcRbspurpbOjAZlgrbRsfpwS4e1NZiH6KzRhawcEjSxmFYhUZ
ApzyIzc+6sMK+GTaMAP7x1ypxSHfSfPL8jtQfsB7WWxsGcY4Z8wiofMyVp5tFesL
VZGtj3L6kbgN9AflEDddnX9V0RV9pDIKWEWarRcizZv16o9NIse0tYIwYiA3lDSS
p65UkwoLvqIwWNFIQEBeidxNYS010n2OYM5tB4CO51P41+wHOa1ZwSyQ90j3DKfG
pfsjk8sO9Iu3Us41Hv45IvJju3AJj+Lb+DOeLZNrj48MaInw/sMZr4dLtmhuU9jU
7DfyBHrSL79U1chTzl8XAqWsbzZlcU/mqjdAfyiGFJ7AzWUrTIy8YjESgPvVy+th
ivlB0b4A6xPeIgweb/g/Qy3ZzSMYLvQrds10+M2Oxey8iSy2hoL/TPKQAhCkv+7M
ebApivjPbZCuHX5gG015
=hexG
-----END PGP SIGNATURE-----

--KlAEzMkarCnErv5Q--
