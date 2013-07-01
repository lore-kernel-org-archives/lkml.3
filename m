Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab3GAK4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 06:56:42 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41694 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab3GAK4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 06:56:41 -0400
Date: Mon, 1 Jul 2013 11:56:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Sourav Poddar <sourav.poddar@ti.com>
Cc: linux-mtd@lists.infradead.org, spi-devel-general@lists.sourceforge.net,
        dwmw2@infradead.org, manonuevo@micron.com, tqnguyen@micron.com,
        grant.likely@linaro.org, balbi@ti.com, rnayak@ti.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Message-ID: <20130701105605.GH27646@sirena.org.uk>
References: <1372232472-2641-1-git-send-email-sourav.poddar@ti.com>
 <1372232472-2641-3-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KAtLAm/lMQMd2j9H"
Content-Disposition: inline
In-Reply-To: <1372232472-2641-3-git-send-email-sourav.poddar@ti.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] drivers: spi: Add qspi flash controller
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KAtLAm/lMQMd2j9H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 26, 2013 at 01:11:11PM +0530, Sourav Poddar wrote:

> +static int dra7xxx_qspi_prepare_xfer(struct spi_master *master)
> +{
> +	return 0;
> +}
> +
> +static int dra7xxx_qspi_unprepare_xfer(struct spi_master *master)
> +{
> +	return 0;
> +}

Remove empty functions, though...

> +	if (flags & XFER_END)
> +		dra7xxx_writel(qspi, qspi->cmd | QSPI_INVAL, QSPI_SPI_CMD_REG);
> +
> +	pm_runtime_mark_last_busy(qspi->dev);
> +	pm_runtime_put_autosuspend(qspi->dev);

...there's no point in doing this per-message, it should be in the
prepare and unprepare functions.

> +	master = spi_alloc_master(&pdev->dev, sizeof(*qspi));
> +	if (!master)
> +		return -ENOMEM;
> +
> +	master->mode_bits = SPI_CPOL | SPI_CPHA;
> +
> +	master->num_chipselect = 1;
> +	master->bus_num = -1;
> +	master->setup = dra7xxx_qspi_setup;
> +	master->prepare_transfer_hardware = dra7xxx_qspi_prepare_xfer;
> +	master->transfer_one_message = dra7xxx_qspi_start_transfer_one;
> +	master->unprepare_transfer_hardware = dra7xxx_qspi_unprepare_xfer;
> +	master->dev.of_node = pdev->dev.of_node;

There should be some bits per word restrictions in here I think - it
looks like only 8 bits per word is supported.

> +	qspi->base = devm_request_and_ioremap(&pdev->dev, r);
> +	if (!qspi->base) {
> +		dev_dbg(&pdev->dev, "can't ioremap MCSPI\n");
> +		ret = -ENOMEM;
> +		goto free_master;
> +	}

Use devm_ioremap_resource().

> +	if (!of_property_read_u32(np, "spi-max-frequency", &max_freq))
> +		qspi->spi_max_frequency = max_freq;

You have OF bindings, there should be a binding document and an OF ID
table.

--KAtLAm/lMQMd2j9H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR0WBCAAoJELSic+t+oim94VIP/Aoz6R5il9FJauFvD1+gWdit
T5C5gsvsJYBOvMvx599yxn5CiGfCuGMjflIWeWJEyShSCXXyH105idAXS3ormu4a
XxbkkulK496p7hYF8h3Bbkr/dSdt8JnNXteh4NH2OPPVHZX+TXOvxB92SW9tE3bq
W0G4tI7EvG7S6v33s6v76ley4AkpIdVx0yU5956bi8keZ7S3ioI1QG/O/5PLoVfz
/AJIGt6kn5YcCPmhAKbPf9Ll/jULGHx4TT6WDkPb9bnL//AQmtBalRb9uDLAyp+s
vZN1xrdiT6kF61ndOZ13twPlk+ryB1jPD+eGFzfxgEdlGDV93YRASiI3Xs15xtFi
RkiRlKYdZzdvvNGKOeeX8/91zhJg61oOLT0dI5DUsLHOiOYvkkbb+Npook8JXl9o
gTeg5kegzTbGKPSGfp/xs3yhwhT2fnVTN1IXWCYK6yHQX/4WxLlWpwLxEO5ievPb
zOLPBpd3cx2nnRMy29WI99BhQ7IzusJlL+ybFF0Qu9hXB+zf3wi7mnl5UP0IDUQ8
pfgV0riTy3vJ1ne5Wk05EW0RKcg+dz7Gp2SiqlRLxCdqF6RySDOt6YEc2A75QnzO
pboozKo61pZDOj0Qq0PtI5m9i0A9j6FIXa85I3Ge1dJ+ETKyeBbfyTpk8KuEyw5g
rEQ8qfWKzDMtmTdm+tP+
=M0qR
-----END PGP SIGNATURE-----

--KAtLAm/lMQMd2j9H--
