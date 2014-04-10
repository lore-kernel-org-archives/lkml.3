Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759223AbaDJWsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 18:48:51 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48192 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823AbaDJWss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 18:48:48 -0400
Date: Thu, 10 Apr 2014 23:48:25 +0100
From: Mark Brown <broonie@kernel.org>
To: Harini Katakam <harinik@xilinx.com>
Cc: grant.likely@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, michals@xilinx.com
Message-ID: <20140410224825.GI6518@sirena.org.uk>
References: <1397132030-2440-1-git-send-email-harinik@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mMdCh5/a0q2ATNCM"
Content-Disposition: inline
In-Reply-To: <1397132030-2440-1-git-send-email-harinik@xilinx.com>
X-Cookie: This report is filled with omissions.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 1/2] SPI: Add driver for Cadence SPI controller
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mMdCh5/a0q2ATNCM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 10, 2014 at 05:43:49PM +0530, Harini Katakam wrote:
> Add driver for Cadence SPI controller. This is used in Xilinx Zynq.

This looks mostly good, the issues below are very small.

> +static int __maybe_unused cdns_spi_suspend(struct device *dev)
> +{
> +	struct platform_device *pdev = container_of(dev,
> +			struct platform_device, dev);
> +	struct spi_master *master = platform_get_drvdata(pdev);
> +	struct cdns_spi *xspi = spi_master_get_devdata(master);
> +
> +	spi_master_suspend(master);
> +
> +	clk_disable(xspi->ref_clk);
> +
> +	clk_disable(xspi->pclk);

You're only doing clk_disable() here, I would expect the clocks to also
be unprepared over suspend - there is no value in leaving them prepared
that I can see.  Just use clk_unprepare_disable().

It would also be good (though not essential) to implement runtime PM and
disable the clocks while there are no transfers in progress for a small
power saving.  The auto_runtime_pm feature in the core will do the
runtime PM calls for you.

Otherwise this looks good.

--mMdCh5/a0q2ATNCM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTRx+1AAoJELSic+t+oim9YVkQAJ2dUex91vcYl6b65nAPLgvJ
i8TriQvUQ5Sa0x4SJiaNp/42gnDDZY0697g4OL6SNozLmhbK+e4rJGH0pIW6Qnnw
2c3oOj2zoImBaKC3psdXbwNAwib3AGFpMCXvL+xJr6vQUuFKoSne2R1WI4YbT+NA
JGR4IVXhxU/pLF/xFXUMMFEMMLnf1g56GukVILzehocAvpBqOm0mXeoZrUDBJRxU
4NYGQE+EGDZKRse4UryQ/LcgZreHUuaMTAj93B+emrmxwixhJhKVOtE1iLsDwoCV
olUQ81ZmiKNVNY6cE2+9z+nDOxRdjCoqqPG5SOViFJAPZa9ot6/4PrpmD89DvtiR
t5TzdkZMoHRvz0PahpE+aR5Crv5GTYX5WulrGmWCN12v42Op6uceh0PBpEtg9lVV
fcbnRPFC2WqZzdiSCcfP3w8neVpQlsCz7ZyQThmEJvX75FUvj03eL8NWfIWIdckw
JojHpijnbhWpI1lvOLoHOLJcq336mUmmxe9MbsE0mUI2noxq6XMz0hpPc3THGvwT
1rR07nG3Ib2t0XdVXNIvh34vQhOc6xISDkUgK2CrsC+GGAnp6wtFmi53kDOGH9Ru
yPUe66bNNeP5HF9QQHLyszWnwCA37928pbQK/iSFjBw9YlWJzxMYZ9W6blNI0KK+
vvxIXt5Zr1YivmkvaYGM
=3GyS
-----END PGP SIGNATURE-----

--mMdCh5/a0q2ATNCM--
