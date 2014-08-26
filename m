Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934408AbaHZJuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 05:50:17 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55292 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932445AbaHZJuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 05:50:15 -0400
Message-ID: <53FC584B.7070508@ti.com>
Date: Tue, 26 Aug 2014 12:50:03 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Pranith Kumar <bobby.prani@gmail.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Rob Clark <robdclark@gmail.com>, Jingoo Han <jg1.han@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        open list:
	FRAMEBUFFER LAYER <linux-fbdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, ;
Illegal-Object: Syntax error in CC: address found on vger.kernel.org:
	CC:	;
			^-missing semicolon to end mail group, extraneous tokens in mailbox, missing end of mailbox
Subject: Re: [PATCH] fbdev: Remove __init from chips_hw_init() to fix build
 failure
References: <1408623838-8275-1-git-send-email-bobby.prani@gmail.com>
In-Reply-To: <1408623838-8275-1-git-send-email-bobby.prani@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="N1fIQi9faawGQFQOVLv0mwsC15pDi8WAX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--N1fIQi9faawGQFQOVLv0mwsC15pDi8WAX
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 21/08/14 15:23, Pranith Kumar wrote:
> Fix build failure caused as follows:
>=20
> The function chipsfb_pci_init() references
> the function __init chips_hw_init().
> This is often because chipsfb_pci_init lacks a __init=20
> annotation or the annotation of chips_hw_init is wrong.
>=20
> make: *** [drivers] Error 2
>=20
> by removing the __init annotation from chips_hw_init(). The other thing=
 that
> could have been done was annotating chipsfb_pci_init(). But that cannot=
 be done
> since chipsfb_pci_init() is called from non __init functions.
>=20
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> ---
>  drivers/video/fbdev/chipsfb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/video/fbdev/chipsfb.c b/drivers/video/fbdev/chipsf=
b.c
> index 206a66b..59abdc6 100644
> --- a/drivers/video/fbdev/chipsfb.c
> +++ b/drivers/video/fbdev/chipsfb.c
> @@ -273,7 +273,7 @@ static struct chips_init_reg chips_init_xr[] =3D {
>  	{ 0xa8, 0x00 }
>  };
> =20
> -static void __init chips_hw_init(void)
> +static void chips_hw_init(void)
>  {
>  	int i;
> =20
>=20

Thanks, queued for 3.17 fbdev fixes.

 Tomi



--N1fIQi9faawGQFQOVLv0mwsC15pDi8WAX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT/FhLAAoJEPo9qoy8lh71LxsP/2ro1AlsY1EcsHlsG/B+SRqd
rCVrP04UEcxKV3JP0FonyacT9/5FXCLnIF/eEeCdZgOuX2s0IS8O8ZDJVCvwoCc7
1SLso7Vz/JAFmW5VnG4gIzSv3eDvZf7Gq84pZ055eX/p21+qGln2GJJWezjhdKhI
jgaKFmfRjLi2rHm20I9pOXhtsqeYBeWtLL2tm4zS6WaTnh5egEoC4lmjVdSZC6ap
6HrBz85hDX2QjH6BKKAJ7/nq+RhSya2wCpVh80Yydzd1nPlRff4vJGG0iJ+fwJcm
fb46wCvv0pwlxbBuU0xqOYxs2T1xUTTFkR0r1m2ZOl5vlW+tPlf43R/Ogn5OK4l5
MUp+5ioXBP8X7IukioHVYrqtct0fXSWizcYN0/3jihMUa9UpaF9LeIf/Bu0eQGV9
2wkQgb6D52k8qcYtLo2HapWbGk+Wlin0vYHglmbjQgr0hj16XapahfcGLQP7qKb6
CiHt7D4wYdBrEXKq1bQFa4WtOXKlI4kT/4GjX2627RXlSHJbsem4ZULKWouIOxSs
peV1+ZuJksenQJ/iTGerjQKd9JNhuy7iCkk1C/xs0zbp/dTTpQSkAtS7B3zglhyT
Jv3IM+TnGf0GAihE185088n6fenXa9AiG/tn8qHIjn9cuWphga+STuf7EVXKels4
TDAidOgx7bjXVQl8+EkA
=c8f3
-----END PGP SIGNATURE-----

--N1fIQi9faawGQFQOVLv0mwsC15pDi8WAX--
