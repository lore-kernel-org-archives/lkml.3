Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236AbaLVQdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 11:33:00 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33332 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755107AbaLVQc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 11:32:58 -0500
Date: Mon, 22 Dec 2014 10:32:34 -0600
From: Felipe Balbi <balbi@ti.com>
To: Robert Baldyga <r.baldyga@samsung.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <peter.chen@freescale.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <m.szyprowski@samsung.com>, <k.opasiak@samsung.com>
Subject: Re: [PATCH] usb: gadget: udc-core: call udc_stop() before gadget
 unbind
Message-ID: <20141222163234.GG12815@saruman>
Reply-To: <balbi@ti.com>
References: <1418390248-6254-1-git-send-email-r.baldyga@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lQSB8Tqijvu1+4Ba"
Content-Disposition: inline
In-Reply-To: <1418390248-6254-1-git-send-email-r.baldyga@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--lQSB8Tqijvu1+4Ba
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 12, 2014 at 02:17:28PM +0100, Robert Baldyga wrote:
> As usb function drivers assumes that all usb request will be completed
> before function unbind call, we should supply such behavior. In some
> cases ep_disable() won't kill all request effectively, because some
> IN requests can be in running state. In such situation it's possible
> to have unbind function called before last request completion, which
> can cause problems.
>=20
> For example unbinding f_ecm function while request on 'notify' endpoint
> is not completed, ends up NULL pointer dereference in unbind() function.

this is a bug on f_ecm, however.

> usb_gadget_udc_stop() call causes completion of all requests so if it's
> called before gadget unbind there is no risk that some of requests will
> stay uncompleted.

we can't really stop the controller before the function's ->unbind() has
been called. Keep in mind that we can completely kill off the controller
(including gating clocks and, in some rare cases, disabling the power
domain) after ->udc_stop() has been called.

> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> ---
>  drivers/usb/gadget/udc/udc-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/usb/gadget/udc/udc-core.c b/drivers/usb/gadget/udc/u=
dc-core.c
> index e31d574..6f0d233 100644
> --- a/drivers/usb/gadget/udc/udc-core.c
> +++ b/drivers/usb/gadget/udc/udc-core.c
> @@ -331,8 +331,8 @@ static void usb_gadget_remove_driver(struct usb_udc *=
udc)
> =20
>  	usb_gadget_disconnect(udc->gadget);
>  	udc->driver->disconnect(udc->gadget);
> -	udc->driver->unbind(udc->gadget);
>  	usb_gadget_udc_stop(udc);
> +	udc->driver->unbind(udc->gadget);
> =20
>  	udc->driver =3D NULL;
>  	udc->dev.driver =3D NULL;
> --=20
> 1.9.1
>=20

--=20
balbi

--lQSB8Tqijvu1+4Ba
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUmEeiAAoJEIaOsuA1yqRE8xUQAIkC+tihBH2jxgpTW9wmX/h1
1Q+Q0QWKyISiKBNhAPS4tX6svOZdeoBaCAaOFY+qvPmOgVoek3cEA/MfYfQl7x8K
oTAzOk7p+naFylSgYlMEzi+fObgZ3RwmCHSwV9AabE+G4xUSp19qPfH81XJiKmJk
awGEpQh5zaBPyzEPJazQIhmUAyZn9rGDnr+TEB/X8kEoKCP9JZIIMvkhhU7h7udV
fs9vNKZYqTlwRRsApZ6gPgCFKsBiLzU+G8arDxDP7Al2UlS6sFnli7W53NDvZ5gr
xwm1VLTOofV/2pxv0EiNjruxwQjePNOCMqQnPDPt2wD4h2MuB+kktyliGEiSaI+a
iL294huiqeUJv31/3C9pO55KSAjLZsCu9KuHxDIJr8T92ZTdtZ34aAUYgcykF/AI
H4UL7Gt3gBVw7x5PdtOdbXfIr7iFPdZJo8N0BqpZlMcWUYtB6316vCrSC3dXynrj
EzyGCp/FYGcIoAaH2QPo2+0hUK8hBCr6rc2yV87ZOyKtZ0BCQx1jtOBofJyiFGLg
OGdfuCmMrRPinXKIMl94KVHNq60mW+vF3zpUAguWNhI9FVTNGrpQjiykSOpsfc60
F9Ug7/6nWj2Ww3NoPgtM6dJjpmWICsHXFAqs5jTMORSo7kyRHQhJMr0W2nUE0EBS
HwUotCXMQo0qBd7NOeu4
=zlzQ
-----END PGP SIGNATURE-----

--lQSB8Tqijvu1+4Ba--
