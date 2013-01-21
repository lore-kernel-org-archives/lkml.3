Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab3AUM2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:28:36 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:33372 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab3AUM2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:28:34 -0500
Date: Mon, 21 Jan 2013 14:28:15 +0200
From: Felipe Balbi <balbi@ti.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: Felipe Balbi <balbi@ti.com>, <kernel-janitors@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 13/15] drivers/usb/musb/omap2430.c: adjust duplicate test
Message-ID: <20130121122815.GX8777@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358773378-4700-1-git-send-email-Julia.Lawall@lip6.fr>
 <1358773378-4700-14-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lPJ5i9rX1WvdYcWF"
Content-Disposition: inline
In-Reply-To: <1358773378-4700-14-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--lPJ5i9rX1WvdYcWF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jan 21, 2013 at 02:02:57PM +0100, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> Delete successive tests to the same location.  Data is the just previously
> allocated and tested value.  Test the result of the allocation made here
> instead.
>=20
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
>=20
> // <smpl>
> @s exists@
> local idexpression y;
> expression x,e;
> @@
>=20
> *if ( \(x =3D=3D NULL\|IS_ERR(x)\|y !=3D 0\) )
>  { ... when forall
>    return ...; }
> ... when !=3D \(y =3D e\|y +=3D e\|y -=3D e\|y |=3D e\|y &=3D e\|y++\|y--=
\|&y\)
>     when !=3D \(XT_GETPAGE(...,y)\|WMI_CMD_BUF(...)\)
> *if ( \(x =3D=3D NULL\|IS_ERR(x)\|y !=3D 0\) )
>  { ... when forall
>    return ...; }
> // </smpl>
>=20
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Already in my tree ;-)

commit b37457d80bc3e2a6bb86a6036c572574614a7631
Author: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Date:   Tue Jan 8 22:11:14 2013 +0300

    usb: musb: omap2430: fix wrong devm_kzalloc() result check
   =20
    Commit 00a0b1d58af873d842580dcac55f3b156c3a4077 (usb: musb: omap: Add d=
evice
    tree support for omap musb glue) assigns result of devm_kzalloc() call =
to
    the 'config' variable but then checks for NULL the 'data' variable (alr=
eady
    checked after previous call). Thus we risk a kernel oops further when d=
ata
    pointed by 'config' is written to by subsequent of_property_read_u32() =
calls
    iff the allocation happens to fail...
   =20
    Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
    Signed-off-by: Felipe Balbi <balbi@ti.com>

diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index b15bb05..bb48796 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -543,7 +543,7 @@ static int omap2430_probe(struct platform_device *pdev)
 		}
=20
 		config =3D devm_kzalloc(&pdev->dev, sizeof(*config), GFP_KERNEL);
-		if (!data) {
+		if (!config) {
 			dev_err(&pdev->dev,
 				"failed to allocate musb hdrc config\n");
 			goto err2;

--=20
balbi

--lPJ5i9rX1WvdYcWF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ/TRfAAoJEIaOsuA1yqREiN8QAKZ/9VQe+dfO90v7PuZsfyD1
lgJ/+RO+xW3EguNfuFHX+mCloBwUw9aAdThlowDjBhYd2YVgmznkNs7O2VnLJETv
e+/QxAwo5jgZba2w3eH+Guwnb6oplhR+Cy5rOTUeoAfgLdS4kITh4Ee84HOiHWHG
n/UZ8/H/K+gmPMH3eSmhWUMnHoeQ+7MMZTHZ1yNOGvGdW1pgDsM9Dzo/quN0fxdh
/chMZEhQG4Rvnzj5OnjOHuiovbhZxBkmowrEbiePeIWXqDxkKkqOoUdSu4SfNzOp
ejmhWw1ki1L0DsngCmTaoufAAtJwuPPQTOqoJHlgGgoea2JstR2JIIm46fGwvmTP
id7xvUyVHSHUXyFav17K2ou/WPnFnLvdBEOBhUzZobN5tDNe6w0X8GmegM2N137L
bnDgg4oi+3x5/j7W2Zjob738HUpLq2M4mELVqEGa0Bmyyz3A+Igimo6opILsOk6M
OFlj6WAFLnQERh4VKE5yGtnoaO5NPiERFQYaVluHcA2JZiPtvwD3bRfi07B0u2S+
Poez6l1N+Eirf3fmSezDR2s55OHj2R/PN9aDNnzA7ziL7dOvq1atNWiiS2kF+Nqs
p8/KHdDZ8iF/08J+PeUeqUqLEBLGiUDwYAIKoLeOVWj8f8dzwd3lMAl2Eh0wYBTS
Fm7JDZ1rmOeWlxG08Ok6
=AnlX
-----END PGP SIGNATURE-----

--lPJ5i9rX1WvdYcWF--
