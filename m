Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbaIXVAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 17:00:12 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50835 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbaIXVAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 17:00:09 -0400
Date: Wed, 24 Sep 2014 16:00:01 -0500
From: Felipe Balbi <balbi@ti.com>
To: Michal Sojka <sojka@merica.cz>
CC: <linux-usb@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
        Bryan Wu <cooloney@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <michal.vokac@comap.cz>
Subject: Re: [PATCH v6 1/4] usb: gadget: Introduce
 usb_gadget_giveback_request()
Message-ID: <20140924210001.GD17997@saruman>
Reply-To: <balbi@ti.com>
References: <Pine.LNX.4.44L0.1409241106100.1580-100000@iolanthe.rowland.org>
 <1411591401-5874-1-git-send-email-sojka@merica.cz>
 <1411591401-5874-2-git-send-email-sojka@merica.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rAc+36e7LRL7Dg7x"
Content-Disposition: inline
In-Reply-To: <1411591401-5874-2-git-send-email-sojka@merica.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--rAc+36e7LRL7Dg7x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 24, 2014 at 10:43:18PM +0200, Michal Sojka wrote:
> All USB peripheral controller drivers call completion routines directly.
> This patch adds usb_gadget_giveback_request() which will be used instead
> of direct invocation in the next patch. The goal here is to have a place
> where common functionality can be added.
>=20
> Signed-off-by: Michal Sojka <sojka@merica.cz>
> ---
>  drivers/usb/gadget/udc/udc-core.c | 16 ++++++++++++++++
>  include/linux/usb/gadget.h        |  8 ++++++++
>  2 files changed, 24 insertions(+)
>=20
> diff --git a/drivers/usb/gadget/udc/udc-core.c b/drivers/usb/gadget/udc/u=
dc-core.c
> index b0d9817..f7b3151 100644
> --- a/drivers/usb/gadget/udc/udc-core.c
> +++ b/drivers/usb/gadget/udc/udc-core.c
> @@ -106,6 +106,22 @@ EXPORT_SYMBOL_GPL(usb_gadget_unmap_request);
> =20
>  /* ---------------------------------------------------------------------=
---- */
> =20
> +/**
> + * usb_gadget_giveback_request - give the request back to the gadget lay=
er
> + * Context: in_interrupt()
> + *
> + * This is called by device controller drivers in order to return the
> + * completed request back to the gadget layer.
> + */
> +void usb_gadget_giveback_request(struct usb_ep *ep,
> +		struct usb_request *req)
> +{
> +	req->complete(ep, req);
> +}
> +EXPORT_SYMBOL_GPL(usb_gadget_giveback_request);
> +
> +/* ---------------------------------------------------------------------=
---- */
> +
>  static void usb_gadget_state_work(struct work_struct *work)
>  {
>  	struct usb_gadget	*gadget =3D work_to_gadget(work);
> diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
> index c3a6185..f795e95 100644
> --- a/include/linux/usb/gadget.h
> +++ b/include/linux/usb/gadget.h
> @@ -1013,6 +1013,14 @@ extern void usb_gadget_set_state(struct usb_gadget=
 *gadget,
> =20
>  /*----------------------------------------------------------------------=
---*/
> =20
> +/* utility to give requests back to the gadget layer */
> +
> +extern void usb_gadget_giveback_request(struct usb_ep *ep,
> +		struct usb_request *req);
> +
> +

minot nit: one blank line only, other than that

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--rAc+36e7LRL7Dg7x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUIzDRAAoJEIaOsuA1yqRE1YwQAJNupc4kiYJZTDErnr2I5lzr
3+4q+Ju36wdfynAilUle+ea3IbabG78vWZ3CoB9nCr2iWI8WnJnS4+FKwiCg9oT1
7QmCWdWkV0pmhL44x3O9oWFgsA4ALDwJz1lbGcyp/+H4imY4SjVAlzXgTXBk7mwY
1airpBwHDUTcr9eXhQ7T3b4a56PH2BVi23hyugh4hbEz4CbCcRZYkKdAVYD/Yd28
PW/MI+ADmR7Mb/qnRtX8Lrap0gxJg88w5tT9pVv2l3rCtFqbb9WdvaV0F527MaGS
3p3JoDcUtOk9LM857aaFEsRwOkUlWAGBam5HpKAfMuaeys3SqkTMr4VGswGswymi
uedX9iaV6eZUr99efCd9SUYJc7txQV0tUG7hcKF6sjRiDd+UGe0Kq5AsUmONaiT0
hXVt28zVXP5wkaZL+kK6lsMTZmmqlpEREoepOVyQoBdNshqs0r9wAvkwrNnnJH/r
onoI759a1Ed3r3zZbDjooCVJ/idlMgGopOPCp9ELU1rHq0h9hX0xtadw4w6d4bZX
khscKbE2h2Cymh7lLXBzd544MxEjvu3Dee5ht5p7cXpRyD540txrA0IIUiyc131D
XxwPUlMU4VCgcpHiFJp6rGXGdbt/7V9bmtrLBPizm1QkeSJAzHfBmutfTC6R+VEq
xhRfbZ1uSdX4kSje5Eqn
=OqH4
-----END PGP SIGNATURE-----

--rAc+36e7LRL7Dg7x--
