Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab3J2KmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 06:42:15 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34313 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331Ab3J2KmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 06:42:13 -0400
Message-ID: <526F9101.4010108@ti.com>
Date: Tue, 29 Oct 2013 12:42:09 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>, <linux-fbdev@vger.kernel.org>
CC: James Bates <james.h.bates@gmail.com>, <linux-kernel@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Subject: Re: [PATCH v3] efifb: prevent null-deref when iterating dmi_list
References: <1380732056-5387-1-git-send-email-dh.herrmann@gmail.com> <1380732219-5458-1-git-send-email-dh.herrmann@gmail.com>
In-Reply-To: <1380732219-5458-1-git-send-email-dh.herrmann@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="GTSfuV7XD6OkkTKW5CmCMu43Jr7ULHeXb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--GTSfuV7XD6OkkTKW5CmCMu43Jr7ULHeXb
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/10/13 19:43, David Herrmann wrote:
> From: James Bates <james.h.bates@gmail.com>
>=20
> The dmi_list array is initialized using gnu designated initializers, an=
d
> therefore may contain fewer explicitly defined entries as there are
> elements in it. This is because the enum above with M_xyz constants
> contains more items than the designated initializer. Those elements not=

> explicitly initialized are implicitly set to 0.
>=20
> Now efifb_setup() loops through all these array elements, and performs
> a strcmp on each item. For non explicitly initialized elements this wil=
l
> be a null pointer:
>=20
> This patch swaps the check order in the if statement, thus checks first=

> whether dmi_list[i].base is null.
>=20
> Signed-off-by: James Bates <james.h.bates@gmail.com>
> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
> ---
> v3: fixes the "Author" field and James' email address
>=20
>  drivers/video/efifb.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
> index 7f9ff75..fcb9500 100644
> --- a/drivers/video/efifb.c
> +++ b/drivers/video/efifb.c
> @@ -108,8 +108,8 @@ static int efifb_setup(char *options)
>  			if (!*this_opt) continue;
> =20
>  			for (i =3D 0; i < M_UNKNOWN; i++) {
> -				if (!strcmp(this_opt, efifb_dmi_list[i].optname) &&
> -				    efifb_dmi_list[i].base !=3D 0) {
> +				if (efifb_dmi_list[i].base !=3D 0 &&
> +				    !strcmp(this_opt, efifb_dmi_list[i].optname)) {
>  					screen_info.lfb_base =3D efifb_dmi_list[i].base;
>  					screen_info.lfb_linelength =3D efifb_dmi_list[i].stride;
>  					screen_info.lfb_width =3D efifb_dmi_list[i].width;
>=20

Thanks, queued for 3.13.

 Tomi



--GTSfuV7XD6OkkTKW5CmCMu43Jr7ULHeXb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSb5EBAAoJEPo9qoy8lh714O4QAIUveRkHIhYsW75KfbBH/IDt
XBjDDxenZXviVowNXetv4M+FoLj35FeCQruvuuDc9SCDmg+rNYyzvN6BM0E9QkAk
YQjdQN6XU1PWIbqSkoiCKh9zTIWEQGP/FJwkS8mqH8O336wc6130F1s+F8QVDpDS
oo9fN3Kazyg1LkHSK0W1iK5Jaf2x+NRYV1ZZA2O/6V4+QBPGvzishhgNxAmiUVbT
qrNEiZnLYZEZRmCZimGownet/iHZez7wSvJOuTObzCihM9cRJSAPu/+UsfCntWej
KgqR2knBxxMPYavpT0B9fh3wVPe3bV6JCmcdu7zWvnzkdJQ75xqirgnK14Vm5Scm
xqPvL1MmJe58ESpzNGBqptCA1SYoFQxNLa8dlWruDmhbp2g+S2Wgw6U4u/Zhiyt9
uuEac40aducq8vLmNP29TioAVSWdxOqoPWgzHIHKnBtOtuXjpIdOReOA8A/Sjvde
6WsY23FdMK9F0KeQD/IXjEzQLabmXk7DWQKV1a7QTy3rtF4r4J9M6JeNjXV7ZAWO
Z6IJuJyZlSZjn3SmTlwt06mHj1EyfOsc9O/+MoMUsqeHXJyPM0Uj5ZMO900Wfx3N
eAkOmjaTStO6/fPOqF52oRbSCkZ4WAsr6zfVbbM3O+4mOzRk+9SQY+DV8inDYV8s
kHp4Pw9sTBGtIZnoICG0
=1Hni
-----END PGP SIGNATURE-----

--GTSfuV7XD6OkkTKW5CmCMu43Jr7ULHeXb--
