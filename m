Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab3FJKcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 06:32:06 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45609 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab3FJKcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 06:32:03 -0400
Date: Mon, 10 Jun 2013 11:31:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Nishanth Menon <nm@ti.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Tony Lindgren <tony@atomide.com>, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <20130610103131.GR31367@sirena.org.uk>
References: <1369246717-4167-1-git-send-email-nm@ti.com>
 <1369246717-4167-2-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gxw6znBFH3c9xIzC"
Content-Disposition: inline
In-Reply-To: <1369246717-4167-2-git-send-email-nm@ti.com>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH 1/4] regulator: Introduce OMAP regulator to control
 PMIC over VC/VP
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gxw6znBFH3c9xIzC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 22, 2013 at 01:18:34PM -0500, Nishanth Menon wrote:

So, the biggest problem here has been patch 4 (having to have a hack to
deploy this stuff is a bit worrying) plus the general not having a real
driver thing.

> +- ti,i2c-slave-address - I2C slave address of the PMIC
> +- ti,i2c-voltage-register - I2C register address where voltage commands are
> +	to be set.
> +- ti,i2c-command-register - I2C register address where commands are to be set
> +	when OMAP enters low power state. This may be the same as
> +	ti,i2c-voltage-register depending on the PMIC.
> +- ti,slew-rate-microvolt - worst case slew rate of rise / fall for voltage
> +	transition in microvolts per microseconds (uV/uS)
> +- step-size-micro-volts - Step size in micovolts as to what one step in voltage
> +	selector increment translates to. See example.
> +- regulator-min-microvolt - Minimum voltage in microvolts which is supported by
> +	the PMIC in ti,step-size-microvolt increments. See example.
> +- regulator-max-microvolt - Maximum voltage in microvolts which is supported
> +	by the PMIC in ti,step-size-microvolt increments. See example.

The other thing is this whole business of encoding the properties of the
PMIC in the DT like this.  Paul Walmsley has started doing some work for
some similiar hardware where instead of doing this the regulator is in
the DT as normal and then the driver for the offloaded voltage scaling
gets the information about the register layout from the regulator
driver.  This is a bit neater overall and would cope with determining
which method to use at runtime.

--gxw6znBFH3c9xIzC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRtasAAAoJELSic+t+oim9jasP/2dvydlJLP5IbSvqaG/6tgke
O0T+KfvVqYSyaOFL6ob3x+PCKHkj9NvTxYPtvt+X45hrxJs+DELupn+FK76rFxdC
KsEBi6kev9wZUFBMY0WgRTxPuk89vS8xJuFSB4gHEqvAyTlx6GqHIO5csllPP4gD
bZR2VhCRoPnNCEd5oUg47zlh316Er3GhcXbOq8Q7uR9+y3IWFEdf0tZ6GkjPr/uZ
2zBtPDni0uD3hDmULYSqLEcKoGWKpfiscjtl9lpupyY8dZNLkbBFPpvSObaFbpn0
WDM8zIpXPKl6ruoHAt1jnZn413PmfVrbrPanfFFVe8nDJfJLQNVVt3YkzZrRLLln
oevtYLhxxOCug0HCQdBSCQpNsVDEa48HV7AvprBOPm8+HPhafw8PtmV3lYFKkadA
Xr1dDMQZYMzhjsVsFgV4jjMpbqGJS+xm0oD+nsU84scOM1ju671Qd1HBl0DVdJjv
tPqO+D3IAt2ImBcGa4AR6+hqzBiNRjNTdXGnn25kViOedMDm93w3wGkL8OLPrGo1
A06Q5hxJaZLgvZLdFGSwAwofAst34WxAD7QA1UT0I1Rf620Vn+2ZjUKq41QcKOrt
6c2g0C1OmAgMrIKtAAaoUAyKdZtI98KfNS9ARfgQYwgYd5XjrGrSfS41VDMGP1Wk
Z2qYTM5PE4PLqKo8oAqV
=PxT3
-----END PGP SIGNATURE-----

--gxw6znBFH3c9xIzC--
