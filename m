Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbaFYFHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 01:07:51 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43089 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaFYFHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 01:07:50 -0400
Date: Wed, 25 Jun 2014 07:07:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, chegu_vinod@hp.com, peterz@infradead.com,
        mgorman@suse.de, mingo@kernel.org
Subject: Re: [PATCH 9/7] sched,numa: remove task_h_load from task_numa_compare
Message-ID: <20140625050735.GB28774@twins.programming.kicks-ass.net>
References: <1403538095-31256-1-git-send-email-riel@redhat.com>
 <20140624151454.2a05082e@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0eh6TmSyL6TZE2Uz"
Content-Disposition: inline
In-Reply-To: <20140624151454.2a05082e@annuminas.surriel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0eh6TmSyL6TZE2Uz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 24, 2014 at 03:14:54PM -0400, Rik van Riel wrote:
> The function effective_load already makes the calculations that
> task_h_load makes. Making them twice can throw off the calculations,
> and is generally a bad idea.
>=20
> Signed-off-by: Rik van Riel <riel@redhat.com>
> ---
>  kernel/sched/fair.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 1aaa3b4..318a275 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1227,7 +1227,7 @@ static void task_numa_compare(struct task_numa_env =
*env,
>  	dst_load =3D env->dst_stats.load;
> =20
>  	/* Calculate the effect of moving env->p from src to dst. */
> -	load =3D task_h_load(env->p);
> +	load =3D env->p->se.load.weight;
>  	tg =3D task_group(env->p);
>  	src_load +=3D effective_load(tg, env->src_cpu, -load, -load);
>  	dst_load +=3D effective_load(tg, env->dst_cpu, load, load);
> @@ -1251,7 +1251,7 @@ static void task_numa_compare(struct task_numa_env =
*env,
> =20
>  	if (cur) {
>  		/* Cur moves in the opposite direction. */
> -		load =3D task_h_load(cur);
> +		load =3D cur->se.load.weight;
>  		tg =3D task_group(cur);
>  		src_load +=3D effective_load(tg, env->src_cpu, load, load);
>  		dst_load +=3D effective_load(tg, env->dst_cpu, -load, -load);

Shall I merge this into patch 3?

--0eh6TmSyL6TZE2Uz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTqlkJAAoJEHZH4aRLwOS6P3wP/2MMxT6zvRaDsqf0giIfzhmg
fepBIsn2MNUsS5RQ0K3L07pkXvN/xpRcC8Do/53V55Dn2SbCE+PZ8zy5BIOcaBL8
O5SY/ocLsMaU+oa3CB2DlwNnoyxXkrwn9TVLR43cNG/Ro8UrxDXsRRLtnanBUQgd
Qhpoxhsmd33nJuJvKUtKYo62SqEKrCkXaWsnXmvso3wySLN0ND+azt6VZ/wfkQ2A
1dnt/AbgC/6yTT2KrspKoiib5TUk2qMD0Wnl5mggivFi9fOJQvluaql0hoC4tDzn
n+oJt91xqTbNeiH9BzKRCTSm+kclJsxYEWuiLM6Q6x58sNY6O4xKhiEmcA2xCa/F
asEvSkGOVj+C4v1vutF8PQohuW5D4eN/URCg0Ly2nStFLpvAVsfPe4XrS8H9ZnDh
pONZozN7eXwsvbO76Og5VTkXtSKAT4X4tXCgI3pPhiIpslmhSiq9v4c0SpzrW8Lp
nbjwv+O10oh2uN2DLV3pSOeY+Hml4seQSHKwVqja2L/MjT1GqYvMylPbJ5KcYMDC
8BuguHANxkKjRlbdoTmkbTTvVAVQkKKx0hQHRXFnpLDh9cy/1HJdeG2sTGZm8cCh
sVt4JP8THTnzKt3t0kUYBQCwOGjQXFUKTy7yuRZ8WUwMZY9xKWWc+V3JbFwhAN6Z
g9LnKJ3eAH3h7KXaV1Xe
=NBYw
-----END PGP SIGNATURE-----

--0eh6TmSyL6TZE2Uz--
