Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab3JAN4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 09:56:41 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56125 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753126Ab3JAN4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 09:56:40 -0400
Date: Tue, 1 Oct 2013 08:56:30 -0500
From: Felipe Balbi <balbi@ti.com>
To: Robert Baldyga <r.baldyga@samsung.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <b.zolnierkie@samsung.com>,
        <m.szyprowski@samsung.com>, <andrzej.p@samsung.com>
Subject: Re: [PATCH] USB: gadget: s3c-hsotg: fix maxpacket size
Message-ID: <20131001135630.GN1476@radagast>
Reply-To: <balbi@ti.com>
References: <1380277869-17855-1-git-send-email-r.baldyga@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eLe8FOcWSbbyMVJD"
Content-Disposition: inline
In-Reply-To: <1380277869-17855-1-git-send-email-r.baldyga@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--eLe8FOcWSbbyMVJD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Sep 27, 2013 at 12:31:09PM +0200, Robert Baldyga wrote:
> This patch changes ep maxpacket value from 512 to 1024, becouse it's need=
ed

shouldn't you use 3072 instead to cope with high bandwidth ISO
endpoints ?

> to handle interupt and isochronous endpoints in high-speed mode. This cha=
nge
> doesn't affect on driver functioning, becouse fifo size (3072) is still e=
nough

s/becouse/because.

> for the maximum transaction payload (3*1024 for high-speed high-bandwidtch
> endpoints).
>=20
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> ---
>  drivers/usb/gadget/s3c-hsotg.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsot=
g.c
> index 8a9e2c6..0d1dcbd 100644
> --- a/drivers/usb/gadget/s3c-hsotg.c
> +++ b/drivers/usb/gadget/s3c-hsotg.c
> @@ -3146,7 +3146,7 @@ static void s3c_hsotg_initep(struct s3c_hsotg *hsot=
g,
> =20
>  	hs_ep->parent =3D hsotg;
>  	hs_ep->ep.name =3D hs_ep->name;
> -	hs_ep->ep.maxpacket =3D epnum ? 512 : EP0_MPS_LIMIT;
> +	hs_ep->ep.maxpacket =3D epnum ? 1024 : EP0_MPS_LIMIT;
>  	hs_ep->ep.ops =3D &s3c_hsotg_ep_ops;
> =20
>  	/*
> --=20
> 1.7.9.5
>=20

--=20
balbi

--eLe8FOcWSbbyMVJD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSStSOAAoJEIaOsuA1yqRELqEP/2QCb3uUiQknFKtcXbhoFhKN
QrSXMAPD2m0xuWHVl0TNP/2OHNdtreXNdpxKsKQ7LZS9BGwvcAUAS5m+7mqLVi6z
rtSuaQbJRXAviHAew0iI3ifuJ15TBwwQB9HsthSe18LkG7nuhprERmJD2GTeEo95
S2JPqU3bnBBqBkQUMBQIosvMfiUj4jlkNsKcRx4jMuR4iCajq0nSiKDddM37oSB5
hrDe1Zz483TVK8qPSvHMkZAR3kVbsHbaJKqPK/bskl/LyYUoxXP2+/jc2+EJ7e/4
4KQRYf1Scoz8P0QPKXMBWZkLQqcR6/yorccOqj8TZpEUUIrLFPb4QiDIr+GpYP/v
MiTIpHTisOxu3xkd45uCYt7N1eerqwX8L/XnjHEiYnRhJFR8EVawAC49ldZE1+lP
UNqBLwgofATpGa+4mWHbRCq2Li5odTvUKG7rsFtENllaxBKYVcy0WOmEfqGLkfNw
uxC9Bxywyld46Z90ozgpfa4cH7WCze/qAgSBbTrOtDJKzAjUxYPchLqjXVmIBAgu
YF8ex/v5kUpzikHcOExNqw2HFN4wMfUuOGlBue4xgcSq1J4FSW5+Bxf4uvxpQ/pP
7Y2zguWrwh9RRi2mCHmZp7xx9l3XR97jst0WwGCLrjbDvHNO9F2FfblgDPH61pRt
o2BS4RAhZGwSEYBWS5rY
=EncT
-----END PGP SIGNATURE-----

--eLe8FOcWSbbyMVJD--
