Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbaHVAvG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 20:51:06 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54037 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448AbaHVAvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 20:51:04 -0400
Date: Thu, 21 Aug 2014 19:50:30 -0500
From: Mark Brown <broonie@kernel.org>
To: Robin Gong <b38343@freescale.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Frank.Li@freescale.com,
        shawn.guo@linaro.org, marex@denx.de
Message-ID: <20140822005030.GR24407@sirena.org.uk>
References: <1408593190-1031-1-git-send-email-b38343@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uAY1Vrrb3oVaqxed"
Content-Disposition: inline
In-Reply-To: <1408593190-1031-1-git-send-email-b38343@freescale.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 208.59.64.2
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3] spi: spi-imx: add DMA support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uAY1Vrrb3oVaqxed
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 21, 2014 at 11:53:10AM +0800, Robin Gong wrote:

> Change from v2:
> http://thread.gmane.org/gmane.linux.ports.arm.kernel/291722/focus=294363
> 1. dma setup only for imx51-ecspi
> 2. use one small dummy buffer(1 bd size) to templiy store data
>    for meanless rx/tx, instead of malloc the actual transfer size.

You can use the must_tx and must_rx flags to use the core implementation
of this functionality.  This will mean you get any performance or other
improvements we implement there.

> +	int (*txrx_bufs)(struct spi_device *spi, struct spi_transfer *t);
> +	struct dma_chan *dma_chan_rx;
> +	struct dma_chan *dma_chan_tx;

The SPI controller has variables for this already - you should use them
(and the core support).  In general my main comment on this patch is
that you should be using the core DMA support, it fixes some problems
(like not having mapping for vmalloc() buffers) and factors out some
code.

--uAY1Vrrb3oVaqxed
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT9pPTAAoJELSic+t+oim9MY0P/RclDEBWSGFKDrO98Sfgbcgo
7bCCzB+xENogpwedLzVcEZeZsvt9igFLm7t0CaXnEJv7/fB5rN3bFzvYYHyGkM82
pCgplHwyjZculow1+LddjCHuPvPeL3dGYfeV1Jtvi3uPvpRUkTx//rtQREoHpvPg
GUPU+7huxAds7Prkx+1nKq2KMl9aHz/p27FJJCbKBwvdgRIVqd9Cz0ZnzhA+LKqb
eav74fNNaDn/KI1QL5S9BtS5JrMrQaNsEXkgSdGEkioqx4Pk8+R7dPFDLTn4Thtv
UGWYRm+oHRAKBETGY/JAF5MuTlsxTY1Jn3TX29Tm2DBMnRnrN1YEyTs8tGGP/GU/
04fq20HJWwODK+9fJOOYNjnTxQuByZZLrD/PfFuklc9Q8oN4HQACnBCBcq6zEkBJ
ZZW9pKjEPbu15LHDyqgxC2M/T3gYuIuLEHhoERE6ALZKKBpE1YG5s+Z+0AnnJRHu
EKeh62h/es04yQdOK2qiAiwXygn58k22cqdoy/gXni7n3A4dFEvSlp2uSFTmCOY4
7wJuFRmMjUQ/EDPsK8jnGIIuTiZLepilM0+BK8STHwrazt9Z1wCGJJq4DQ/8OfB2
jZtAhUrhLsWQpMIIidBU+2unQHWxxP+zZ11d81KRgbz7HPXDJCp6EVLp8uJ6jiZa
o6rFDeK5DnFYTwH+3SQf
=mcz3
-----END PGP SIGNATURE-----

--uAY1Vrrb3oVaqxed--
