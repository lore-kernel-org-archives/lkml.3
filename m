Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945956AbaD3UEE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 16:04:04 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46553 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759118AbaD3UEC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 16:04:02 -0400
Date: Wed, 30 Apr 2014 15:03:53 -0500
From: Felipe Balbi <balbi@ti.com>
To: Zhuang Jin Can <jin.can.zhuang@intel.com>
CC: Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: gadget: fix burst size corruption
Message-ID: <20140430200353.GC3839@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140501071604.GB30575@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W5WqUoFLvi1M7tJE"
Content-Disposition: inline
In-Reply-To: <20140501071604.GB30575@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--W5WqUoFLvi1M7tJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 01, 2014 at 03:16:04AM -0400, Zhuang Jin Can wrote:
> endpoint.maxburst may be 0 if a gadget doesn't call config_ep_by_speed()
> to update it from the companion descriptor.
> And endpoint.maxburst - 1 returns 11111b which wrongly sets bit
> 26 of endpoint parameter 0.
> This sets a wrong endpoint state and will cause "Get Endpoint State"
> command can't get the corret endpoint state and "Set Endpoint Config"
> command can't restore the correct endpoint state during hibernation
> resume flow.
> Thus, when endpoint.maxburst is 0, we should set burst as 0 directly.
>=20
> Signed-off-by: Zhuang Jin Can <jin.can.zhuang@intel.com>
> ---
>  drivers/usb/dwc3/gadget.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> index 70715ee..44eca95 100644
> --- a/drivers/usb/dwc3/gadget.c
> +++ b/drivers/usb/dwc3/gadget.c
> @@ -440,7 +440,8 @@ static int dwc3_gadget_set_ep_config(struct dwc3 *dwc=
, struct dwc3_ep *dep,
> =20
>  	/* Burst size is only needed in SuperSpeed mode */
>  	if (dwc->gadget.speed =3D=3D USB_SPEED_SUPER) {
> -		u32 burst =3D dep->endpoint.maxburst - 1;
> +		u32 burst =3D dep->endpoint.maxburst ?
> +				dep->endpoint.maxburst - 1 : 0;

again, you found a bug on the gadget driver. Fix that. composite.c
guarantees that for those functions which don't pass bMaxBurst,
gadget->maxburst will be set to *at least* 1.

--=20
balbi

--W5WqUoFLvi1M7tJE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTYVcpAAoJEIaOsuA1yqREn2sP/jRP2GT4ONO7CxVaauLiS/BW
Z1LcuKQ5hNlR8Z+AxePMuwoGmxJEx2V8/E2bN504i6F8kgo30aXb89trMUb2qV6m
Y874pnsg6037CrHPHwi3VzK229XiXp7LtNwnszPoSVbH2Hdg62wKwb59GWFTPniX
MwVi6sh3bvC6kWa+JTEpKvDphHgB6d91UlZJEFJ8FBUSLUf5kR/lH9ycIPEKpO8c
Ko1j0k9KKysfylJflc+v8dOgS5uTMOXd4MOeVSOZfhMYHdz5s5yge2bauBqTiVwi
CxREzBH5jdTIJaXKgTu+/HJY6el8bx1izIX13urrxxt0Ciz0sN8HrrvYHRsGHax6
QyIMM5EGtXTa7/8FICHU1yJftBnLEnai9CV0Mooa6llNmxUaCg0UXOIAoN+HC0FV
mBfaWwSSDTfrm6gG3CqIt+0XjacUhHFvRRmw2z8HOWdd4atnpdRIPIr1yTV+Etl2
gBKiVtA9en4RKic4GAJISWcI6efApPlKsk994YotyDGetQSHL/qIohwxZUy1lQZt
yVmT8HGgJLm/GBhWVxN2++zu5rXfcqY7LeN3xs0E28+vBMwXji2d8rC8kk+EJ1Pt
TSL4GI3nkUYiFsuITBMG2h9pRKN33SOwDiarCYMGeZ9YhvakogLCm4Uwx9g3CLVF
WW/QDL/l1blfCpzZDY7O
=Xr9Z
-----END PGP SIGNATURE-----

--W5WqUoFLvi1M7tJE--
