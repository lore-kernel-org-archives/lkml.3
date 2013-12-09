Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933453Ab3LIJyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 04:54:45 -0500
Received: from multi.imgtec.com ([194.200.65.239]:41773 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933128Ab3LIJyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 04:54:44 -0500
Message-ID: <52A5935A.4040709@imgtec.com>
Date: Mon, 9 Dec 2013 09:54:34 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>
CC: Seth Jennings <sjenning@linux.vnet.ibm.com>, <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/zswap.c: add BUG() for default case in zswap_writeback_entry()
References: <52A53024.9090701@gmail.com>
In-Reply-To: <52A53024.9090701@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="TBnT1kX28txvQICNnkDoM0RxVmi0PACcv"
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_12_09_09_54_42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--TBnT1kX28txvQICNnkDoM0RxVmi0PACcv
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 09/12/13 02:51, Chen Gang wrote:
> Recommend to add default case to avoid compiler's warning, although at
> present, the original implementation is still correct.
>=20
> The related warning (with allmodconfig for metag):
>=20
>     CC      mm/zswap.o
>   mm/zswap.c: In function 'zswap_writeback_entry':
>   mm/zswap.c:537: warning: 'ret' may be used uninitialized in this func=
tion
>=20
>=20
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  mm/zswap.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>=20
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 5a63f78..bfd1807 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -585,6 +585,8 @@ static int zswap_writeback_entry(struct zbud_pool *=
pool, unsigned long handle)
> =20
>  		/* page is up to date */
>  		SetPageUptodate(page);
> +	default:
> +		BUG();

This doesn't hide the warning when CONFIG_BUG=3Dn since BUG() optimises
out completely.

Since the metag compiler is stuck on an old version (gcc 4.2.4), which
is wrong to warn in this case, and newer versions of gcc don't appear to
warn about it anyway (I just checked with gcc 4.7.2 x86_64), I have no
objection to this warning remaining in the metag build.

Cheers
James


--TBnT1kX28txvQICNnkDoM0RxVmi0PACcv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJSpZNhAAoJEKHZs+irPybfE8UP/jRC8/+2v6GI8UFDyL9Vj81Y
GhtBn5KgZ4SQ7Yfws6AFtYlLt2WgNblZc9j0eJPq9VlOpBGO8c/qhmvDWYLUAYqx
KC6Z/E8Q1QkBH0VEBYO1ierUw6KEUTXjb2vz55Mjd5UbHrY1XZhTlq69s74GX3vr
28k4AX/FqTwPX5CkLz3zEfukqy80KeATqFX3iAqVDYu8Ri6efydctvYNgVPXpVq5
Cf16znaT+o4wXcAj2BMYPhS9o57BzvxBr4WE7hW8j5SuqGltycvsCaAHMi/06ZjJ
J8YxHDqvoVx7dwPhPPMzvu0VwxgGMcG0DTlPCB1FVv0GLYvmLGL1/oRO8v8DBDit
SC5g5WstLcUdfBdqtXijCdTjpSlrgKIG5sbRquSfrEF9MUR05cazuREz8zzbtR5g
JMcGBB9fqbrgAJFgzptGbFRieWK62u/3uMr5s+UcLG4JRErmWf2bqe4hRt9D/Rv5
I47/b2kfIU1U7M9Bl8/a+nVy8nAL7mbKZi5MeDEFpOSpW27rZWU+aFTCLPK707LH
r4U00p4aEdsYRHsRZU+Wb0xyAbtICP7YF16Q1k5AcvVQy/bLFgj4K7xPf0rPtLqV
i48fITTZAD5GLF33eFu4E4F0bNUFBdahQzjV8nqsCWNl0J+ByFl+F/J1UxPwoOzE
sP94u2PHNKUi5sgquguM
=1+3r
-----END PGP SIGNATURE-----

--TBnT1kX28txvQICNnkDoM0RxVmi0PACcv--

