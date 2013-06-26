Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab3FZIZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 04:25:08 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58342 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631Ab3FZIZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 04:25:04 -0400
Date: Wed, 26 Jun 2013 11:24:57 +0300
From: Felipe Balbi <balbi@ti.com>
To: Ravi Babu <ravibabu@ti.com>
CC: <linux-usb@vger.kernel.org>, <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 1/3] usb: musb: core: added musb_restart() API to
 handle babble condition
Message-ID: <20130626082457.GM12640@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1369832824-29071-1-git-send-email-ravibabu@ti.com>
 <1369832824-29071-2-git-send-email-ravibabu@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Sk71+Upln2BLuDmg"
Content-Disposition: inline
In-Reply-To: <1369832824-29071-2-git-send-email-ravibabu@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sk71+Upln2BLuDmg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 29, 2013 at 06:37:02PM +0530, Ravi Babu wrote:
> Added musb_restart() API, used for restart of the musb controller by
> the glue layer, when there is babble condition occured on the bus.
>=20
> During babble condition, the musb controller will remove the session
> and no longer in host-mode. As part of recovery this API can be used
> to restart the musb controller.
>=20
> Signed-off-by: Ravi Babu <ravibabu@ti.com>
> ---
>  drivers/usb/musb/musb_core.c |   24 ++++++++++++++++++++++++
>  drivers/usb/musb/musb_core.h |    1 +
>  2 files changed, 25 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
> index 37a261a..ab6fa39 100644
> --- a/drivers/usb/musb/musb_core.c
> +++ b/drivers/usb/musb/musb_core.c
> @@ -1373,6 +1373,30 @@ static int ep_config_from_hw(struct musb *musb)
>  	return 0;
>  }
> =20
> +/*
> + * musb_restart - restarts musb controller
> + * @param musb the controller
> + */
> +int musb_restart(struct musb *musb)
> +{
> +	int status =3D 0;
> +
> +	/* during babble condition the musb controller removes the
> +	 * session bit and the fifo table initialized value get changed
> +	 */
> +	if (musb->dyn_fifo)
> +		status =3D ep_config_from_table(musb);
> +	else
> +		status =3D ep_config_from_hw(musb);
> +
> +	/* starts session */
> +	if (!status)
> +		musb_start(musb);
> +
> +	return status;
> +}
> +EXPORT_SYMBOL_GPL(musb_restart);

this sort of function should never be exposed outside of MUSB core
itself. This points to a big problem somewhere else.

let me continue reading the other two patches...

--=20
balbi

--Sk71+Upln2BLuDmg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRyqVZAAoJEIaOsuA1yqREs4IP/1/27uhbDI8qrqzseG5oX7ea
NrmZ2o0aYjuhwGR115wJ20Yt7X1PkGegs0vadDcutR0a59uRk1yg5P34DPNGyf30
dtn24MhWFvWxVlKabd2k1tzEfvCiggzUd7zs0OKS/80z7V/ko963G00pmyUGYPgv
k8qzQXVDmxYR7xRbBjE6oC+CE+lRR8deRlawTBTISg6O3Dw7UIZxPwpd1IdouMaI
F/L+f5N+E56pYSuMPKIwB8fc2LqEPFxPp4+I/njZbJ3vby2FAbzFs0B9c3zeu+t2
pdTRVLExLhScrn4tCG/hNeDA701lQRvLXFBhD2RB1g5EeDJi55yUoOOvc+iHkcxn
VIBHK89QcL5loM//BLx/ojA/42V3NhWuiCW4b+crnmBMOuSSUBNSa9FxIBK5EVRC
13A+2+Y2zTxfWdNR0VvgPh49NNdS6OJIBOeKvOaZNKwMtvA9uZ9dszmSNca7lklp
0jmIv7P07/0Xdfmqz+QmQ4U3InBh9dliN1p/vy8N5GDzjgpzRwh5PNsP6PliJJ7M
Rgf8AfffM4RkjtkQxMB2frFg1FX2SyOuDJS+zzBJEGbohgJq2ncOdc1h4TAKTq+n
qf/RtagU1foCchUE8WgosAjuhGeMsF9HVFg0IxipTdHHJGcryKAOwcZVpXULuS30
uqqrpSJyVxVUTel92eg3
=YYw/
-----END PGP SIGNATURE-----

--Sk71+Upln2BLuDmg--
