Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759541AbaD3T6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 15:58:40 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43736 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759259AbaD3T6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 15:58:38 -0400
Date: Wed, 30 Apr 2014 14:58:29 -0500
From: Felipe Balbi <balbi@ti.com>
To: Zhuang Jin Can <jin.can.zhuang@intel.com>
CC: Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: Re: [PATCH] usb: dwc3: gadget: giveback request if start transfer
 fail
Message-ID: <20140430195829.GA3839@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140501063608.GA30575@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
In-Reply-To: <20140501063608.GA30575@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, May 01, 2014 at 02:36:08AM -0400, Zhuang Jin Can wrote:
> At least we should giveback the current request to the
> gadget. Otherwise, the gadget will be stuck without knowing
> anything.
>=20
> It was oberved that the failure can happen if the request is
> queued when the run/stop bit of controller is not set.

why is your gadget queueing any requests before calling ->udc_start() ?

A better question, what modification have you done to udc-core.c which
broke this ? udc-core *always* calls ->udc_start() by the time you load
a gadget driver so this case will *never* happen. Whatever modification
you did, broke this assumption and I will *not* accept this patch
because the bug is elsewhere and *not* in mainline kernel.

> Signed-off-by: Zhuang Jin Can <jin.can.zhuang@intel.com>
> ---
>  drivers/usb/dwc3/gadget.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>=20
> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> index 70715ee..8d0c3c7 100644
> --- a/drivers/usb/dwc3/gadget.c
> +++ b/drivers/usb/dwc3/gadget.c
> @@ -1000,9 +1000,7 @@ static int __dwc3_gadget_kick_transfer(struct dwc3_=
ep *dep, u16 cmd_param,
>  		 * here and stop, unmap, free and del each of the linked
>  		 * requests instead of what we do now.
>  		 */
> -		usb_gadget_unmap_request(&dwc->gadget, &req->request,
> -				req->direction);
> -		list_del(&req->list);
> +		dwc3_gadget_giveback(dep, req, -ESHUTDOWN);
>  		return ret;
>  	}
> =20
> --=20
> 1.7.9.5
>=20

--=20
balbi

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTYVXlAAoJEIaOsuA1yqRE5CAP/3JxjLFO9mBGh4aEw4rE60g1
9dEDKYTW0B/qs1S3XaaoMENqn3+tA1wtkOXSAGjHNRl4QW/wWwzearmnPHPK1Zf6
/wcteu3FiYz8lwAg8/8EzhcCZSGNmEL7cz5/428MplHfDZ6EwEbw4/NcBm3/4LKc
YMudAFYYYbcTBcnSGxCtmm4+NgUxy0M14jV5EBqPrKFz64jdVTG+DxylL4XThiqm
hsela1Jf62DCPDthe8eVqkA1+th648sH6GCNS5rJ2CAUlHw6T4sXhKn+ewju77eJ
3i2wWw7nEIghjg13phmsk7zlOJIll+Zzfri1iAJzAg3HuhuIbPUMDgjVmKqPFkR2
q3huq22Jb30G4m0ZthACdvtK79giJVgDBOgBK0pPOjEw8RLyjbV2ey9UFnoBun+j
HEjZlXnIrOCPiG3YtXHl8pHw3DZqPGO88k56nItbS8DVB5uDBVQvPbQgeHflRMrQ
+cH5OidQPVCAZ3n1wiQKqi4tpP9tEGx9xr1PvvDAg3PPKGLmGXXAeme+76QBhMey
fqjPvg0JBD1tiIVZT6Shuy9+vmJZMVg1apcNitQulvHJYMhy0q9lpqNYOwsVGJvT
95UrH/cN7cARpXxx/DKz7WDXpeLZIr3s3mh+u87bt8UfGoV+GCFR6EdVArrupT/H
YgQDwaB0Z56bj22HS3Xt
=VdFX
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
