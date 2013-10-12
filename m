Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab3JLMOj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 08:14:39 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37830 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab3JLMOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 08:14:38 -0400
Date: Sat, 12 Oct 2013 13:14:12 +0100
From: Mark Brown <broonie@kernel.org>
To: Wei Ni <wni@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20131012121412.GJ2443@sirena.org.uk>
References: <5253A17E.10503@nvidia.com>
 <20131008090910.GW21581@sirena.org.uk>
 <5253D489.7010900@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OX7PPUk8qMPP4++R"
Content-Disposition: inline
In-Reply-To: <5253D489.7010900@nvidia.com>
X-Cookie: Time and tide wait for no man.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: About [PATCH 1/2] regulator: core: Provide a dummy regulator
 with full constraints
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OX7PPUk8qMPP4++R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 08, 2013 at 05:46:49PM +0800, Wei Ni wrote:

> In the regulator_dev_lookup(), it will try to read the "xx-supply" to
> get the regnode, but I didn't set the vcc-supply in dts file for lm90,
> so the of_get_regulator() will return NULL, then the
> regulator_dev_lookup() will set the ret to -ENODEV, and return the rdev
> as NULL.

OK, I think the device tree board code just needs to set full
constraints during machine initialisation.  We can't have multiple
initcalls in the regulator code and doing it there is really a bit of a
workaround anyway.

--OX7PPUk8qMPP4++R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSWT0RAAoJELSic+t+oim9qrwP/1AzXlbQUjIozkLPOAOabHV8
7dcewa/tF2cmnRWkhp/5jp23MzaLTXNqIwK1OmBCGCIs0l3wlMfjpcZLYRSI3RTE
B/ANrw6Neubj0WC1qYKacJy5OYrBXU84S2vxTzuZGZwLaTqioqJbkJtiFHpaDZ8J
/RVY5m7ZYFWuZsJToGLvr45AApplqwffGDvEK7oDAW5bgESy18+smMp/SzCwQCDd
7IaDRfJqN8h8f84wodv+jTEnWgaRd/LSdse9h+uXZZieUZgNgPMoplLpabzxJZvz
LtvFE7LEM20XF7r2JzXAJSHEYIxqnVnAmaSUk8UAbFSC7A8hSTWnd/GWxB7CL52V
bI2Hdu4hfeoCFbbnral9ecJg/+Soed8PNhA++SewDgTtc0chpj0/bauioFBFmXm3
QoQ5n5x+lkzTknhW3E9+/nG42rD7b4JK+G2wc7hhwFNBchOnVf+30Jjp8A+uR/UM
PFLmAvOIraMNYQ5vcFzKVJRj6FKywPs1rqilHJZcN7uK63FS2kvfAjdaStySVZNd
BmyxN+LaIGpuzfnlpXBb9S7BiP1qJomxZgjTmfO35G5CLHNbKxVZn+/bqNviQ3jr
8YeryNVDeynnNdaE3cY5VZ9jZHaGwcKMjRAcgB18weILt2gwtfjJh37KALIy++1V
hXLtYSFuCDlAcWSrXzH6
=KhHX
-----END PGP SIGNATURE-----

--OX7PPUk8qMPP4++R--
