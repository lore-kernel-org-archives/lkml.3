Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837Ab3CSGdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 02:33:55 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59553 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab3CSGdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 02:33:54 -0400
Date: Tue, 19 Mar 2013 08:33:34 +0200
From: Felipe Balbi <balbi@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Xi Wang <xi.wang@gmail.com>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: linux-next: manual merge of the akpm tree with the usb-gadget
 tree
Message-ID: <20130319063334.GA16715@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130319143922.f60895f782e5c8e9824c447b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
In-Reply-To: <20130319143922.f60895f782e5c8e9824c447b@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Mar 19, 2013 at 02:39:22PM +1100, Stephen Rothwell wrote:
> Hi Andrew,
>=20
> Today's linux-next merge of the akpm tree got a conflict in
> drivers/usb/gadget/amd5536udc.c between commit 6c39d90393a2 ("usb:
> gadget: amd5536udc: remove unnecessary initializations") from the  tree

Looks like there's a small bug in your scripts: "from the  tree" misses
"usb-gadget".

> and commit "drivers/usb/gadget/amd5536udc.c: avoid calling dma_pool_creat=
e()
> with NULL dev" from the akpm tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
>=20
> --=20
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>=20
> diff --cc drivers/usb/gadget/amd5536udc.c
> index f52dcfe,142616a..0000000
> --- a/drivers/usb/gadget/amd5536udc.c
> +++ b/drivers/usb/gadget/amd5536udc.c
> @@@ -3232,6 -3235,12 +3232,10 @@@ static int udc_pci_probe
>   	pci_set_master(pdev);
>   	pci_try_set_mwi(pdev);
>  =20
> + 	dev->phys_addr =3D resource;
> + 	dev->irq =3D pdev->irq;
> + 	dev->pdev =3D pdev;
>  -	dev->gadget.dev.parent =3D &pdev->dev;
>  -	dev->gadget.dev.dma_mask =3D pdev->dev.dma_mask;
> +=20

fix looks alright, thank you

--=20
balbi

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRSAa+AAoJEIaOsuA1yqREzaMP/jtr0Wv0q2eZ2wzSPa5+bYti
+SFKE8HlOIcTMESkL99hyHx6fyrFlZQwsExT8eu8Xbc6FVfMGvHdp84fFSAxoiOx
Y0voFseQ6vZZOdKICczSpgsjJnloxeD4ToLQoAA/jBqDcdm4JYwFHkuenJZWCmn7
nxKrAy528zo189uWKqjr/6LaiqWPvk4lNgYYpCM/ifgI0jUVpNMtgISR9xRiLOyy
rMXG2WLALDaInZqrM7VqwnLczjJwyfqUoq/aRF+hGN3tuT7jIbh8KjI5A37X8e+O
lbzf0HrD1/7IMh0TWTpz9uXTyx3ZLNB6lifoK72X3X8WvlDrOulVZswxfnRlCet8
h4WRZ6ADckaZ7ViV3O265RDdEI12fWrvZOYP7t/ALQRIuwUobYymolGfx9xzJ3iR
juBxKqcc2hxuatsAI+PBJsUxrWOJSqheCGihAzXaaw+Qdsf+qTp2oNbeX85ufxyc
9TXC9ooOtf19FRjVmJ0Mugyz5BROKjfa+Rgi27oOiH+AEXNA4G2kFC9PWmF+vjdg
m2vN8qZimFGPstGpgPiGmTqf+jsYVCF3FpBlYZgQe8ou/i0bxcNDn+KKhfO4n0E4
rVyULejJEI++W0Qib8tRZKBDrQ6/y1Mjv5cC07zWiOskL0M8btoCKxrOH4Hg7/yo
Q5DE+N/W6SfqZKMEKQVk
=16mr
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
