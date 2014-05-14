Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbaENWOd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 18:14:33 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:48800 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790AbaENWO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 18:14:29 -0400
Date: Thu, 15 May 2014 00:14:25 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Rahul Sharma <rahul.sharma@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dri-devel@lists.freedesktop.org, a.hajda@samsung.com,
        t.stanislaws@samsung.com, devicetree@vger.kernel.org,
        kgene.kim@samsung.com, kishon@ti.com, kyungmin.park@samsung.com,
        robh+dt@kernel.org, grant.likely@linaro.org,
        sylvester.nawrocki@gmail.com, joshi@samsung.com
Subject: Re: [PATCH v3 1/3] phy: Add exynos-simple-phy driver
Message-ID: <20140514221423.GC6215@mithrandir>
References: <1400095043-685-1-git-send-email-rahul.sharma@samsung.com>
 <1400095043-685-2-git-send-email-rahul.sharma@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fig2xvG2VGoz8o/s"
Content-Disposition: inline
In-Reply-To: <1400095043-685-2-git-send-email-rahul.sharma@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Fig2xvG2VGoz8o/s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 15, 2014 at 12:47:21AM +0530, Rahul Sharma wrote:
[...]
> diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt b/Documentation/devicetree/bindings/phy/samsung-phy.txt
[...]
> +For "samsung,exynos4210-simple-phy" compatible PHYs the second cell in
> +the PHY specifier identifies the PHY and the supported phys for exynos4210

I think the specifier is only the part after the phandle, so this should
probably be "... compatible PHYs the single cell specifier ..." or
something equivalent.

> +are:
> +  HDMI_PHY,
> +  DAC_PHY,
> +  ADC_PHY,
> +  PCIE_PHY,
> +  SATA_PHY.

I think you need to specify the literal values here as well, since the
binding must be fully self-contained. That is you can't rely on the DT
binding to be bundled with the exynos-simple-phy.h header.

> @@ -20,3 +20,4 @@ phy-exynos-usb2-$(CONFIG_PHY_EXYNOS4X12_USB2)	+= phy-exynos4x12-usb2.o
>  phy-exynos-usb2-$(CONFIG_PHY_EXYNOS5250_USB2)	+= phy-exynos5250-usb2.o
>  obj-$(CONFIG_PHY_EXYNOS5_USBDRD)	+= phy-exynos5-usbdrd.o
>  obj-$(CONFIG_PHY_XGENE)			+= phy-xgene.o
> +obj-$(CONFIG_EXYNOS_SIMPLE_PHY)		+= exynos-simple-phy.o

Perhaps this should be named phy-exynos-simple for consistency? Also it
may be a good idea to sort this alphabetically to reduce the potential
for conflicts.

> +static int exynos_phy_probe(struct platform_device *pdev)
> +{
> +	const struct of_device_id *of_id = of_match_device(
> +		of_match_ptr(exynos_phy_of_match), &pdev->dev);

Why does this need of_match_ptr()?

> +	dev_info(dev, "probe success\n");

If at all this should be dev_dbg(). But in general the driver core will
already complain if the driver fails to probe, so there's in general no
need to mention when it probes successfully.

> diff --git a/include/dt-bindings/phy/exynos-simple-phy.h b/include/dt-bindings/phy/exynos-simple-phy.h
[...]
> +/* simeple phys */

s/simeple phys/simple PHYs/

Although on second thought that comment probably shouldn't be there in
the first place.

> +#define INVALID	(~1)

This doesn't belong in this header. The value should never be used by a
DT source file, should it?

> +#define HDMI_PHY	0
> +#define DAC_PHY	1
> +#define ADC_PHY	2
> +#define PCIE_PHY	3
> +#define SATA_PHY	4

Perhaps these should be namespaced somehow to avoid potential conflicts
with other PHY providers?

> +#define PHY_NR	5

I'm not sure that this belongs here either. It's not a value that will
ever appear in a DT source file.

Thierry

--Fig2xvG2VGoz8o/s
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTc+q/AAoJEN0jrNd/PrOhk9kQALw31zQf9mXwPqMgetaAf3CY
VOYCpST0GTBy0AqhX3MjVNF+AJH6L2v72aiZUBDpfaBCPZaOhyIPoBCl0/gmmXu3
pms9CZDwb8Rgenf6ZIj8RRuAgD9h8mgjrAkMWCAXF2SZoBp/fngh5EoOSZGjeXtq
zIXXAlMzSk8FbxphuFITKTcDJuDpie1o9J8U0shiNvMWpLBw4NmcFRkHKn8aatwa
pVAgu5cORyyXmL/lV+HxucBfl96mbArz+93LHhqTInwbKWa8XANG5qplluAFfi67
4707d3JGiT0wQOPy/IdjuyzhNrF8dcNGn5KnLecBP6y28wSw5UjrkX0Ku+ne8bBR
MBHxhhfQmIA/Qx1Zb1zhUX9pPm+jvlRXo6pgtPG3cEME8TAfsyblZC1AjIlmGH++
0B1lqeEqWlKzVU8kEpuSucoNUNqvjbmVtpPvL3OGTd7HfrOCHWHBv9HPJ5D5llxA
QKhK4Yb6Jbqg7NiZmpN3Y+CkVTth2zi1/OPbV/orktpiYeDbhMvWZfG/d8/kGGpQ
iQQOJgK97ulfvKOS/18/tvuhuRLibrNtQB4sn/73vz5TZ75UZK0U/Jg3QGK02Rnu
GS5u0x5p3uA1zMCLoTS8Yeqe3St7KDsXuy4SY2L0Ot7+gJI8SAN3H7RBDGvr8LZA
94Knaix7gbGQP3LuNeb0
=a5nT
-----END PGP SIGNATURE-----

--Fig2xvG2VGoz8o/s--
