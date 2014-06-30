Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbaF3Qxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:53:31 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38182 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753948AbaF3Qx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:53:29 -0400
Date: Mon, 30 Jun 2014 11:52:52 -0500
From: Felipe Balbi <balbi@ti.com>
To: Andy Gross <agross@codeaurora.org>
CC: Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Kumar Gala <galak@codeaurora.org>, <jackp@codeaurora.org>,
        <linux-arm-msm@vger.kernel.org>
Subject: Re: [Patch v7 1/3] usb: dwc3: Add Qualcomm DWC3 glue layer driver
Message-ID: <20140630165252.GC31442@saruman.home>
Reply-To: <balbi@ti.com>
References: <1404144233-17222-1-git-send-email-agross@codeaurora.org>
 <1404144233-17222-2-git-send-email-agross@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f0KYrhQ4vYSV2aJu"
Content-Disposition: inline
In-Reply-To: <1404144233-17222-2-git-send-email-agross@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f0KYrhQ4vYSV2aJu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jun 30, 2014 at 11:03:51AM -0500, Andy Gross wrote:
> +static int dwc3_qcom_probe(struct platform_device *pdev)
> +{
> +	struct device_node *node =3D pdev->dev.of_node;
> +	struct dwc3_qcom *qdwc;
> +	int ret =3D 0;
> +
> +	qdwc =3D devm_kzalloc(&pdev->dev, sizeof(*qdwc), GFP_KERNEL);
> +	if (!qdwc)
> +		return -ENOMEM;
> +
> +	platform_set_drvdata(pdev, qdwc);
> +
> +	qdwc->dev =3D &pdev->dev;
> +
> +	qdwc->gdsc =3D devm_regulator_get(qdwc->dev, "gdsc");
> +
> +	qdwc->core_clk =3D devm_clk_get(qdwc->dev, "core");
> +	if (IS_ERR(qdwc->core_clk)) {
> +		dev_dbg(qdwc->dev, "failed to get core clock\n");
> +		return PTR_ERR(qdwc->core_clk);
> +	}
> +
> +	qdwc->iface_clk =3D devm_clk_get(qdwc->dev, "iface");
> +	if (IS_ERR(qdwc->iface_clk)) {
> +		dev_dbg(qdwc->dev, "failed to get iface clock, skipping\n");
> +		qdwc->iface_clk =3D NULL;

so this clock and sleep_clk are optional, that's fine...

> +	}
> +
> +	qdwc->sleep_clk =3D devm_clk_get(qdwc->dev, "sleep");
> +	if (IS_ERR(qdwc->sleep_clk)) {
> +		dev_dbg(qdwc->dev, "failed to get sleep clock, skipping\n");
> +		qdwc->sleep_clk =3D NULL;
> +	}
> +
> +	if (!IS_ERR(qdwc->gdsc)) {
> +		ret =3D regulator_enable(qdwc->gdsc);
> +		if (ret)
> +			dev_err(qdwc->dev, "cannot enable gdsc\n");
> +	}
> +
> +	clk_prepare_enable(qdwc->core_clk);
> +
> +	if (qdwc->iface_clk)
> +		clk_prepare_enable(qdwc->iface_clk);

=2E.. right here you can drop the NULL check because clk_prepare_enable()
is safe against NULL pointers.

--=20
balbi

--f0KYrhQ4vYSV2aJu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTsZXkAAoJEIaOsuA1yqREqZQP/0NHxXrXK9f8+PwbSpfrh+Ys
aVAGjGdaFSuAAb6aj6mzkfTn1eUNj1YVVw7HOqSF4NjvhY8u9Sb/E7DZonRZTxe9
EQMBsFgSNnalZyaM1NvpVeavscdmgQEEUuLCYUCEsmbPx07JVRwgeGGuO+ZGTxZW
qTeSJ5gRDbO1//7qSQJ9kyTTv6gykE3AIYwGxrTSz9XBRCMTF7M2hbfyK0GNbOh/
/S3Z3OKU7W4MzUWnFGHYvOXztOmQaHlliJI1LK4XNppQnCR8lXdCHvXBnvmtg58M
YaxXIWvsgliT4gb2leup95NjHlNeYo6t8h1Gg8BtHucucbQeWfYtppdhMvP6wJye
pUv0nXP0jC0vbQ9QSxQFmYWYGlWuxVyrKOmFyryh/cbxDWAN8COJa/riwMXkb7jy
SUlvqzeStQ/uahzurqM29xkRCIn6Cs114c1ksFiBeleTy5Bytgw13bBFz3apERQJ
hM0sYc6q+xcEFNVDS+6PTR1pOGdBBM4pOv3IJMucx49sAq8OyNMkWM6S2w2ARmSl
YH3GJwCm4GIPjPFSypGqObRmD1VFT5Ijd/51Af7OmIgX4vSb+rqCt4n5qwfNtLMJ
VIhJu8+LwNG3I5bn+tDlOJFEiIhj1nLrowt3NAgbekKRh1caSxd6lLXA6oJkRsG3
5yLAJh/8YC0yRSkep7QT
=HA/k
-----END PGP SIGNATURE-----

--f0KYrhQ4vYSV2aJu--
