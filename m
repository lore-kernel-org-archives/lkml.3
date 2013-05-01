Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761533Ab3EAPr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 11:47:56 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60806 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761451Ab3EAPri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 11:47:38 -0400
Date: Wed, 1 May 2013 16:46:29 +0100
From: Mark Brown <broonie@kernel.org>
To: Mehar Bajwa <mehar.bajwa@ti.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        liam.r.girdwood@intel.com, navada@ti.com
Message-ID: <20130501154629.GP26160@sirena.org.uk>
References: <1366119816-9719-1-git-send-email-mehar.bajwa@ti.com>
 <1366119860-9754-1-git-send-email-mehar.bajwa@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bvgsfYmVhxWy/2TA"
Content-Disposition: inline
In-Reply-To: <1366119860-9754-1-git-send-email-mehar.bajwa@ti.com>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 212.183.132.78
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2 2/4] mfd: Interrupt handling support for AIC family
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bvgsfYmVhxWy/2TA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 16, 2013 at 07:14:20PM +0530, Mehar Bajwa wrote:
> This provides Interrupt handling features for common interface
> to series of low power AIC audio CODECS.

This looks like it should be able to use regmap-irq if you fix the page
mapping open coding in the core.

> +	if (aic->irq_base) {
> +		aic->domain = irq_domain_add_legacy(aic->dev->of_node,
> +					ARRAY_SIZE(aic_irqs),
> +					aic->irq_base, 0,
> +					&aic_domain_ops, aic);
> +	} else {
> +		aic->domain = irq_domain_add_linear(aic->dev->of_node,
> +					ARRAY_SIZE(aic_irqs),
> +					&aic_domain_ops, aic);
> +		/* initiallizing irq_base from irq_domain*/
> +	}

irq_domain_add_simple().

--bvgsfYmVhxWy/2TA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRgTjSAAoJELSic+t+oim92VIP/Ax9ZOXdciXdksJBjeUYkJl9
JY9MRuH3EVUIxvgugsbWufsGkVKS9M2aMP21eSv3WVEqL4z1TFVr3BBW+FFk3fhl
gyJkJ+J8Z4D5H7GDpOfLlgFJ5B8tQG1+qOdV/PXqYTHUrtO31N5K4Pr4278D7zQs
Q2txVDU+nRrspgnU5ZtCw19JnBB5K3pjGHx/6SSU9DCpwDjLDGntFLqYAmp0+aLe
BxeYBvkCK42M2cImWDFQ8qcQGHesJsn+G8T+4yT8nrsV7YXBUhWgOlLKMDD+9+Ki
3WzpIz65NVaX/tjkKPk311UpocPKJQ5x805lOqy5v6Opc0HwwVcbs5kLdohYfQy8
e/74kZOIBaafQKcjuWvWMeOUpnpuhyfZtId4MyjQQOw1RYLDwcrhnrMDnp5RRxgM
mSTWDnfaWoiZydOsIhjns/1mAZeX1A1JZG+rZN+zeS6f18PNUlOxWNXNLprHQETH
rqzn0ZjaVm/PxyFEjlBPNDdY9T2Q8XbDE+8NmbQtNuQ57zDaqUk+0bWWjVSgDl8q
UwyQQIo7/fDXQEJi3bGubtSB/hpyEgwZWIY8LblWOkP/qfwIKYII40k1Hi1tcMo3
2GGPmgpwkfaHwRPfbCL9Y4XUHfimnu6JtIBlE0ZshmWp6N6/fS9kCquFz/Z5htVp
Byv6ih/jTnz0jJCnY8xS
=lrjx
-----END PGP SIGNATURE-----

--bvgsfYmVhxWy/2TA--
