Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbaFWLLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 07:11:49 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52373 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443AbaFWLLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 07:11:47 -0400
Message-ID: <53A80B6B.5060805@ti.com>
Date: Mon, 23 Jun 2014 14:11:39 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Emil Goode <emilgoode@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Jingoo Han <jg1.han@samsung.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
CC: <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] video: Remove kfree call since devm_kzalloc() is used
References: <1403301037-10699-1-git-send-email-emilgoode@gmail.com>
In-Reply-To: <1403301037-10699-1-git-send-email-emilgoode@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="6EvHtPagVnHAXSSuAF098foJG355qadOV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--6EvHtPagVnHAXSSuAF098foJG355qadOV
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 21/06/14 00:50, Emil Goode wrote:
> We use devm_kzalloc() to allocate memory for the struct vt8500lcd_info
> pointer fbi, so there is no need to free it in vt8500lcd_remove().
>=20
> Signed-off-by: Emil Goode <emilgoode@gmail.com>
> ---
>  drivers/video/fbdev/vt8500lcdfb.c |    2 --
>  1 file changed, 2 deletions(-)
>=20
> diff --git a/drivers/video/fbdev/vt8500lcdfb.c b/drivers/video/fbdev/vt=
8500lcdfb.c
> index a8f2b28..a1134c3 100644
> --- a/drivers/video/fbdev/vt8500lcdfb.c
> +++ b/drivers/video/fbdev/vt8500lcdfb.c
> @@ -474,8 +474,6 @@ static int vt8500lcd_remove(struct platform_device =
*pdev)
>  	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	release_mem_region(res->start, resource_size(res));
> =20
> -	kfree(fbi);
> -
>  	return 0;
>  }
> =20
>=20

Thanks, queued for 3.17.

 Tomi



--6EvHtPagVnHAXSSuAF098foJG355qadOV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTqAtrAAoJEPo9qoy8lh715A0P/jQAOK46n0TJVCFnPESUagp7
mDo9pIf/SocVGK5iMOdn1/vgUZoK9e+4DL0IfYyZvrklmRABUQtM3jk9HQittrHe
3WmMQjqLdWaxdUXt47zJQqYQIw+53VQ3HUng/OEiDL1XCIYBZTRnJEoYnzSmIVTg
cCkwv3zX2KLGjkAxRbKWVCJTUv45+w3ZyJs/6C/Qzx4LRXjZ/HGfkyz9x8LDk98u
E0T9dN1+zkxcr4Zx8CuQBzIR3aWvF43JGUxIiSHT6eh50yWe78bEIM03be8PjNOQ
WrxhAIG10VSKAdwzG8RoG9f41+5cW5j7GoWUE9x5hhHVHHHGdFjEFGhtULtSG/wc
tcWMhipgRRy9UWAVN65qplim1aFttb7W30QcoChUrbzHIEUYvDBSfix4Cx6+Qana
UxOzSxCBK4Sqcjj0sK0UZtutd5kSP2UjcYea9a2rsf4B52RZbD378Rm8iybE78fv
nHixicROfXydkL5ZxvGHdCKrR/QKqk5+5jSCRdkxqa2MoQJNqvjainxb/P7q7O95
Z8iphhfump6bTRuU4LW15sYta5wMZ+zA4nhzWMm9tlop+YERobRyUnk09sKnv5Cj
19B28IFjdqLPzsj6OeEf1YyJtTqlwpM7t/jsN0A21JbQAyy6auCBQMF+blDsrc3B
8+utDo4jZg+OlMV8mSAI
=ZtRV
-----END PGP SIGNATURE-----

--6EvHtPagVnHAXSSuAF098foJG355qadOV--
