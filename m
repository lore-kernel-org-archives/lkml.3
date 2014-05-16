Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997AbaEPKUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 06:20:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:38059 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756419AbaEPKUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 06:20:09 -0400
Date: Fri, 16 May 2014 12:20:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched/fair: cleanup, clamp values with macros clamp()
 and max().
Message-ID: <20140516102005.GS30445@twins.programming.kicks-ass.net>
References: <1400209954-6264-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="foDS2Cs8aPiYvG2b"
Content-Disposition: inline
In-Reply-To: <1400209954-6264-1-git-send-email-yangds.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--foDS2Cs8aPiYvG2b
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 16, 2014 at 12:12:34PM +0900, Dongsheng Yang wrote:
> Rather than use "if" to check and clamp values to allowed minmum or maxmu=
m,
> this patch use macros clamp() and max() to clean it up.
>=20
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> ---
>  kernel/sched/fair.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
>=20
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 7570dd9..939a7ab 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2041,10 +2041,7 @@ static long calc_cfs_shares(struct cfs_rq *cfs_rq,=
 struct task_group *tg)
>  	if (tg_weight)
>  		shares /=3D tg_weight;
> =20
> -	if (shares < MIN_SHARES)
> -		shares =3D MIN_SHARES;
> -	if (shares > tg->shares)
> -		shares =3D tg->shares;
> +	shares =3D clamp(shares, MIN_SHARES, tg->shares);
> =20
>  	return shares;
>  }
> @@ -4133,8 +4130,7 @@ static long effective_load(struct task_group *tg, i=
nt cpu, long wl, long wg)
>  		 * those are clipped to [MIN_SHARES, ...) do so now. See
>  		 * calc_cfs_shares().
>  		 */
> -		if (wl < MIN_SHARES)
> -			wl =3D MIN_SHARES;
> +		wl =3D max(wl, MIN_SHARES);
> =20
>  		/*
>  		 * wl =3D dw_i =3D S * (s'_i - s_i); see (3)

kernel/sched/fair.c: In function =E2=80=98calc_cfs_shares=E2=80=99:
kernel/sched/fair.c:2068:11: warning: comparison of distinct pointer types =
lacks a cast [enabled by default]
kernel/sched/fair.c:2068:11: warning: comparison of distinct pointer types =
lacks a cast [enabled by default]
kernel/sched/fair.c: In function =E2=80=98effective_load=E2=80=99:
kernel/sched/fair.c:4157:8: warning: comparison of distinct pointer types l=
acks a cast [enabled by default]
kernel/sched/fair.c: In function =E2=80=98migrate_task_rq_fair=E2=80=99:

--foDS2Cs8aPiYvG2b
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdeZVAAoJEHZH4aRLwOS6kVsP/R1N6r64tNecmNMSZaI3n3FE
ZwxrAeuT2oUhAKAjKd+ZZNcecfan9DQ+5XqdJHtKVj1WAxz468k2/EwVX1K9rWuW
LFJhiu6aD5Gtel0MwgJClYKSAhOvm3vZQhwkjogpnsEDwDLW54mS84bVsuC5gXJ6
vjCjhCiZtoxcDKgvvY6bQwec3nJ0Add9AJ6UQXKR0grusnSpw9h+CiPl8OoG1UU5
fG4LRNMwefQPbpSLLePmEoYT39N0NrEsl9c8xTkUDp9X10zzl+81vawIOrnpEuZp
ugfsYaCGG7QDQCzMFC5+9JHgylL8BNeSj6Vre0t/XbOpZEbfjAnQqt+zbI1MMhKZ
9xE4/2aybOu1Q2pXT/+fFRFuZ4W5vP2hwcgFg84700vnoP+WgDF3EQ5hA3GlWizI
VHBsmxxLp0BuL6O16ZykvZhF/w5voYW1ireWj5mDbl266v2zJpsHjyNu0+VXnlUm
YFffn3tfc5Bm0+bSPHQicGwDW/liNZbWATcF7f+iS08wD1XszWYZmKSUY7tdKWWH
lIL9zcuIOySSq6K/sM36qC4iAJzfuMoyLzy9bd1n9reI+6QTl64k3tfNpm+LR+bE
ozHK9Tkz3cD0D5qoXh/wN2oTlILssXxmJuR/FBimcfGrQKqyKlguDgo9WEWwlDDJ
Rr7tJrOQUtdA8UF0Cj4u
=Jzyj
-----END PGP SIGNATURE-----

--foDS2Cs8aPiYvG2b--
