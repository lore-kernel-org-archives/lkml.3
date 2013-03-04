Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab3CDP3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 10:29:41 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:39477 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758376Ab3CDP3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 10:29:38 -0500
Date: Mon, 4 Mar 2013 17:29:20 +0200
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <balbi@ti.com>,
        <sarah.a.sharp@linux.intel.com>, <kgene.kim@samsung.com>,
        <kishon@ti.com>
Subject: Re: [PATCH v2 01/10] usb: phy: Add APIs for runtime power management
Message-ID: <20130304152858.GT3397@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1362230590-20960-1-git-send-email-gautam.vivek@samsung.com>
 <1362230590-20960-2-git-send-email-gautam.vivek@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tYlHSoJ8Aop8eNG2"
Content-Disposition: inline
In-Reply-To: <1362230590-20960-2-git-send-email-gautam.vivek@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--tYlHSoJ8Aop8eNG2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Mar 02, 2013 at 06:53:02PM +0530, Vivek Gautam wrote:
> Adding  APIs to handle runtime power management on PHY
> devices. PHY consumers may need to wake-up/suspend PHYs
> when they work across autosuspend.
>=20
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>  include/linux/usb/phy.h |   26 ++++++++++++++++++++++++++
>  1 files changed, 26 insertions(+), 0 deletions(-)
>=20
> diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h
> index 15847cb..0fe7cac 100644
> --- a/include/linux/usb/phy.h
> +++ b/include/linux/usb/phy.h
> @@ -276,4 +276,30 @@ static inline const char *usb_phy_type_string(enum u=
sb_phy_type type)
>  		return "UNKNOWN PHY TYPE";
>  	}
>  }
> +
> +#define USB_PHY_AUTOPM(function)					    \
> +static inline int usb_phy_autopm_##function(struct usb_phy *x)		    \
> +{									    \
> +	if (!x || !x->dev) {						    \
> +		dev_err(x->dev, "no PHY or attached device available\n");   \
> +		return -ENODEV;						    \
> +	}								    \
> +									    \
> +	pm_runtime_##function(x->dev);					    \

please make the definitions explicit (not using a macro) and use:

	return pm_runtime_foo();

where applicable. We don't want to return 0 if pm_runtime_get_sync()
fails.

--=20
balbi

--tYlHSoJ8Aop8eNG2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRNL3QAAoJEIaOsuA1yqRE250P/ilG8Gtsk4BiD0UB6tG0XCqT
PPfO/HwRNsA48BtypraDgj15zcRES8gY+XnrdbSzNZR+w6Fz0iCAvjzcws8xqi30
VQd/LfQ0virVw6K18sQjKguiI0ikeRPyB1yLyQOMd6XQ31R7isKlcFy1HQjR4T85
9HnxOMoKILtF4gb0Fa1BXR2/8CJ0phkWM2bdOKgCyuS89lM5uHJPXMyRZB1TSh2v
2I0okbMbH9KrLsl1TAXxXQ2ecK2btWe46c/LSUwdQ7zn+pcRLCQ+KzjyomgzptxT
JU0RSX9fb6881jnKJXt4EIDXhfmDqpiW9Hu1V0LHgavcRIWlY/nwZIvLmA8NrKMt
AHs8OMldGgLqcpxEww9eIuF1octKwXqhUfOQyFk46H8VojdsTBkdBwnm1rK0c0GP
LxisMjS8KSkSvYsssZxkidTit3ZwkUR/JJiZbHAChNwlhik4NKuHKuC2VPIdKYVK
AWAx8J76ORnxGXotaN0CSEKJmyz/Vp+37hRjz11eHsnGtM3m1V+YVvQCFF+f24o7
aR5LPTEuX2qQ5rUv9BTRuNynRQ6N+ZYESYXPCqhab57I9gaQko2RVxS1G+8Amvwk
RhYlFa8pQkto3QzCLIDCIuR0WpnacwH7Mo8RSdaIV8g7RaQ1njxj1d9M7RNbT5nH
mVf0U1XQrdBhLWkSb7MD
=vU3F
-----END PGP SIGNATURE-----

--tYlHSoJ8Aop8eNG2--
