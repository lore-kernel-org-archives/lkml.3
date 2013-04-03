Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762274Ab3DCLtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 07:49:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45122 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760900Ab3DCLtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 07:49:40 -0400
Date: Wed, 3 Apr 2013 12:49:37 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Girish KS <girishks2000@gmail.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        t.figa@samsung.com
Subject: Re: [PATCH V3 2/5] spi: s3c64xx: added support for polling mode
Message-ID: <20130403114935.GA11305@opensource.wolfsonmicro.com>
References: <1363157014-9615-1-git-send-email-ks.giri@samsung.com>
 <1363157014-9615-3-git-send-email-ks.giri@samsung.com>
 <20130401131207.GI18636@opensource.wolfsonmicro.com>
 <CAKrE-KdWe6aCg0p99BFEeQP-P2nwvdhs2itH3XnHsJMCUjWPAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
In-Reply-To: <CAKrE-KdWe6aCg0p99BFEeQP-P2nwvdhs2itH3XnHsJMCUjWPAA@mail.gmail.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 03, 2013 at 05:00:04PM +0530, Girish KS wrote:
> On Mon, Apr 1, 2013 at 6:42 PM, Mark Brown

> >> -     if (!sdd->pdev->dev.of_node) {
> >> +     if (!sdd->pdev->dev.of_node && !is_polling(sdd)) {
> >>               res = platform_get_resource(pdev, IORESOURCE_DMA,  0);
> >>               if (!res) {
> >>                       dev_err(&pdev->dev, "Unable to get SPI tx dma "

> > It seems like it'd be sensible to also handle failure to get the DMA
> > resource by going into polling mode.

> There are 2 cases currently i have identified and handled,
> 1. The SoC's dont have DMA support for spi controller. For such SoC's we
>  would not add the dma resource in the spi dts node. In this case the probe
>  would return error if failure for DMA resuorce is handled.

That's not what the code currently does...

> 2. The SoC has a DMA support for SPI controller, but due to some x
> reason(H/W bug),
>  the driver would force polling mode by enabling
> S3C64XX_SPI_QUIRK_POLL in driver
>  data. For such SoC's there would be a dma entry in the spi controller
> dts node, and
>  probe can handle failure for DMA resource successfully.

> To handle above both situations successfully if
> (!sdd->pdev->dev.of_node && !is_polling(sdd)) is used.

Right, that's what the code currently does but what I'm suggesting is
that this isn't the most helpful thing to do and that printing a big
warning then soldiering on in polling mode might be more useful.

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRXBcsAAoJELSic+t+oim96fsP/RhiTZ91dmWgeSPyaFJRH/YV
IDzCxckxnpPq7oBqolr+WC2ahiyONzKPuy5Dc66JZhwKP0+tK1I4tY6bUclwYFr1
attmwrSQdpIhkk5Yj2CUX6JqzZRyEZEPaZ7JlpcMMsVPjTYs4OG5ggLXGbirFfgs
XlUf+o6pvwZgaRPddua8M0QmjR4IQso/HwRWB0JOTXCN4tgorpi5hZ1GbI5enWSX
zfqgKQvI8IAnzDU5JKZmvTg0WYTsZPNX7pj0BspqIYe/JRUjlaAZxTBiD5b65u7R
MLNMi6zYgzvZ5jb2RokG0AFYpgrVfYC1CriAPnnTm7HcDmJbGCHbHQGtuHrUloP5
SezExXq3MRP96PSUjEdPHbupvHKRhw+Ph3N9codNt77TWhuEdJFxODERmf8cvdHA
0ToD/7zta4ta1xgHtnQREci2C4ya/sKQaTugHWHeuGrUsx3N4wAN+QBdqmNDiE4y
w14iJo/XTWSmerKa1bg4wFq1PlW7PCowG5/gN4KFetuCAh04YWFQq4/NIzy/meio
qK/I3/GYPgTS6vPqiJZrGoPE0ZiqYhdId7tXxY/xT0aMLr4f182RgK9nTwtJKG9P
iG2id33TcoBH6df05eqroHSU3H3XlmY/5ZLjKNhhSCCPZBLWWsgDHeQwpn9RJciu
SW4SchIDlxLgFo2k57ks
=6HlI
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
