Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445AbaLQF0L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 00:26:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39354 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbaLQF0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 00:26:09 -0500
Date: Wed, 17 Dec 2014 16:26:00 +1100
From: NeilBrown <neilb@suse.de>
To: nick <xerofoify@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Question about my patch
Message-ID: <20141217162600.69dc1933@notabene.brown>
In-Reply-To: <5491043D.8020703@gmail.com>
References: <5491043D.8020703@gmail.com>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.25; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/uRa6+JxjtRtqd7rm0tywfL8"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/uRa6+JxjtRtqd7rm0tywfL8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 16 Dec 2014 23:19:09 -0500 nick <xerofoify@gmail.com> wrote:

> Greetings Neil,
> As you our the maintainer for this patch I created:
>=20
> >From ad324f9c2c8117b2f74ad73cb9c6e8185edf5395 Mon Sep 17 00:00:00 2001
> From: Nicholas Krause <xerofoify@gmail.com>
> Date: Tue, 16 Dec 2014 22:54:10 -0500
> Subject: [PATCH] drivers:md: Remove unneeded argument to the function,
>  sync_request in raid5.c
>=20
> Removes unneeded argument of go_faster for the function sync_request as t=
his parameter is never used in the function. Further more do to this we can=
 remove this parameter for the function sync_request
> in the file, raid5.c safely and not break any callers of this function su=
ccessfully.
>=20
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  drivers/md/raid5.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index c1b0d52..e7da686 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -4986,8 +4986,7 @@ ret:
>  	return reshape_sectors;
>  }
> =20
> -/* FIXME go_faster isn't used */
> -static inline sector_t sync_request(struct mddev *mddev, sector_t sector=
_nr, int *skipped, int go_faster)
> +static inline sector_t sync_request(struct mddev *mddev, sector_t sector=
_nr, int *skipped)
>  {
>  	struct r5conf *conf =3D mddev->private;
>  	struct stripe_head *sh;
>=20
> --=20
> 2.1.0
>=20
> I am wondering as I am getting a few build errors if I should sent the pa=
tch anyway or create one that has no warnings. Below our the warnings I am =
getting.
>=20

Adding new warning is definitely not acceptable.

The only way you could get ride of the warning is to not change the argumen=
ts to the function, or
to make the same change to the arguments of every sync_request function.

The former is easier.

i.e. there is no bug here, and nothing to fix.

Thanks,

NeilBrown



> Warnings from Build:
> drivers/md/raid5.c:7047:2: warning: initialization from incompatible poin=
ter type
>  .sync_request =3D sync_request,
>   ^
> drivers/md/raid5.c:7047:2: warning: (near initialization for =E2=80=98rai=
d6_personality.sync_request=E2=80=99)
> drivers/md/raid5.c:7069:2: warning: initialization from incompatible poin=
ter type
>   .sync_request =3D sync_request,
>   ^
> drivers/md/raid5.c:7069:2: warning: (near initialization for =E2=80=98rai=
d5_personality.sync_request=E2=80=99)
> drivers/md/raid5.c:7092:2: warning: initialization from incompatible poin=
ter type
>   .sync_request =3D sync_request,
>   ^
> Thanks Nick=20
> P.S. Sorry about the bad layout if it's hard to read tried to do my best =
to make it readable :).
>

--Sig_/uRa6+JxjtRtqd7rm0tywfL8
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVJET6Dnsnt1WYoG5AQKQcw//bqx7Lg1gZmKV3A7bxJ1b6NM+CUQHuWUd
iUVOW1j/DcBCZhZ6zjdGYdd6tzdokIbVgmB2ppiA+IN+y8q1r4zRn65aEL+/FaVQ
qybNgcOeFCsIm3nzeSpcpGaiz6p/5W5VuBYRAY91kAntxouFdBHS6SDjQW9DTHSR
ZjovyQ1be6ttx0VwBJ+Qwb9EMus/oNIxnwlqXrbI96jKta00Yxt4OFvyDhjPIgaQ
U40vTRF/kCktmBx4m3PJI4BnNLXue/iv/1MAQIP0CfMylxNlRNZbnFP0RbXJ3b62
eEu8OnSGclQFdBitZbWiRca8/ilnPR3SEBdfrSMB+HRYafiAaY7B9mvtuUFGZ6H+
NDfnJaNDO7EzIaF4U8HWfwRWnHuo6XSK0sVAjWWr+8ViY2/b7Dml5Lu43FMERvRk
W9SI56oYAwKQQoITknsb1/nWT7DjuG/HppJ20NHMADy7eTfs9rPhHu9TWTfzlBH0
fGr9fOevLz12IYDNkpJaNB0h3kQH2W6qOOIBLuA9Dg7v3EgIMK6X0vrdU8YTBLfI
Iw8POAEDqT+PeKXZBXkFclEbLHyfWFaX8gGL5HXMgG2XqrHx7K7GhWG0UJ2j1wLe
3lbZa4kacIC/whNxCd5BAapXK1m51SUYC1rwXGzJDtk375pPOWK8Y05BOA+kXwW3
zOXGh8E0RvI=
=iDZS
-----END PGP SIGNATURE-----

--Sig_/uRa6+JxjtRtqd7rm0tywfL8--
