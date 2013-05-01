Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab3EAPoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 11:44:25 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60783 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab3EAPoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 11:44:17 -0400
Date: Wed, 1 May 2013 16:43:46 +0100
From: Mark Brown <broonie@kernel.org>
To: Mehar Bajwa <mehar.bajwa@ti.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        liam.r.girdwood@intel.com, navada@ti.com
Message-ID: <20130501154346.GO26160@sirena.org.uk>
References: <1366119816-9719-1-git-send-email-mehar.bajwa@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9DptZICXTlJ7FQ09"
Content-Disposition: inline
In-Reply-To: <1366119816-9719-1-git-send-email-mehar.bajwa@ti.com>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 212.183.132.78
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2 1/4] mfd: Initial support for Texas Instruments AIC
 family of CODECs
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9DptZICXTlJ7FQ09
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 16, 2013 at 07:13:36PM +0530, Mehar Bajwa wrote:

> +/**
> + * set_aic_book: change book which we have to write/read to.
> + *
> + * @aic: Device to write/read to.
> + * @book: Book to write/read to.
> + */
> +int set_aic_book(struct aic *aic, int book)
> +{
> +	int ret = 0;
> +	u8 page_buf[] = { 0x0, 0x0 };
> +	u8 book_buf[] = { 0x7f, 0x0 };
> +
> +	ret = regmap_write(aic->regmap, page_buf[0], page_buf[1]);
> +
> +	if (ret < 0)
> +		return ret;
> +	book_buf[1] = book;
> +	ret = regmap_write(aic->regmap, book_buf[0], book_buf[1]);

This looks like just like register paging - there's support in the core
for that, if it's not adequate then just extend the framework.  Looks
like the pages are multi-level so perhaps that's required.

> +	dev_info(aic->dev, "%s\n", devname);

It's useful to display something like a device revision but if you're
just announcing that the driver has been loaded that's not so useful and
should be removed.  Similarly for the others.

> +#ifdef CONFIG_MFD_AIC_IRQ
> +	if (aic->irq) {
> +		ret = aic_irq_init(aic);
> +		if (ret < 0)
> +			goto err_irq;
> +	}
> +#endif

This doesn't look like it should be a config option?  If it should be
then these should be done with inline functions in the headers for stubs
rather than ifdefs in the code.

--9DptZICXTlJ7FQ09
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRgTgvAAoJELSic+t+oim9RfsQAJcFTW6vdVNDg7bSYlPHuoeI
jbThlciEJwAE/AAv8uKD7Q4JgoiEI1CbkXw/gYAk3SiLoTcvHpH8PFOuYY3nRvNJ
sowE898LPwcyEx35sCteQs6azrSNBfp57l/lpr7kn8PLvXlYqX/X8D1y6MteZ7Jv
gcnWG6JZ0mZUULM0Iac9s4j5qrQmBW6OWxyMcET7JzU8Y8SciHTjdla6hoQzuD3k
ts6sB3elMy8JD/VJUz0HaDXB+c4/uXoi/TldHjDT2ExAlsFV4o59CuOaRM6Dgykt
M3/Gm1cCk5G3A2L6ZDFGIqjMcZOx213EOGsAFkt0wK7lVNny5Bf2ZVT+N2cjtnJB
AjSMSGk17a8Pan3Bvrbl09LwSxbI+f10z9ug0WpSKBSOmUTlASw0kh4GtSbcL4Zl
pE1h+MTGVguL5wpkjegLauwkVurmw1xVOyyahfTkvl8cdhKXN1Jl/n6QUd9kwvSS
ejMlyDEKb2kV9KpUSXcnBRE5ES4szdyKNQ29RznK/qXpZI6Io4xN8NfRvu3Gw4FH
pIFGrlpAMk6GGGjbDzG759tdmo57dBAeAGmB/A+7C5P9cbR8V9NtJlL+pcFh7fuy
p9uLm+eihZbtBarCtRvwOcvGVa8LEcjI8gEbpuqpgKzgjsE1CqN6JTSzR1K/9JzC
HOYK8rtoQAmxVL2QWpmX
=C3nV
-----END PGP SIGNATURE-----

--9DptZICXTlJ7FQ09--
