Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab3LRQ1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 11:27:19 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:56096 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896Ab3LRQ1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 11:27:17 -0500
Date: Wed, 18 Dec 2013 10:25:54 -0600
From: Felipe Balbi <balbi@ti.com>
To: Matt Porter <mporter@linaro.org>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>, Tomasz Figa <t.figa@samsung.com>,
        Kamil Debski <k.debski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dinh Nguyen <dinh.linux@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: Re: [PATCH v7 8/9] phy: add Broadcom Kona USB2 PHY driver
Message-ID: <20131218162554.GF4970@saruman.home>
Reply-To: <balbi@ti.com>
References: <1387309356-17195-1-git-send-email-mporter@linaro.org>
 <1387309356-17195-9-git-send-email-mporter@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Wtrm9ATX0sn6fFKv"
Content-Disposition: inline
In-Reply-To: <1387309356-17195-9-git-send-email-mporter@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Wtrm9ATX0sn6fFKv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 17, 2013 at 02:42:35PM -0500, Matt Porter wrote:
> Add a driver for the internal Broadcom Kona USB 2.0 PHY found
> on the BCM281xx family of SoCs.
>=20
> Signed-off-by: Matt Porter <mporter@linaro.org>

Kishon, are you ok with this driver ?

> +static int bcm_kona_usb2_probe(struct platform_device *pdev)
> +{
> +	struct device *dev =3D &pdev->dev;
> +	struct bcm_kona_usb *phy;
> +	struct resource *res;
> +	struct phy *gphy;
> +	struct phy_provider *phy_provider;
> +
> +	phy =3D devm_kzalloc(dev, sizeof(*phy), GFP_KERNEL);
> +	if (!phy)
> +		return -ENOMEM;
> +
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	phy->regs =3D devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(phy->regs))
> +		return PTR_ERR(phy->regs);
> +
> +	platform_set_drvdata(pdev, phy);
> +
> +	phy_provider =3D devm_of_phy_provider_register(dev,
> +			of_phy_simple_xlate);
> +	if (IS_ERR(phy_provider))
> +		return PTR_ERR(phy_provider);
> +
> +	gphy =3D devm_phy_create(dev, &ops, NULL);
> +	if (IS_ERR(gphy))
> +		return PTR_ERR(gphy);
> +
> +	/* The Kona PHY supports an 8-bit wide UTMI interface */
> +	phy_set_bus_width(gphy, 8);
> +
> +	phy_set_drvdata(gphy, phy);

I think this set_drvdata() should be done before registering the
provider, no ?

--=20
balbi

--Wtrm9ATX0sn6fFKv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSscySAAoJEIaOsuA1yqREK1sP/AtELOQS47cAHu1WkxAIyW4N
k9gSqKh5l7yhAx/ynetfmV/F24ytX+ibr3kLsAYtyZxDn4JB9HZY+AeyCvLLbJwB
+QrCX++fHLodN4cpx88Q+vXMZtaUlWIFbw2N2wBDi4i/urKwx5e8MWX47S3AkxLm
kI4q1Qnsuls34zOTKQUSSyUACYjAboQntHTa3qLlvAODapBRTAn3vpf1Z/7ze3Mx
u+l/1Mj9CXMA70CfrYX4BCZico/anrM/ZhGflfuwmB+vEuhDv62FvuqC3g6aPnNw
jnsglam6KTCKyKrQIwqLbGSSE/49PDuO02sZPKnpOe+D4lUiSyMK6uW8zn+KH4h5
A6n2Ru0PHRNTpTsCIKG3AkCfujDyxeLbiCb0NZuyG3U/tNJDWLDlbcsicgzIGQEG
fJrQnWwL6z4+8EaLbhXKcWIFSS8J7HbTkwtdGlCaoCZHBo0WNTNcpcBGs26l22iS
xIb2JznDgEt6wz4HakXqmsP8q4Dg52jvUGqzmV3ziF94Oulr2lTLqZkFnJkzqBct
fABDRSXehWlXoxMjEwUuBReOIlj4ZTzuTT2ZFQkWiFc42I5HmPywKSNMizzElkQ5
LpOqQjU/ZSf+YcfcLH0ams9nBfe7XIycr6ReV51gRlbr9VvcrjjFLOkPftfSjpPt
jNDa8rNjZnF9Af/Jnnur
=Ay/j
-----END PGP SIGNATURE-----

--Wtrm9ATX0sn6fFKv--
