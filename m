Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964778Ab3BNL43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 06:56:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50409 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757136Ab3BNL4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 06:56:24 -0500
Date: Thu, 14 Feb 2013 11:56:22 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] regmap: mmio: add register clock support
Message-ID: <20130214115621.GE13249@opensource.wolfsonmicro.com>
References: <1360835354-31740-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cPi+lWm09sJ+d57q"
Content-Disposition: inline
In-Reply-To: <1360835354-31740-1-git-send-email-p.zabel@pengutronix.de>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cPi+lWm09sJ+d57q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 14, 2013 at 10:49:14AM +0100, Philipp Zabel wrote:

> Some mmio devices have a dedicated interface clock that needs
> to be enabled to access their registers. This patch optionally
> enables a clock before accessing registers in the regmap_bus
> callbacks.

This is a good feature but a couple of concerns here.

> +	if (ctx->clk)
> +		clk_prepare_enable(ctx->clk);
> +

This is only going to work if prepare doesn't sleep.  That's probably
fine for the use cases we're interested in but doesn't fill me with joy.
The other thing is that we ought to check the return value.

--cPi+lWm09sJ+d57q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRHNDSAAoJELSic+t+oim9dAUQAI/dJGQwP1uQJ+BZy++tvq3D
iUAgbrB6ZHtCcZn5zJ9FCEgxalx/LHYHf4fbGfmzq2tOqt2UhDhLnBIaxybNeeeB
GXwnbQRWjt0b8ZytsKbnfukLpCIBL7ZXHkt6FoquBVZASsUMJZkNTGZG5tmR6oUY
w7jBzMCGMTzWlYgTHHXy2m6O77gD9Xr8hOjRdrPl2KhiLc/NPNl+MK08Ioot++Fy
0UcSJXkUP5DiqK+0BAd8j5oKs1zzTCFZxjgvh5HkFB+dsp+Rp7iaBHob5di38un6
inK4f/gEYosKKjyZWKzYaVWgnz5P7e3gRpTH3JyyZnWCGZp3VnKYWpZRnX0YMNXq
+HMxUZLVenH0GMvmqA+epgWRSqSGI1s/hXX+fUYDxJMvwQPxYCIQtZMi6QEMJ5C/
bjMN/GEMjrfFdxNg302lgR0aFv2yPUi8vi8wcFx79Fdppwz8o2JAzhzJzNRVE8oP
muKG3VucVD+JwAkRxnZNzlD+wUw/AeVUIZX492vxMxv4YWeehoFWZD0bsQjUPIv1
fY8xN2HJ4bXUJCdXgys+vfcu/qRJ178Zrk4wuh34rQbTuY9iIsS1IH00Q3PaTsUf
0zD33TGgRVlqbYDFV0YGghJfrPwms+i6naEJ5I83MVakf5E+eSWiUN4/ny4Wkh9n
zZEYRzvGxx2fZ/BiRb50
=g5yW
-----END PGP SIGNATURE-----

--cPi+lWm09sJ+d57q--
