Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922AbaLVSgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 13:36:50 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44271 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513AbaLVSgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 13:36:48 -0500
Date: Mon, 22 Dec 2014 18:36:22 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, linux-spi@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20141222183622.GI17800@sirena.org.uk>
References: <1418156491-26613-1-git-send-email-lee.jones@linaro.org>
 <1418156491-26613-2-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JVYm2bz4YjPqKA1I"
Content-Disposition: inline
In-Reply-To: <1418156491-26613-2-git-send-email-lee.jones@linaro.org>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 31.51.36.65
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 1/2] spi: Add new driver for STMicroelectronics' SPI
 Controller
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JVYm2bz4YjPqKA1I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 09, 2014 at 08:21:30PM +0000, Lee Jones wrote:
> This patch adds support for the SPI portion of ST's SSC device.

I've applied both of these, though I had to rename the DT binding
document and...

> +static int spi_st_clk_enable(struct spi_st *spi_st)
> +{
> +	/*
> +	 * Current platforms use one of the core clocks for SPI and I2C.
> +	 * If we attempt to disable the clock, the system will hang.
> +	 *
> +	 * TODO: Remove this when platform supports power domains.
> +	 */
> +	return 0;
> +
> +	return clk_prepare_enable(spi_st->clk);
> +}

...this is not good at all and a step back from the previous version -
if there are problems with the SoC integration they need to be fixed
there or possibly in the clock driver for the SoC rather than bodging
individual drivers.

--JVYm2bz4YjPqKA1I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUmGSlAAoJECTWi3JdVIfQJgwH/j5xvlYeLnIyX2q/gQcTCfHq
rrufgC86ehgmz6G5/XX4x3BqABOb6B0eSlqVXXoQlPQaxjUunqNuxkCdZsjJGIhf
h/Hd06mhXTBaX7CHAjzrb64jC0+swR3Lc9oINiBgHhBMdYFBkSj4gZ7PzGOh84CR
o0ECcrvegRDiolJr16+5egnrkouWUsLV0WIkaM3WzeOVnbH3ELcMdfQTVR9H0CkC
DrCtgq1yds5TJE9A64T9GvyrRxQvomL4dwBBN8JYcCdheXQSgwpMKwCZvZ5qjb3W
J7VzcWqJZBxqszeSj2jnvuBoW+7Yk6o7wyhGsn3DNTUmKfK1VTdrcQfMBbL44V0=
=qScH
-----END PGP SIGNATURE-----

--JVYm2bz4YjPqKA1I--
