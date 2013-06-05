Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab3FEMDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 08:03:55 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48396 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab3FEMDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 08:03:54 -0400
Date: Wed, 5 Jun 2013 13:03:46 +0100
From: Mark Brown <broonie@kernel.org>
To: Illia Smyrnov <illia.smyrnov@ti.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Daniel Mack <zonque@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Message-ID: <20130605120346.GZ31367@sirena.org.uk>
References: <1370432398-7796-1-git-send-email-illia.smyrnov@ti.com>
 <1370432398-7796-3-git-send-email-illia.smyrnov@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VxJb6WgA6MoA+arP"
Content-Disposition: inline
In-Reply-To: <1370432398-7796-3-git-send-email-illia.smyrnov@ti.com>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] spi: omap2-mcspi: Add FIFO buffer support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VxJb6WgA6MoA+arP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 05, 2013 at 02:39:58PM +0300, Illia Smyrnov wrote:

>  - The spi slave nodes can provide the following information which is used
>    by the spi controller:
>    - ti,spi-turbo-mode: Set turbo mode for this device.
> +  - ti,spi-fifo-depth: Enable FIFO and set up buffer depth.

Why is this defined for slaves?  Surely the size of the FIFO in the
controller is a property of the controller not the slave?

> +		bytes_per_word = (cs->word_len <= 8) ? 1 :
> +				(cs->word_len <= 16) ? 2 :
> +				/* cs->word_len <= 32 */ 4;

This isn't legible.  Use a switch statement, or better yet just divide.

> +		level = (t->len < mcspi->fifo_depth ? t->len :
> +			mcspi->fifo_depth) - 1;
> +
> +		mcspi_write_reg(master, OMAP2_MCSPI_XFERLEVEL,
> +			((wcnt << 16) | (level << (is_read ? 8 : 0))));
> +
> +		chconf |= is_read ? OMAP2_MCSPI_CHCONF_FFER :
> +			OMAP2_MCSPI_CHCONF_FFET;

Please avoid such extensive use of the ternery operator, it's not good
for legibility.

> +	} else {
> +		mcspi->fifo_depth = 0;
> +		chconf &= ~(is_read ? OMAP2_MCSPI_CHCONF_FFER :
> +			OMAP2_MCSPI_CHCONF_FFET);
> +	}
> +
> +	mcspi_write_chconf0(spi, chconf);

We have a bunch of return statements further up the function in cases
where the FIFO can't be used which means that if we're in FIFO mode then
hit one of those we'll not disable FIFO mode as far as I can tell?

--VxJb6WgA6MoA+arP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRrykfAAoJELSic+t+oim9eJEP/joKALEnFkt8oXivnsrol9xe
uGySAwG15nrE5BrWF89aL9WamkC6KxiTU724RAhNUrFPstrqqcymVR7Zw9H+BzNm
Ip89zG2flFSG9u0vaHUUVfhiLIkN/y4Yn1kLMb8zygAEU8NEWCm67GV96F38Ln+w
m4sHaRudlW4byZVvjuVcWwrqzPS5c3BqtSQk8YgM/K8S/VKRU/P1mWlMoYb0UfHe
Sac4tdFEMDJL+qJdglCNDNOdrbdcQvfk/Nztkowzvn7QW4nrG9+5eF5rvjcK793b
a/2bh2sHlz/x7jSU1neUm1BdocnOmwuu/yE4VPXCqtRPmBMQPKX/FqLNCx0W7v2i
zsow8hgvAiL03kdGRbke+zd9tuwJPjG0aFqatNGFmeSH7ap5JS+3pi2yS1r/1NMU
7g2JJ7QcxDil7GUJD3WykuvwS6Rot5cjzpI5X2LS75CymXHBVlVWx8qBJH7rvx98
lIUgr1cvRXovFOP1x+9EpMDRH9wIV+L5O6mIX7M/aP/fk+i+sXRAv7xXHC90PPlC
89N2MzhN1iawDGVKqeVTGci1TDv+HrnlE3GX4qTOR7uCBieNg7q8zjaTgvmLSnRE
fKVxUqbzWHBSw+Dmo7/BP+GEYTWysT/lscHu0RBnEGe2bFG4uQoDaNSM1bL2K4k1
6+z3O91lP/W318TbuvJb
=Ks4Y
-----END PGP SIGNATURE-----

--VxJb6WgA6MoA+arP--
