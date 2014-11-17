Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbaKQXNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 18:13:18 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:45312 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752999AbaKQXNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 18:13:15 -0500
Date: Mon, 17 Nov 2014 17:12:40 -0600
From: Felipe Balbi <balbi@ti.com>
To: Andrew Bresticker <abrestic@chromium.org>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>, <linux-tegra@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Kishon Vijay Abraham I <kishon@ti.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH V5 09/12] usb: xhci: Add NVIDIA Tegra xHCI
 host-controller driver
Message-ID: <20141117231240.GB9716@saruman>
Reply-To: <balbi@ti.com>
References: <1416264102-1323-1-git-send-email-abrestic@chromium.org>
 <1416264102-1323-10-git-send-email-abrestic@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+pHx0qQiF2pBVqBT"
Content-Disposition: inline
In-Reply-To: <1416264102-1323-10-git-send-email-abrestic@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--+pHx0qQiF2pBVqBT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Nov 17, 2014 at 02:41:39PM -0800, Andrew Bresticker wrote:
> diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
> index a3ca137..e2415d3 100644
> --- a/drivers/usb/host/Kconfig
> +++ b/drivers/usb/host/Kconfig
> @@ -50,6 +50,15 @@ config USB_XHCI_RCAR
>  	  Say 'Y' to enable the support for the xHCI host controller
>  	  found in Renesas R-Car ARM SoCs.
> =20
> +config USB_XHCI_TEGRA
> +	tristate "xHCI support for NVIDIA Tegra SoCs"
> +	depends on ARCH_TEGRA

it would be nice if you could still leave || COMPILE_TEST here.

[snip]

> +static const struct {
> +	const char *name;
> +	unsigned int num;
> +} tegra_xhci_phy_types[] =3D {
> +	{
> +		.name =3D "usb3",
> +		.num =3D TEGRA_XUSB_USB3_PHYS,
> +	}, {
> +		.name =3D "utmi",
> +		.num =3D TEGRA_XUSB_UTMI_PHYS,
> +	}, {
> +		.name =3D "hsic",
> +		.num =3D TEGRA_XUSB_HSIC_PHYS,
> +	},

these should be using the generic PHY subsystem (drivers/phy).

> +static int tegra_xhci_load_firmware(struct tegra_xhci_hcd *tegra)
> +{
> +	struct device *dev =3D tegra->dev;
> +	struct tegra_xhci_fw_cfgtbl *cfg_tbl;
> +	struct tm fw_tm;
> +	u32 val, code_tag_blocks, code_size_blocks;
> +	u64 fw_base;
> +	time_t fw_time;
> +	unsigned long timeout;
> +
> +	if (csb_readl(tegra, XUSB_CSB_MP_ILOAD_BASE_LO) !=3D 0) {
> +		dev_info(dev, "Firmware already loaded, Falcon state 0x%x\n",
> +			 csb_readl(tegra, XUSB_FALC_CPUCTL));
> +		return 0;
> +	}

won't this prevent rmmod && insmod from succeeding ? Maybe not, as you
return 0 anyway, but if the firmware side craps out, it might be useful
to reload the firmware and reset that block. I wonder if this prevents
that.

--=20
balbi

--+pHx0qQiF2pBVqBT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUaoDoAAoJEIaOsuA1yqRElRgQAJKk/NuTmI0mubXByFWmOAuZ
DGmBNyp5oXUMm44gqgWiSyNBFrl53GT6ZvPgzSXGn/YJxS5vmHVgAvUSknux6WX6
QdYbI3/pdOtY9bQfqbVhGD/U9xgiLe66rzljUpOwmWx1NOHDMwB2SJF3hJvQQrnR
Y6p0FW6a1lB9BylO9y8G6aAtgDT0xGY52wUsJZAQ5FI2J2VbQwZJOCAanNBiz+K4
EZHG3H6xx1FkGXPWGWQ8o5NDtDRUU4Dgwm0HmDFoPmLfLuRruIphODXzFZMYbVoI
LFOybuVgxBSsoVOJz/l+RPK6ubYrsXYAJlsErls0rOvBXKogKgbod6gHC9azwO65
xHtefaj26D3nfEkDeW2VJyP5EELyMSCfNfmxjIGMtttWzBVosfyNQ9gaql2DCF4Q
t+fs900h2sIqzcJrcw5C/TOkuuxyvYn+qrox7JcKTbeK1jiMjaCgaQKK+RHFMc80
LqYi9EtGQoeAj0Rl9iIHew8fiSgrNUs6fi+j3WLbep1G53t0Z8Q7a6iyR71X5Ubq
sajpkQ6L+Nmn5g7otSfOSoaFrDs6SyHhtmORUVRCZtnC0HDr7ImgmSITQWVG3qRg
KU5IFU0nmCGyzZYKCk6KDVPXXrJshT9VpwbZCVX53yA8xNOz31FK05Z/LPyGWPO5
BOs2HqNQU6D73XXfepfC
=AqsM
-----END PGP SIGNATURE-----

--+pHx0qQiF2pBVqBT--
