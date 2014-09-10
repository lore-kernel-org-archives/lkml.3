Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbaIJKVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 06:21:30 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60709 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbaIJKV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 06:21:26 -0400
Date: Wed, 10 Sep 2014 11:21:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Robin Gong <b38343@freescale.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, marex@denx.de, shawn.guo@linaro.org,
        Frank.Li@freescale.com
Message-ID: <20140910102105.GR2601@sirena.org.uk>
References: <1410312604-31949-1-git-send-email-b38343@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lRMsAdG4hjP4MFkn"
Content-Disposition: inline
In-Reply-To: <1410312604-31949-1-git-send-email-b38343@freescale.com>
X-Cookie: Exercise caution in your daily affairs.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 81.132.226.177
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5] spi: spi-imx: add DMA support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lRMsAdG4hjP4MFkn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 10, 2014 at 09:30:04AM +0800, Robin Gong wrote:

> +static bool spi_imx_can_dma(struct spi_master *master, struct spi_device *spi,
> +			 struct spi_transfer *transfer)
> +{
> +	struct spi_imx_data *spi_imx = spi_master_get_devdata(master);
> +
> +	if (spi_imx->dma_is_inited && (transfer->len > spi_imx->rx_wml)
> +	    && (transfer->len > spi_imx->tx_wml))
> +		spi_imx->usedma = true;
> +	else
> +		spi_imx->usedma = false;
> +
> +	return spi_imx->usedma;
> +}

This isn't going to work, anything that looks at the usedma flag will
see the result of the last thing that was checked which may or may not
be the transfer that it's handling.  The driver should check to see if
the core mapped the transfer for DMA.

--lRMsAdG4hjP4MFkn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUECYQAAoJECTWi3JdVIfQWnAH/0TKY6xJ2i+5Tu3FsNwHzYNO
K/37WBHrBc8YOzu7p5MC74fOkyhQAw2/08zSsye3pfsRRqPgyc7MF1zjAuL08D1P
mSDgswdRnFRAL8u+E23YiLt/1b5W0m8jqqYamOk/6K/Hh/9OIO1Vihy6Y8j9g/LW
Z9+s0I3Jf/18kHpfPeJ5FBt5YWAybCBa5hvY2lH090cYmvMWWBasa63bQSFu3tim
bMyqN9Xed6IBWssQq+TrfqMd7/zbYiLL7VnCRbKQ9chu61bziV88CuQIsy2u2riF
CkPcCzbx1TXAbjtNfjT3MV95Kf5Xxifl29ID9pC7cAuD3oPv52WUJEiM3gpLs0E=
=2Lux
-----END PGP SIGNATURE-----

--lRMsAdG4hjP4MFkn--
