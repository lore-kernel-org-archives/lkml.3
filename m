Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab3GBKQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 06:16:25 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59671 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755046Ab3GBKQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 06:16:24 -0400
Date: Tue, 2 Jul 2013 13:16:08 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sourav Poddar <sourav.poddar@ti.com>
CC: <balbi@ti.com>, <broonie@kernel.org>,
        <spi-devel-general@lists.sourceforge.net>, <grant.likely@linaro.org>,
        <rnayak@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] drivers: spi: Add qspi flash controller
Message-ID: <20130702101608.GO3352@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372755399-21769-1-git-send-email-sourav.poddar@ti.com>
 <20130702092458.GI3352@arwen.pp.htv.fi>
 <51D2A4CA.5030804@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SavPGzlo48F1Gxyz"
Content-Disposition: inline
In-Reply-To: <51D2A4CA.5030804@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--SavPGzlo48F1Gxyz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 02, 2013 at 03:30:42PM +0530, Sourav Poddar wrote:
> >>+static int dra7xxx_qspi_setup(struct spi_device *spi)
> >>+{
> >>+	struct dra7xxx_qspi	*qspi =3D
> >>+			spi_master_get_devdata(spi->master);
> >>+
> >>+	int clk_div;
> >>+
> >>+	if (!qspi->spi_max_frequency)
> >>+		clk_div =3D 0;
> >won't this generate division by zero ?
> >
> Yes, Probably only an error should be thrown here. ?
> since min clk_div should be kept at 1.

right, if spi_max_frequency isn't passed, this is a broken DT binding.
Bail out.

> >>+	pm_runtime_get_sync(qspi->dev);
> >>+
> >>+	/* disable SCLK */
> >>+	dra7xxx_writel(qspi, dra7xxx_readl(qspi, QSPI_SPI_CLOCK_CNTRL_REG)
> >>+			&  ~QSPI_CLK_EN, QSPI_SPI_CLOCK_CNTRL_REG);
> >>+
> >>+	if (clk_div<  0) {

btw, add a space between clk_div and <

> >>+			dra7xxx_writel(qspi, *txbuf++, QSPI_SPI_DATA_REG);
> >>+			dra7xxx_writel(qspi, qspi->dc, QSPI_SPI_DC_REG);
> >>+			dra7xxx_writel(qspi, qspi->cmd | QSPI_WR_SNGL,
> >>+					QSPI_SPI_CMD_REG);
> >>+			status =3D dra7xxx_readl(qspi, QSPI_SPI_STATUS_REG);
> >>+			timeout =3D QSPI_TIMEOUT;
> >>+			while ((status&  QSPI_WC_BUSY) !=3D QSPI_XFER_DONE) {
> >do you really need to poll ? No IRQ available ?
> >
> There is an interrupt available, I will try using that.

look at how i2c-omap.c synchronizes interrupt with the transfer_msg
code. It just uses a wait_for_completion().

> >>+static int dra7xxx_qspi_start_transfer_one(struct spi_master *master,
> >>+		struct spi_message *m)
> >>+{
> >>+	struct dra7xxx_qspi *qspi =3D spi_master_get_devdata(master);
> >>+	struct spi_device *spi =3D m->spi;
> >>+	struct spi_transfer *t;
> >>+	int status =3D 0;
> >>+	int flags =3D 0;
> >>+
> >>+	/* setup command reg */
> >>+	qspi->cmd =3D 0;
> >>+	qspi->cmd |=3D QSPI_WLEN(8);
> >>+	qspi->cmd |=3D QSPI_EN_CS(0);
> >>+	qspi->cmd |=3D 0xfff;
> Since, we dont know the number of frame lenght that need to be
> transferred and it comes from the spi framework, we keep the frame
> lenght to maximum.
> Then depending on the count value above in while loop, we terminate
> our trasnfer.

what ? seriously didn't get what you meant.

--=20
balbi

--SavPGzlo48F1Gxyz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR0qhoAAoJEIaOsuA1yqREP5AP+QGI/eQ3znaX9WBL4nqPcL5J
1+4mz/qOgMtEHOQdc4njPyaaq+fay2qVwQ0IqezE65nlVKcEv+RX5IA4FC4aCXE/
oqO+I4P3PL1lUQDdusVoZf2VUeq9yZI55z/m2tuFu88QcLK4qKxWig6Ji/MRfaXK
GRCGNz0eUMWyXCfWh/tYCUWctibHg6Rjp4F/73spQC/5ni0L9dsdcNHYaeVKOfL4
+HJBvpMAwsLufrXLkhbIPexr2E2dKtTLHvn3ibxSHnsZJGmEkOoaBCobw+wBCH1g
xuvEAybHxhgukVMR4DAH/pTLK4cFthHHYllgMM/Kx86385+cUuHYcgz4bPUBQpN1
BCNBgqirSFtZgpUsalFh/MNf5CboYs2FZsgR+pO4G3/3WSOxyxk4Ng9dgrWIatQN
ZtmHP1CGifv3E5iLQXKgbnifZUaGU98PRbxYTSm+kdQhoCpXKxXaWmm1p8r+sGUX
/OnQ0uGMXb6VRWRJsEqOr6qqZDkWhT8j2wnCpKqJK1D8Y7wyPyr67nckOJ9haHMw
vngvnCMHbDV2M1HV22wKBn15U1+5QNfLA051ZnuVtHWoXSEv5XO8YD0D+o3KMecG
ReeF/fV4Le6f9kr4Hxi9susqFOSOX1Ich0ayifg8P6wu2Tx2m6OnTsW//lHj1pin
D0x/UqrNCw3bNFAvb3h3
=hyWc
-----END PGP SIGNATURE-----

--SavPGzlo48F1Gxyz--
