Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab3FDRhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:37:00 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39220 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734Ab3FDRg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:36:56 -0400
Date: Tue, 4 Jun 2013 18:36:32 +0100
From: Mark Brown <broonie@kernel.org>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
        Peter Crosthwaite <pcrost@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        spi-devel-general@lists.sourceforge.net
Message-ID: <20130604173632.GM31367@sirena.org.uk>
References: <041d7ca272ef9499fab630294e3395110b3e31ac.1370354549.git.michal.simek@xilinx.com>
 <c5f546072e530c42e7ca15745ffa16729d72a5ac.1370354549.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Jz4B0QKJ3xxfGEtb"
Content-Disposition: inline
In-Reply-To: <c5f546072e530c42e7ca15745ffa16729d72a5ac.1370354549.git.michal.simek@xilinx.com>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] spi: spi-xilinx: Clear dma_mask for xilinx spi
 controller
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Jz4B0QKJ3xxfGEtb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 04, 2013 at 04:02:35PM +0200, Michal Simek wrote:
> From: Michal Simek <monstr@monstr.eu>
>=20
> mmc_spi driver tests if dma is available
> through spi->master->dev.parent->dma_mask.
> Microblaze supports DMA but xilinx_spi IP doesn't.
> That's why clear dma_mask in the driver.

> +	/* clear the dma_mask, to try to disable use of dma */
> +	master->dev.dma_mask =3D 0;
> +

This looks like a bodge in the wrong place.  Either the device
registration is incorrect in that it advertises DMA when none is
available or the SPI driver ought to be offering the MMC driver a more
sensible way of advertising this limitation.  My first thought is the
former but I didn't check where dma_mask is getting set.

--Jz4B0QKJ3xxfGEtb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRriWdAAoJELSic+t+oim9b4kP/0WvORnjYhLKaAQ+TW4sE75J
ENjilKSuWAXfCuQaeQxzf/qRYEQgCY5C61C7TFjpdosL/Kbn2JztRz5UlInXPOSu
7S7jKwO2zwke3tPiV10QLEWOXe4jcJMRvuE8YIpjaUkB1os5Ra+eU9yahoK1t7Xf
EPIN8poBpf4MiB6LONGsY7+6nWMNEs9KUat62btNxO1Eko1Rheu3fDmMHlFVSqxi
YDKHUQuHqDX7N1Nm+Rmz0Nfn9jNzlAXkFid9wxlVu06OI+iLjrjdoRp82AUfsRN+
6LqG1pk4oNpctu6adyHlOXNQuBZR5FqTZXWREvtyDEQD47YvwRNNPj55rHPfoGpn
Zv/wi2Z1PNTYP/SlyFCR3ei6YEHjDKA6/4UDHMXjY4D1pH/Z4evZZj3c88GyxUf1
w9l7/eqC7FeNvTHucovP9IQF7K9BJumgthw0Y//BAHiM2Atg7L/wbh1uHI9/4J8w
G+xIbci7EBwo8+e4WiNRk5tdfLQuDFP7VcKlGy6nNgsDdHSNZXRz5AL69QkPmNm7
exTrqyTQs+sS08E5PqV4trRaVpQMfmnxyAL4wDVyAi5gZ07y/MQ7Z2j//CPGOCa6
oAl+EFJiYwBn0S2KuaFhluFkGaJlKWvue0naj36px8Hx9cAfaq3lTTrmRKFURJXg
3USKvZeEvlKLES812GDa
=QTnG
-----END PGP SIGNATURE-----

--Jz4B0QKJ3xxfGEtb--
