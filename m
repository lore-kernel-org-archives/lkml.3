Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab3KRWrQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 17:47:16 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50843 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab3KRWrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 17:47:13 -0500
Date: Mon, 18 Nov 2013 16:46:47 -0600
From: Felipe Balbi <balbi@ti.com>
To: Taras Kondratiuk <taras.kondratiuk@linaro.org>
CC: <linux-omap@vger.kernel.org>, <linaro-networking@linaro.org>,
        Victor Kamensky <victor.kamensky@linaro.org>,
        Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 14/23] USB: ehci-omap: raw read and write endian fix
Message-ID: <20131118224647.GE12294@saruman.home>
Reply-To: <balbi@ti.com>
References: <1384560086-11994-1-git-send-email-taras.kondratiuk@linaro.org>
 <1384560086-11994-15-git-send-email-taras.kondratiuk@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qz2CZ664xQdCRdPu"
Content-Disposition: inline
In-Reply-To: <1384560086-11994-15-git-send-email-taras.kondratiuk@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Qz2CZ664xQdCRdPu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 16, 2013 at 02:01:17AM +0200, Taras Kondratiuk wrote:
> From: Victor Kamensky <victor.kamensky@linaro.org>
>=20
> All OMAP IP blocks expect LE data, but CPU may operate in BE mode.
> Need to use endian neutral functions to read/write h/w registers.
> I.e instead of __raw_read[lw] and __raw_write[lw] functions code
> need to use read[lw]_relaxed and write[lw]_relaxed functions.
> If the first simply reads/writes register, the second will byteswap
> it if host operates in BE mode.
>=20
> Changes are trivial sed like replacement of __raw_xxx functions
> with xxx_relaxed variant.
>=20
> Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
> Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/usb/host/ehci-omap.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
> index 6fa82d6..803e706 100644
> --- a/drivers/usb/host/ehci-omap.c
> +++ b/drivers/usb/host/ehci-omap.c
> @@ -73,12 +73,12 @@ struct omap_hcd {
> =20
>  static inline void ehci_write(void __iomem *base, u32 reg, u32 val)
>  {
> -	__raw_writel(val, base + reg);
> +	writel_relaxed(val, base + reg);
>  }
> =20
>  static inline u32 ehci_read(void __iomem *base, u32 reg)
>  {
> -	return __raw_readl(base + reg);
> +	return readl_relaxed(base + reg);
>  }
> =20
>  /* configure so an HC device and id are always provided */
> --=20
> 1.7.9.5
>=20

--=20
balbi

--Qz2CZ664xQdCRdPu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSipjXAAoJEIaOsuA1yqREA/MQAKab9xc4Y86C41FFYkoEGywX
tE5cVe1EvBDbba6QZ6C5w+snckoitr8fXF/gMMQzsyQNXonhxMu5Gvak9X1J1iGN
BZAiVrZTzo3WnbihqOpNsY9ZjBILXEW92ixYlck9pWx0kyWPwGrGwIJDcAV+Gh6s
RO2x904QHJ9BvWBXHaeOPQhFxQm6eS3F01yhSwt9Bi7PhhPd04KjcKzaXjo3Hh09
Qx0J3nk4b7LbUVIxkRk2+7vnV4x6bvGs0Oc9t2IaMtV8RNFa441ugzNPzKxKonEY
KCjIOziYYnWgl2aozD+SsP32x4XtMR6i5aKI6CHhacoXTAXg1WZoSCS3PZDxvjff
s2D7hwh/B3ePdFmXtzEXX0RsR75KPpUFTfMpCGVE0tSQC+3+/01lfvJ/YeA+zzza
M3WfoaHAE82DRrwvxzXepmIKUoG3UE8ed46i2GKywCJL8PPxwBpepC85L7smaPRV
weYVXTq2plD/E0Td4rs+0EZUFAL9La/q8wHCJ/EwfYXk7R7on//jV2ETehlINzTu
pX+sfbgLOr9FzbtjQEIo/ZYHFKWLk+C7/7lZZjXw+ked5NCGMH0Z6qOVvznV27+u
hfK7Y7V8GBYVgtDMtbkZaxjzfMAdAxt+FyWF/BRM2InxDiQoDUfWb+KB5Fdmb1r7
wmBaOWqdxvtbyw4E8PTA
=rzKl
-----END PGP SIGNATURE-----

--Qz2CZ664xQdCRdPu--
