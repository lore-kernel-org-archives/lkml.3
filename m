Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760177Ab3DBIYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 04:24:07 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59534 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761166Ab3DBIYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 04:24:01 -0400
Date: Tue, 2 Apr 2013 11:23:42 +0300
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
CC: <linux-usb@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <balbi@ti.com>,
        <stern@rowland.harvard.edu>, <sarah.a.sharp@linux.intel.com>,
        <rob.herring@calxeda.com>, <kgene.kim@samsung.com>, <kishon@ti.com>,
        <dianders@chromium.org>, <t.figa@samsung.com>, <p.paneri@samsung.com>
Subject: Re: [PATCH v3 01/11] usb: phy: Add APIs for runtime power management
Message-ID: <20130402082342.GF30286@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1364824448-14732-1-git-send-email-gautam.vivek@samsung.com>
 <1364824448-14732-2-git-send-email-gautam.vivek@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xaMk4Io5JJdpkLEb"
Content-Disposition: inline
In-Reply-To: <1364824448-14732-2-git-send-email-gautam.vivek@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--xaMk4Io5JJdpkLEb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 01, 2013 at 07:24:00PM +0530, Vivek Gautam wrote:
> Adding  APIs to handle runtime power management on PHY
> devices. PHY consumers may need to wake-up/suspend PHYs
> when they work across autosuspend.
>=20
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>  include/linux/usb/phy.h |  141 +++++++++++++++++++++++++++++++++++++++++=
++++++
>  1 files changed, 141 insertions(+), 0 deletions(-)
>=20
> diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h
> index 6b5978f..01bf9c1 100644
> --- a/include/linux/usb/phy.h
> +++ b/include/linux/usb/phy.h
> @@ -297,4 +297,145 @@ static inline const char *usb_phy_type_string(enum =
usb_phy_type type)
>  		return "UNKNOWN PHY TYPE";
>  	}
>  }
> +
> +static inline void usb_phy_autopm_enable(struct usb_phy *x)
> +{
> +	if (!x || !x->dev) {
> +		dev_err(x->dev, "no PHY or attached device available\n");
> +		return;
> +		}

wrong indentation, also, I'm not sure we should allow calls with NULL
pointers. Perhaps a WARN() so we get API offenders early enough ?

--=20
balbi

--xaMk4Io5JJdpkLEb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRWpWOAAoJEIaOsuA1yqREzcMQAJkqx8O1xjqU7ukdheuiNosY
agYaXVJr2Z121Ma4+wJnHaYPli6aK7akMiejDWbjliF/FmWQXoxnL9V4xN92Gjkl
5VVche6xTykVBYv+bjrw7EbWvxlYDDanSLIVWyhYrHMtMJsnRA+7NRGrAfjC7jfx
K08F0e6hQ7HUYGy2UDjw2RaJUyuWfeaOyGJ/wa1NrmzZGFTNwV+StlGPaq0RlFHR
9UPFWBx10QQBx047aj4UL13442NzxHeKHKQwVk7ijJzWsx4DIi2BoKDoPjCnedUl
Y7ml8T9qcbo5xfvtfD/BLu6NXVM4qqs2FyoIkJhwrMKHW1y11kc/5JV1/c47QhGF
ky09mnui2hS9MXNVGGRnzRJzOFVdsKgC3ZMwaP2/93FcI7SkInuBklM7eFh6x7BH
geXO1ymDnzJwvAjoIFv81FjPC8BEDWqrEuKoi0Vof3A0kINzYA+Uw8gCt+cHo2dz
obBq21oIhspBEbvWUdgKrDYKrQcCIOFP6KYRsCksWWa4Zawd3bvgOoLzgL7sixPX
5gYwZFqzzGP/ZqYpYN2jAGOGu6M55xbFk3HuOGXTMM75p7elKNahV60NVjMyGwnd
DrVeUneLmn2t+voHiaPXwVEcxGo30WHP0mh8HphDBHelGU1qn2VLImktKMNm5Y7f
iaSGVA7B75D/oasvY+kh
=389A
-----END PGP SIGNATURE-----

--xaMk4Io5JJdpkLEb--
