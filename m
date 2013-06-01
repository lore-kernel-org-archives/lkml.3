Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab3FARAe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 13:00:34 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42297 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab3FARA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 13:00:26 -0400
Date: Sat, 1 Jun 2013 19:59:22 +0300
From: Felipe Balbi <balbi@ti.com>
To: Thomas Meyer <thomas@m3y3r.de>
CC: <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: Cocci spatch "err_cast.spatch"
Message-ID: <20130601165922.GC15095@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1370081325.29224.42.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iFRdW5/EC4oqxDHL"
Content-Disposition: inline
In-Reply-To: <1370081325.29224.42.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--iFRdW5/EC4oqxDHL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 01, 2013 at 12:08:45PM +0200, Thomas Meyer wrote:
>=20

-ENOLOG

> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---
>=20
> diff -u -p a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composit=
e.c
> --- a/drivers/usb/gadget/composite.c
> +++ b/drivers/usb/gadget/composite.c
> @@ -1138,7 +1138,7 @@ struct usb_string *usb_gstrings_attach(s
> =20
>  	uc =3D copy_gadget_strings(sp, n_gstrings, n_strings);
>  	if (IS_ERR(uc))
> -		return ERR_PTR(PTR_ERR(uc));
> +		return ERR_CAST(uc);
> =20
>  	n_gs =3D get_containers_gs(uc);
>  	ret =3D usb_string_ids_tab(cdev, n_gs[0]->strings);
>=20
> diff -u -p a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
> --- a/drivers/usb/gadget/configfs.c
> +++ b/drivers/usb/gadget/configfs.c
> @@ -557,7 +557,7 @@ static struct config_group *function_mak
> =20
>  	fi =3D usb_get_function_instance(func_name);
>  	if (IS_ERR(fi))
> -		return ERR_PTR(PTR_ERR(fi));
> +		return ERR_CAST(fi);
> =20
>  	ret =3D config_item_set_name(&fi->group.cg_item, name);
>  	if (ret) {
>=20
>=20

--=20
balbi

--iFRdW5/EC4oqxDHL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRqihqAAoJEIaOsuA1yqREdy0P/1tjXEdfIVy4JuJHAC8D9ZHC
rPVo2xvXrmFawNFXDpd8MJ5DMjZ2/nAHyi9ifl06N3M3NDSrCEV77zLU78PRKCFh
GQuTa6BH5urkksIG6NfTc1Z9jFRSWZIcTqYUMOFtP307JYasLD5SKd5DLjowDkcl
DGLOIZUCc6VRyx6/X1HUy6+Vig8KX2OJBA5m6jSd9Ut242/uIwldLeE26kkCLyUj
tOCSvZjXO+ZANcxnKjUEt2iEr+hC5mASsAfiXYrP75weOdyhSCBunG57wiWRb/qb
OjZ4JCQvmPfPINPh+e4jef1ScibwhPowdnNtmykJebSa/8av8T0gOhmrDjJSa4zN
/556ka7jgkm4nFlFCufDqDuhsL1vEAO5rHajvSVhEyJGrp/5BtewZiitfRCIXFxU
SKTdjclkTP6faH49q9+i3mMP6qaRQm88aZqe2XWE1ItxcFTA9FaPP9cVEwIptoHY
Uxu3Lr3Yc3FLx5b67aC4J/gUuMbAjBWG4K+tOcDDG56P4Hi3r5jXAR+i+IXncYHg
+Xs6/vUR+DOXTSMH2epNw8npH/O8hzYCSFdB1JyygHJ+bH2lUXZGKB45QpL7vItr
BMpq5qPkBZ1TuGvC4h0XiDMERsv1SlqXrRADhCRvZmRRt0tmvdyvDiFKaBIVPrLz
Prs6xoRnHv4lIbBNYugu
=ATkj
-----END PGP SIGNATURE-----

--iFRdW5/EC4oqxDHL--
