Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803AbaCKXVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 19:21:46 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51734 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755404AbaCKXVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 19:21:45 -0400
Date: Tue, 11 Mar 2014 18:20:05 -0500
From: Felipe Balbi <balbi@ti.com>
To: Kees Cook <keescook@chromium.org>
CC: <linux-kernel@vger.kernel.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: tcm_usb_gadget: stop format strings
Message-ID: <20140311232005.GB23309@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140311202616.GA24575@www.outflux.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v9Ux+11Zm5mwPlX6"
Content-Disposition: inline
In-Reply-To: <20140311202616.GA24575@www.outflux.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--v9Ux+11Zm5mwPlX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 11, 2014 at 01:26:16PM -0700, Kees Cook wrote:
> This makes sure that the name coming out of configfs cannot be used
> accidentally as a format string.
>=20
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/usb/gadget/tcm_usb_gadget.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/usb/gadget/tcm_usb_gadget.c b/drivers/usb/gadget/tcm=
_usb_gadget.c
> index 0f8aad78b54f..460c266b8e24 100644
> --- a/drivers/usb/gadget/tcm_usb_gadget.c
> +++ b/drivers/usb/gadget/tcm_usb_gadget.c
> @@ -1613,7 +1613,7 @@ static struct se_wwn *usbg_make_tport(
>  		return ERR_PTR(-ENOMEM);
>  	}
>  	tport->tport_wwpn =3D wwpn;
> -	snprintf(tport->tport_name, sizeof(tport->tport_name), wnn_name);
> +	snprintf(tport->tport_name, sizeof(tport->tport_name), "%s", wnn_name);

Can you resend with Cc: <stable@vger.kernel.org> ?

Looks like we need to backport this v3.4.

--=20
balbi

--v9Ux+11Zm5mwPlX6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTH5olAAoJEIaOsuA1yqREruIQAK80cODT2A7/MBSjnKpuxYVN
YPGTdkGo0DJ42bZZSUlq3F6yyJDZ4xCAWMCWWqeqLb3EV6Z0KaxGx8yKijfdgU/8
XxqYK8Rot3zN3u0uNr3u4QLxe2FVI/YpmfIS10/G/GCRf8Btv0rWSzy3PZOqLjD1
3zVNgthPJrbQ9vFu+BQwLUd2Khifds4kFMtg6jGRwxGOZTPPkwtpWO6tzXCXxr8Y
nWmy2IZnoRBEN4prk2sTeOfQi2SSy85TuToHYUTHPIvTzDNhEHSsglMyFyd3M9pO
2CVVn6EsZZgWZPPTOnKUAEXHNmJUhoIRChqrAdyW1oe0W0G1Feil3kfrtMzKfkD4
U9RbRamOXWiPZEXt9YxR070aAzDffuDnxWD3cm/wVojrruocGixebPfCaF0bA4vB
U5V/QimDVmKgypneM1gctI786DtmhL3vtm+KCmXOr+SOSCi4mDQXib2e5S/iOLcC
PZQ4R+U9sejrpJYM/uPfWhkJTjkMUtWj7q5EWE/F6QCCux8kEFbj+3lq26xhjRd0
dKPmY3MSoIutzBos+atritqSLrZXjRkA6sAqZPBVZtm+gNzqaEEEGTruDcFuDI9/
rSakeEg6lAaGo1r4knHVc0Vs6ePZMCL82GrHKWHhL790eaz555NyoT3uQQan9+Br
XrA+df7IKvCkek/Ezaf7
=lSFd
-----END PGP SIGNATURE-----

--v9Ux+11Zm5mwPlX6--
