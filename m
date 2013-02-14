Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760887Ab3BNOyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 09:54:21 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42838 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757642Ab3BNOyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 09:54:20 -0500
Date: Thu, 14 Feb 2013 14:54:17 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 2/2] regmap: debugfs: Ensure proper locking of
 `debugfs_off_cache' list
Message-ID: <20130214145416.GQ13249@opensource.wolfsonmicro.com>
References: <1360845108-30428-1-git-send-email-dp@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rKoHqF+aPLVth8b2"
Content-Disposition: inline
In-Reply-To: <1360845108-30428-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rKoHqF+aPLVth8b2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 14, 2013 at 12:31:48PM +0000, Dimitris Papastamos wrote:

> There is a possible race between the read operations of the `registers'
> file and the `range' file.  Close that down by taking the appropriate
> locks when modifying/accessing the list.

This seems like an incremental fix on the previous change; the previous
change introduced the ranges file with a race condition.  If splitting
them up add the lock first and then add the ranges file that made it
needed.

Please do also thread patch series together.

--rKoHqF+aPLVth8b2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRHPqRAAoJELSic+t+oim9AOEP/3BL+3ph9gQQZ+LqVSxF+nib
NIIIFAMzGuHP/Sgc2W56LG2jWwUbm9tWgSVQS8htYifOFM33E0deGl73ypxRZY3L
iYDkEPG4bFE3Ogne6TDzSTEvZg0kB3dsG26Yf+vLxKgeMIhdZONif/v6ql1wu9Qb
mBUWJgRowu1RUCiFIj2njt3kCq6GCsUi6fqRfCT0E3N1GOh56hXzlUqr9FIQeIk0
Pz6T9CJY9PNn6LS3dW6wne9utG67/fvW625IwJSDb8C6iack8FfV07gevbBU9Tzd
AF0AdMbOZm8LUzqztWQ+3JojEvDtsgUUzfnlgaj13cmsDFxNwJXjvninP989VvzO
4HtRLwm4+fPeV+q3yYaYx0qbCx5uRS3nFtoX58Z7ErZi2010xU8S9KjDCOKLZjcx
pPV1YujHO4ZjL8CpUQhBmrCFUjBIBoCL1QSpEw0grwPMROoBqscTS+icji0Gz8PZ
u8k0l9hzZzHALaad1R0N4dUKZfFP6dQCX13Rx59BBpHIvaKsnPhKQcQiBN3WLMWq
xJ9f8C3iG0jU96MQyGRTLb8o6RaJEHw3MobYvX4772tEBRlX1vwQt7LKoUAshd9i
t7PAzmEw3Cf6lUjquU7JwMoHppfsPZBFzO4I1bxekUzala65Zfp/8TpeYIHtjueM
bu9RvESIsJ4RLS+WyCcc
=e8j9
-----END PGP SIGNATURE-----

--rKoHqF+aPLVth8b2--
