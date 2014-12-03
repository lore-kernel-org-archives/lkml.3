Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbaLCLtr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:49:47 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:39370 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430AbaLCLtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:49:45 -0500
Message-ID: <547EF8CC.9030502@ti.com>
Date: Wed, 3 Dec 2014 13:49:32 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
CC: <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] video: fbdev: vt8623fb: suppress build warning
References: <1417039645-5313-1-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1417039645-5313-1-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="g7gO4FJfvImpV03dqt41AfEwxnwtX7ELi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--g7gO4FJfvImpV03dqt41AfEwxnwtX7ELi
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 27/11/14 00:07, Lad, Prabhakar wrote:
> this patch fixes following build warning:
> drivers/video/fbdev/vt8623fb.c: In function =E2=80=98vt8623_pci_probe=E2=
=80=99:
> drivers/video/fbdev/vt8623fb.c:734:23: warning: cast to pointer from in=
teger of different size [-Wint-to-pointer-cast]
>   par->state.vgabase =3D (void __iomem *) vga_res.start;
>                        ^
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  drivers/video/fbdev/vt8623fb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/video/fbdev/vt8623fb.c b/drivers/video/fbdev/vt862=
3fb.c
> index 5c7cbc6..ea7f056 100644
> --- a/drivers/video/fbdev/vt8623fb.c
> +++ b/drivers/video/fbdev/vt8623fb.c
> @@ -731,7 +731,7 @@ static int vt8623_pci_probe(struct pci_dev *dev, co=
nst struct pci_device_id *id)
> =20
>  	pcibios_bus_to_resource(dev->bus, &vga_res, &bus_reg);
> =20
> -	par->state.vgabase =3D (void __iomem *) vga_res.start;
> +	par->state.vgabase =3D (void __iomem *) (unsigned long) vga_res.start=
;

This does look quite ugly... Where does the warning come from in the
first place. Isn't vga_res.start (resource_size_t) the size of a pointer?=


 Tomi



--g7gO4FJfvImpV03dqt41AfEwxnwtX7ELi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUfvjSAAoJEPo9qoy8lh71fgIP/2borca8+dBmssVIMsPucCq4
o90sbaCYwJNvHxN15JNejczx82Tswm962D8LhkqGkaJa1Dslv8NcQvvgdiP/QE9S
66wmZGvi+sNHk5/rlTBmU30vF3d3M4Ito8upuWsIsWlK34PGleZ+TLoHCIuh/NHK
FMqqZzoUyoDEDV/8hdJqEw0FHD+kGceJ75U+SCEbSJ74AVCQr4xVa8RBZRBZZ6XK
zIFmug7RsAMeFzMBNy4wXnBwulGYzGV06u/NfyYJa2ZTll7OCnD1V2MKwSFaKZww
y9JI+FDc/0LVQy1nyxciv2TSreeJ7fS1W15E5tw53gBB396KDytRN3WBLMu1gfng
2vwshLYR8wGkZFkq81CUBvxFyk7miR99qKOy0zPyb23cxK0YQLFDFKHO6xnbkNsb
RrweQ782pq5YDW1OrNO0Q1g6moIUGTn5Fa09ULnCrrlNC4crXthdy2XS0DMxXA8s
UkZ/PJbgqYqfh1/qPFAkAsmyTim/tbdjcgudavJJh69Wn4WsUe037ahLYP+v2Ltg
Td4+E9tuyN9DQ9zddQ4xIQse2RbF211Zqzz0B9Yb2b+H0DJTt0cS7RqtGDbgxlpK
noYp8KGtyzOdMtZF4B3NCjTVOzsrWj0QPl6kxUADyIssiMpUd/jaiC8EqL+/aXnT
B0J/S0QMsEBMCz9uKyn2
=jaBs
-----END PGP SIGNATURE-----

--g7gO4FJfvImpV03dqt41AfEwxnwtX7ELi--
