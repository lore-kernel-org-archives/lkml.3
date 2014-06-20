Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965973AbaFTQ5x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 12:57:53 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34973 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbaFTQ5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 12:57:52 -0400
Date: Fri, 20 Jun 2014 11:57:42 -0500
From: Felipe Balbi <balbi@ti.com>
To: Himangi Saraogi <himangi774@gmail.com>
CC: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <julia.lawall@lip6.fr>
Subject: Re: [PATCH] usb: host: xhci-plat: use devm_functions
Message-ID: <20140620165742.GA28686@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140620164853.GA5798@himangi-Dell>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <20140620164853.GA5798@himangi-Dell>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jun 20, 2014 at 10:18:53PM +0530, Himangi Saraogi wrote:
> This patch introduces the use of managed interface devm_ioremap_resource
> for ioremap_nocache and request_mem_region and removes the corresponding
> free functions in the probe and remove functions.
>=20
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> ---
>  drivers/usb/host/xhci-plat.c | 25 +++++--------------------
>  1 file changed, 5 insertions(+), 20 deletions(-)
>=20
> diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
> index 29d8adb..31d14a5 100644
> --- a/drivers/usb/host/xhci-plat.c
> +++ b/drivers/usb/host/xhci-plat.c
> @@ -140,18 +140,11 @@ static int xhci_plat_probe(struct platform_device *=
pdev)
>  	hcd->rsrc_start =3D res->start;
>  	hcd->rsrc_len =3D resource_size(res);
> =20
> -	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len,
> -				driver->description)) {
> -		dev_dbg(&pdev->dev, "controller already in use\n");
> -		ret =3D -EBUSY;
> -		goto put_hcd;
> -	}
> -
> -	hcd->regs =3D ioremap_nocache(hcd->rsrc_start, hcd->rsrc_len);
> -	if (!hcd->regs) {
> +	hcd->regs =3D devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(hcd->regs)) {
>  		dev_dbg(&pdev->dev, "error mapping memory\n");

you can remove this dev_dbg() message now that you're using
devm_ioremap_resource().

--=20
balbi

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTpGgGAAoJEIaOsuA1yqREWIAP/16vFjNmn7zHJpjKY6RZd6mG
KDD7QUX/kI21pfdZ/wwW1GMvREygmOMtgKHIZr6vCmS6T2uyam2o7He9ifu4R5IZ
vijXAvk2cFotgRCIpHxCQ1HUSXvbi64g6tFGEN38+9SpHVz4EST+kBCB1m5aVEhR
wxj0DE1rWXLPyjFO/u3p25r7s7p9yPqpkowgYyPNiwf6cw5iwxURQvbJWp+YDEoV
TlgXPOWClaOG6mj6JNBC8J4eWuRalKQqSL9hHBz0ccceLhwFPcsrpp8VPOKWUiGE
TL8jV54BYQ/8KtuJ9zXu/wkPM3PjjKRI1JSr7RIxdfzqRMsE9yFBVj029y+lXbj0
924ZMfZxK3BHvQHkNHHId+KbUk4CnxSefQ0yF3lxr3usVu40qt+c2Qos1jeGHGjN
pOzj/ogbZgxBIntqYq4xxrUgvtT2hSK/JvQARl3iaVA23aRBCUy02Q06Is673Tg8
ETzgoHUphsxc+1gAIMhWnQJk/kFcBMN0uaufCoEuA9AUx3viegitSJANtnbBuBVY
isCRPlNzMi20nkXXO2QOuoccOpps6JLnSptk0UfaXytZVPwANuLAEEauwrC1ktFC
aYpx3TMoxn62MPUvkM6JEIyYCSrHgwcd5UCsR81Hvs2ztKJJFm9cGImCVhXnUavj
7X0rtxk2mosawTV24+RY
=Qsym
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
