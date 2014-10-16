Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbaJPIvL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 04:51:11 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57979 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbaJPIvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 04:51:08 -0400
Date: Thu, 16 Oct 2014 10:49:37 +0200
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20141016084937.GH724@sirena.org.uk>
References: <1413447808-16429-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mYYhpFXgKVw71fwr"
Content-Disposition: inline
In-Reply-To: <1413447808-16429-1-git-send-email-k.kozlowski@samsung.com>
X-Cookie: You will be divorced within a year.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: s2mps11: Don't zero allocated memory for
 external control
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mYYhpFXgKVw71fwr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 16, 2014 at 10:23:28AM +0200, Krzysztof Kozlowski wrote:
> The driver was allocating memory for storing GPIOs for external control
> with unnecessary GFP_ZERO flag. Then right after allocation it
> initialized memory to -EINVAL in loop. Skip the GFP_ZERO flag.

Applied, though it's a bit of a microptimisation and it would be better
to use kmalloc_array() instead.

--mYYhpFXgKVw71fwr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUP4agAAoJECTWi3JdVIfQbS8H/2nof4ULVyR99CRgT4NjoJmu
h5pSLypk3ICPjHkCfp9KuEqpL8NK1oMqwSiGx1dxy09kX4WUiLvw0BnG6sJxfaQi
hcgk9nWb+bz3QaZBiXhbynTLWvSFj3PhDa5geeUI9SQUQiYU+EFxsvdV1Wy3tjDw
G2tfg+pD5lZl+NYX5lVNDD73V+xoRIeZQvaOgPRaiSoARpo1kNWLH0kYw+AFEOSP
h9ygF94H2tzg0xj0hTg4cto5x5yKRP4PW/jCS9jaOWgCQc3vp+noOnHwD/UPXXzg
4xEbKca03QhL7uF2dN/T8zT9o9Da34hPMG6/OD3ewgiO+xYYz08JULP78znfnjM=
=r359
-----END PGP SIGNATURE-----

--mYYhpFXgKVw71fwr--
