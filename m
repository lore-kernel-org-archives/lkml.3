Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457Ab3CNKwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:52:15 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34618 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756930Ab3CNKwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:52:11 -0400
Date: Thu, 14 Mar 2013 12:51:55 +0200
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
CC: <linux-usb@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <balbi@ti.com>, <rob.herring@calxeda.com>, <kgene.kim@samsung.com>,
        <thomas.abraham@linaro.org>, <dianders@chromium.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH 1/2] usb: dwc3: exynos: Use of_platform API to create
 dwc3 core pdev
Message-ID: <20130314105155.GG32369@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1363257898-17504-1-git-send-email-gautam.vivek@samsung.com>
 <1363257898-17504-2-git-send-email-gautam.vivek@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YH9Qf6Fh2G5kB/85"
Content-Disposition: inline
In-Reply-To: <1363257898-17504-2-git-send-email-gautam.vivek@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--YH9Qf6Fh2G5kB/85
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Mar 14, 2013 at 04:14:57PM +0530, Vivek Gautam wrote:
> @@ -170,7 +155,6 @@ static int dwc3_exynos_remove(struct platform_device =
*pdev)
>  {
>  	struct dwc3_exynos	*exynos =3D platform_get_drvdata(pdev);
> =20
> -	platform_device_unregister(exynos->dwc3);

don't you want to do what Kishon did here and have:

static int dwc3_exynos_remove_child(struct device *dev, void *unused)
{
	struct platform_device	*pdev =3D to_platform_device(dev);

	platform_device_unregister(pdev);

	return 0;
}

device_for_each_child(&pdev->dev, NULL, dwc3_exynos_remove_child);

???

--=20
balbi

--YH9Qf6Fh2G5kB/85
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRQavLAAoJEIaOsuA1yqREcP0P/RW25dtnA4FyuLaD6Q7QMHPa
771znPkwXxH4bdlt6u8FLLHMYTmG9ZQNXEGvKjHn3yCqBl4XEwpSVcOmAVcJgJfA
KZvDnPbSjXLWVGdqn94YieiZQ/xaTm+Lam1LjokOnLJlgmZwbuNpX8baVSFfxWrP
/GCjJl0Wh1Ps0Yldr+TpGH9XhMCHkuhe/4mtnUaTcM4Hdr3cpw4Y47oESxJHPgWh
6+BiZ8G69vtEMpoMYpX/rybkI28LFseLEacbRe1aGPbP13MSqpY6Dy6z39s0y9Kc
rU96hM9BJNxFI8i+6jNTd1WCf6YdzkQprc8v/k36Jatq7+CHn4I/Q7hnAt2bY+8X
rAHpiSMN5peL1jMn/xW7zy2LIOO/bFpbPwCCOzD8XiffK4XxR690ZUcVPFL82eb4
Oac7iXFxuoXqT2+ydi1vi60OSrqtK0bmk50NFpkPXMCjfpvfm0Z4AhtsCiVEUA+w
+1SjOPhGsCwtFwwfPvV2jKDnPs/peBpCP0sjrf3TSMsFmwwa6180KyumuLNih6xj
Syj/AoMPrqzhoQFGHhU/qnshOMYW1xGslPgy0kRn0w9UEE1YbapZAZImyWOzzwdS
0zaTd/JFg82WEYyD08vXsr8XM5yAR+bhsJaPHq265TCSEFnDbtnmNb96uVEXWC7I
I+3/2UAdHQ5gOg/79IqA
=6nix
-----END PGP SIGNATURE-----

--YH9Qf6Fh2G5kB/85--
