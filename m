Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab3GDPlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 11:41:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37728 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab3GDPlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 11:41:10 -0400
Date: Thu, 4 Jul 2013 16:41:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Nishanth Menon <nm@ti.com>
Cc: =?iso-8859-1?Q?Beno=EEt?= Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Taras Kondratiuk <taras@ti.com>
Message-ID: <20130704154105.GD27646@sirena.org.uk>
References: <1371849949-12649-1-git-send-email-nm@ti.com>
 <1371849949-12649-2-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uIl/38eSFNz6qklc"
Content-Disposition: inline
In-Reply-To: <1371849949-12649-2-git-send-email-nm@ti.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH V2 1/8] regulator: Introduce OMAP regulator to
 control PMIC over VC/VP
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uIl/38eSFNz6qklc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 21, 2013 at 04:25:42PM -0500, Nishanth Menon wrote:

> +static const struct omap_pmic_info omap_twl4030_vdd1 = {
> +	.slave_addr = 0x12,
> +	.voltage_reg_addr = 0x00,
> +	.cmd_reg_addr = 0x00,
> +	.i2c_timeout_us = 200,
> +	.slew_rate_uV = 4000,
> +	.step_size_uV = 12500,
> +	.min_uV = 600000,
> +	.max_uV = 1450000,
> +	.voltage_selector_offset = 0,
> +	.voltage_selector_mask = 0x7F,
> +	.voltage_selector_setbits = 0x0,
> +	.voltage_selector_zero = false,
> +};

So, this still has the thing where all the data about the PMIC is
replicated (but now in this driver).  It should be possible to pull all
the above information except possibly the I2C timeout and perhaps the
I2C address (if there's a separate control interface) from the standard
regulator core data structures for the PMIC.  This would allow the
driver to Just Work with any PMIC without needing to add it in two
places.

Other than that this looks good, the only issue I see is where the
driver is getting the data from.

--uIl/38eSFNz6qklc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR1ZeNAAoJELSic+t+oim9TYQP/i8xdUuqYSquZGFqcd6Q4RR6
sx1wtU1lN5tmlgEa/HrSoU/qc8SRO5fvPYXweEbS0YPAlhWq4e9n+cq7nDSbSr7s
YipfiCHA2sGBOzPd5HhU8ZUG+FvDWJ7vTKUuBrl4M7q8QkKkhGUypUC10Lm+MYlt
mMwpNZ2HFhlLOdf7S7TtkW7Agls0rIE+rzkf0VJKQzxNf+qyJA05K8/I6JA6u4nR
FjMfqFeI+770EDoQxyRP4RCM0VUNMPkYcPRRD8p0sRICYxxDLZieaKQfa1MCDuJY
K9BSK0uJhh/Mhvxb8M82LqzuPxK1n903GRXnKC8iWV1op2EmqUVXbB2sxsCC75Ra
fzEfY2n3RbO1TuMQi7LXiMKcl7ej19YjYfwUdwM51DaquBqLsJkx2M1n3A4Ryq5n
Ykm6h56nzBZwwVktf8c7Rs2xxz3mS3T5K1jjE1mj7NdUHwYreB+ynVpyKseMSFp/
Jqe8RKzGD1V4RhAkwezgedDoqihKDftaULPjREwzqihAcirlGLXnatvSGCVZB8Hd
b+/3xTt78WqUtXTmQv9Pu0YXkgwvd0FSWZUt9i8oogm6eS/bE6OV4WgFXrrAmROb
ZqWZvP1PwjgO8Fm+uXWwoGxa4FD/bRkoal+7wJvqwI6p9Fy8SfrChNHQ5MSN/lyP
VmYNnKKBDikfiRFrBX6N
=VOAi
-----END PGP SIGNATURE-----

--uIl/38eSFNz6qklc--
