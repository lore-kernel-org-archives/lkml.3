Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbaBJLX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:23:58 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33221 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178AbaBJLXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:23:55 -0500
Message-ID: <52F8B6B3.5080602@ti.com>
Date: Mon, 10 Feb 2014 13:23:31 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>, <linux-fbdev@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Ondrej Zajicek <santiago@crfreenet.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH] fbdev: suppress warning when assigning vga-save/restore
 base
References: <1375637141-2878-1-git-send-email-dh.herrmann@gmail.com>
In-Reply-To: <1375637141-2878-1-git-send-email-dh.herrmann@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="pSr8wV9pxrFSlVvhxdCU4swnVfXV7aJbg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--pSr8wV9pxrFSlVvhxdCU4swnVfXV7aJbg
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi David,

On 04/08/13 20:25, David Herrmann wrote:
> If drivers use "struct resource" objects to retrieve the vga-base, they=

> must correctly cast the integer to pointer. With x86+PAE we have 32bit
> pointers but 64bit resource_size_t. Hence, cast it to "unsigned long"
> before casting to "void*" to suppress warnings due to size differences.=

>=20
> As IO addresses are always low addresses, we can safely drop the higher=

> part of the address. This is what these drivers did before, anyway.
>=20
> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
> Reported-by: H. Peter Anvin <hpa@zytor.com>
> ---
> Hi
>=20
> hpa reported build-warnings on i386+PAE:
> /home/hpa/kernel/distwork/drivers/video/arkfb.c:1019:23: warning: cast =
to
>     pointer from integer of different size [-Wint-to-pointer-cast]
>     par->state.vgabase =3D (void __iomem *) vga_res.start;
>                          ^
> /home/hpa/kernel/distwork/drivers/video/s3fb.c: In function =E2=80=98s3=
_pci_probe=E2=80=99:
> /home/hpa/kernel/distwork/drivers/video/s3fb.c:1186:23: warning: cast t=
o pointer
>     from integer of different size [-Wint-to-pointer-cast]
>     par->state.vgabase =3D (void __iomem *) vga_res.start;
>                          ^
>=20
> This is due to resource_size_t being 64bit but "void*" 32bit. This patc=
h tries
> to suppress these warnings but I am not really comfortable fixing this.=
 I have
> no idea whether my assumption (IO address are 32bit) is right. Please v=
erify.
>=20
>  @David: The following 3 commits of yours presumably introduced the war=
nings. I
> would be glad if you could review this:

What was the conclusion on this patch? Should I apply for 3.14 fixes?

 Tomi



--pSr8wV9pxrFSlVvhxdCU4swnVfXV7aJbg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS+LazAAoJEPo9qoy8lh71+T8P/jPE9cubrgsVatJE8w5yIXQ9
hKDrlMVZ7Pc6UJgOutTTcXiQ+MuhsCQwNlFxA+j7VNy2sEhLOOqhfiHQdjzDzi7d
9qbTGyDgLkdTCRsb23pY3hZalEeI8mx2+jHV+qUFSO03oLpjCYblexLnxkIaQayW
CuIKiL+gQnF1Wecc+oEuejhPxPGB4WZoqumOx3nHib5tKipoKRrWOMtaiy6Nlxlu
KKoe0YxRcv8e5PyzvTlza7YIyCItmUiEgeNS29jVkUBPB73wkkTdyYOVapPJMQAA
O81olj7lnCZVMto6R3boFV1DhbrrJM80jW3Bz5ihFsXcz2By0EcyJI0UYuFme+71
CNA2hUU00urx59fK6vievQuUPx0+FNa48MJjWDz4elT9/Yadr9zpjxZc8LYv41O8
9mZIgfww/ZIhj13IimPWUfRUDl1N6+cOr0aoW/Zhv4CRYu0urfE5vpn7kLAXD0aN
7bhJXFbNg+maknliESNCOfxGV3+FRh9/msstuBvvg97LDQqk0TllyIBbIw2Edj/E
UoquV+usKc+k26jTr1Kf111oUXFO5Ynu6eNrJBkyrGgXl/qJOEjIS0+y8O1CNZk5
hTe04obMIaC47+RVcHTqW5/hb3UZA09Bw4VT0gKgaFYDj/tnaPBCu6+NpMDCEean
hUVOBlu3r5vZ2hvHEZy5
=XtDI
-----END PGP SIGNATURE-----

--pSr8wV9pxrFSlVvhxdCU4swnVfXV7aJbg--
