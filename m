Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbaDTDSQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 23:18:16 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41552 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755193AbaDTDSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 23:18:12 -0400
Date: Sat, 19 Apr 2014 22:15:17 -0500
From: Felipe Balbi <balbi@ti.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
CC: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/8] usb: host: xhci-plat: Allow to register glue code
 using the device tree
Message-ID: <20140420031517.GA26893@saruman.home>
Reply-To: <balbi@ti.com>
References: <1397816563-9000-1-git-send-email-gregory.clement@free-electrons.com>
 <1397816563-9000-2-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
In-Reply-To: <1397816563-9000-2-git-send-email-gregory.clement@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Apr 18, 2014 at 12:22:36PM +0200, Gregory CLEMENT wrote:
> This patch allow to register specific glue code for xhci controller.
> It creates a structure called xhci_plat_ops to register functions
> specific to an SoC. Currently there are only probe() and remove() but

What SoC-specific code do you need ?

> it can be extended later, it was the point to create such a structure.
>=20
> Each compatible string can then be associated to an instance of this
> structure. In the non device tree case a default structure is used.
>=20
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> ---
>  drivers/usb/host/xhci-plat.c | 72 ++++++++++++++++++++++++++++++++++++++=
+++---
>  drivers/usb/host/xhci.h      |  4 +++
>  2 files changed, 72 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
> index 151901ce1ba9..8029cc82edc4 100644
> --- a/drivers/usb/host/xhci-plat.c
> +++ b/drivers/usb/host/xhci-plat.c
> @@ -16,6 +16,7 @@
>  #include <linux/slab.h>
>  #include <linux/of.h>
>  #include <linux/dma-mapping.h>
> +#include <linux/of_device.h>
> =20
>  #include "xhci.h"
> =20
> @@ -85,7 +86,7 @@ static const struct hc_driver xhci_plat_xhci_driver =3D=
 {
>  	.bus_resume =3D		xhci_bus_resume,
>  };
> =20
> -static int xhci_plat_probe(struct platform_device *pdev)
> +int common_xhci_plat_probe(struct platform_device *pdev, void *priv)

no, I rather not see this sort of hack.

--=20
balbi

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTUzvFAAoJEIaOsuA1yqREEoMP/ihPOo8wrZ6Pt2iEGqC6/48A
kcBk/BkqmzfCBtj2MMOvrvA9qF7VC2dzVlo3QTKiiullp2ogzA2tWxRtjA1ky1Mx
vqbsr2fs84OjuTMxtOYwUWBcUHXIb2B6lSMomVYvcOrm4AkQ//R5ikYprkdw/dSq
OBI0wgnsCyALm1sM5ngjraSVyQZakUhBJ3SyUaCiVQgZ2bf75d5JoKzQO+5l9hUI
Q8UG5pfoNlUebbw//aX8hc0Ewi+QYPWzJP3hGeaduHquV9RQuKRCs3gaPo4okPAB
EzcG8htpryDZCkye0umznICzGfzkdLNE+0ANiuOPihVEbZITC+nCSVlJN1mBVf59
fGAPrI+jowyRKmJ20KVeCOmNqFenCEnv+nGyKmb6sBgY58kjAsOZ4Eq3N96YBxuF
YTQUAVEQ3odJ6Eq30qmIAczaFw6OcFB9DRHiDpm7uBfKrI+P6EcgZ3K8U8NlrccE
RqG/eKFfiYj3dRlz/KJrr1xADqrDIBd+XRjdTjILTSfaDIar8um65OCpBqPAjTOK
WbWBUtvICLRM3uqv4hg4CqkN9VdkZdpHhqPePjApWO6aO8zep7RGAEbMlzMFEdcJ
UcGi/PVm8rEVhBhTkO9A6dths5l6jfXjymZFOjbpl3KGKFD8nx+BcQzUB3ruQXmS
nvFByDnNFgDEuGY89T48
=qD3P
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
