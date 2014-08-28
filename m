Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956AbaH1TRK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 15:17:10 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33674 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbaH1TRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 15:17:08 -0400
Date: Thu, 28 Aug 2014 14:16:25 -0500
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
CC: <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <balbi@ti.com>, <kishon@ti.com>,
        <kgene.kim@samsung.com>
Subject: Re: [PATCH 3/5] phy: exynos5-usbdrd: Add facility for VBUS-BOOST-5V
 supply
Message-ID: <20140828191625.GQ16689@saruman.home>
Reply-To: <balbi@ti.com>
References: <1409212920-28526-1-git-send-email-gautam.vivek@samsung.com>
 <1409212920-28526-4-git-send-email-gautam.vivek@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IpljlC28XhFjURzf"
Content-Disposition: inline
In-Reply-To: <1409212920-28526-4-git-send-email-gautam.vivek@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--IpljlC28XhFjURzf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

hi,

On Thu, Aug 28, 2014 at 01:31:58PM +0530, Vivek Gautam wrote:
> @@ -457,11 +458,19 @@ static int exynos5_usbdrd_phy_power_on(struct phy *=
phy)
>  	clk_prepare_enable(phy_drd->ref_clk);
> =20
>  	/* Enable VBUS supply */
> +	if (phy_drd->vbus_boost) {
> +		ret =3D regulator_enable(phy_drd->vbus_boost);
> +		if (ret) {
> +			dev_err(phy_drd->dev,
> +				"Failed to enable VBUS boost supply\n");
> +			goto fail_vbus;
> +		}
> +	}

really this is nitpicking, but can you add a blank line here just make
my inner child happy ? :-)

> @@ -470,6 +479,9 @@ static int exynos5_usbdrd_phy_power_on(struct phy *ph=
y)
> =20
>  	return 0;
> =20
> +fail_vbus_boost:
> +	if (phy_drd->vbus_boost)
> +		regulator_disable(phy_drd->vbus_boost);

same here

--=20
balbi

--IpljlC28XhFjURzf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT/4AJAAoJEIaOsuA1yqRESDoQAIBd5UzXO5RFWx3ewB1JM+b+
m6d6PPK1YgdkQxbzfV/I+Pz2BHPMteUcIibYgcvfLGY1V7l6UCvIc7riWQOR97b0
o/5WM4BzMzHk3I4iZu58iPRNGmK/c/w9M28ZCRjdII2bpvswawv4QtSuVRqS0pab
UF5OgF5X7of+JtiWbpa0NqQxv7lGFR+bSElIwPGK6ETEXZ+JWlbIUZ5J7k6MTdY8
b3A4NsSqfPAncV+hsCebCKB/6S7k+pdPpcFTPAd1sC7twd3zNQv2qAuC2+01FKTd
h2lR47F2Cflnbyt0hA9lmVmZWbGMEWk0GxWJdJ0fC1FGe8xKYqEq7CdaYAuj/QrI
2SCf3Z8RQJ4fuKWaf+4P64+WZKTutOJY4oVciQaVpthNPOtdvX2csvSP5ZFVgOs/
DfHhZLfMzOXStWOcjoaZAO14so8SxqrTZn4cIt/e7WCGvss8Hlesp1zRdURxvS6k
7TsYF3IA7LyZTQk8ExqV6xMNPRPdF8shmeIgT7M2CXPPoe0JsWVOBDwmZrsASXiQ
6fvUh2VxbbbSAhgbLr/AxyAPU2Ej94RTr4wwWi3TH5jcNA/DDOLJGLvVZmKDpTkV
slIjmvmhwrnS/Mw/C9z4SyKfgMN2zfWFvd4+NAODHy/9Mm7xHJ31ccLmzGRppDMZ
R+OU4wlqmt746TR1DkGK
=hW2+
-----END PGP SIGNATURE-----

--IpljlC28XhFjURzf--
