Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbaFFKPR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 06:15:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:56842 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbaFFKPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 06:15:16 -0400
Date: Fri, 6 Jun 2014 12:15:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: zhdxzx@sina.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mike Galbraith <mgalbraith@suse.de>, Ingo Molnar <mingo@kernel.org>,
        dhillf <dhillf@gmail.com>, "hillf.zj" <hillf.zj@alibaba-inc.com>
Subject: Re: sched: how to pick runqueue when checking task hot?
Message-ID: <20140606101508.GP3213@twins.programming.kicks-ass.net>
References: <20140606065956.854A6718001@webmail.sinamail.sina.com.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X78YbkCBd9ye7Cvs"
Content-Disposition: inline
In-Reply-To: <20140606065956.854A6718001@webmail.sinamail.sina.com.cn>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X78YbkCBd9ye7Cvs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 06, 2014 at 02:59:56PM +0800, zhdxzx@sina.com wrote:
> Hi all
>=20
> When computing cache hot, question-1: should we check the number of runni=
ng tasks
> against the migration target runqueue, as shown by the following diff?
>=20
> It looks that we dont migrate task if it is buddy and the target cpu is n=
ot idle.
>=20
>=20
> --- a/kernel/sched/fair.c	Fri Jun  6 12:37:37 2014
> +++ b/kernel/sched/fair.c	Fri Jun  6 13:55:35 2014
> @@ -5051,7 +5050,7 @@ task_hot(struct task_struct *p, u64 now)
>  	/*
>  	 * Buddy candidates are cache hot:
>  	 */
> -	if (sched_feat(CACHE_HOT_BUDDY) && this_rq()->nr_running &&
> +	if (sched_feat(CACHE_HOT_BUDDY) && env->dst_rq->nr_running &&
>  			(&p->se =3D=3D cfs_rq_of(&p->se)->next ||
>  			 &p->se =3D=3D cfs_rq_of(&p->se)->last))
>  		return 1;


That is indeed the effective result for normal balancing, seeing how it
pulls to the dst rq, and this_rq would be dst.

This is of course false for a number of cases these days, most obviously
the nohz idle balancing.

> But based on the comment, question-2: should we check running tasks
> against the runqueue of the given task?

> --- a/kernel/sched/fair.c	Fri Jun  6 12:37:37 2014
> +++ b/kernel/sched/fair.c	Fri Jun  6 14:32:34 2014
> @@ -5051,7 +5051,7 @@ task_hot(struct task_struct *p, u64 now)
>  	/*
>  	 * Buddy candidates are cache hot:
>  	 */
> -	if (sched_feat(CACHE_HOT_BUDDY) && this_rq()->nr_running &&
> +	if (sched_feat(CACHE_HOT_BUDDY) && task_rq(p)->nr_running &&
>  			(&p->se =3D=3D cfs_rq_of(&p->se)->next ||
>  			 &p->se =3D=3D cfs_rq_of(&p->se)->last))
>  		return 1;

That does appear to make more sense indeed, seeing how buddies are pairs
of tasks, so protecting a lone task doesn't make sense.


Mike, how did you intend this code to work?=20

--X78YbkCBd9ye7Cvs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkZSsAAoJEHZH4aRLwOS6SnEP/j0HPqrFCwWu2OwBCl+iAEUN
3/zDrDFVE6N+Z9bB0M/icD2MqMAmlm0eTfK9P8c0j8MhmlnfjDNrXOE3dQk6FQj3
QAe9rHMfwjo+lmn3IVh+TPMpZO0Bwu6xJTqX5T7/ag1erIwQbw2LjPiP86auXVpi
8u3JmDmv+GwakDU5/Um+vzPVhZ9GcC382bP1LuO+6RYcF2XlvYr4XhA8wkNtpMdc
oQ6tktWR1ZKtig2qS4hWvACzhYc+jB2zNSCQmD8Hr6LUG3zz0YntgeUimmVpQH0X
9qWXp9FzRX+q+dbPc6+nLNzHJH02vZ6OBm9uZbzdMsYjeSkbZl9IcVUaSgPbkKmu
1J8k4w+FWD6B2tPQyDNMTxoTctSnYAsOQMGcF0KM3SEN92x2Y9OXcaCA0kcEILtn
0C/fb2s+jlWW/Yi5lhIYqE1dNEMINXZ9RqSLWE4vYab6LNz8j3uOh/6ZmptFDCpO
AkgvacZczRTRI4YDXpc/lyrIglFJVTOD9m3EhY5riaWx5Ri0WFpFDzVBJpTjJCX2
rvU3bgel9QgHoTriUYHkLRDo94apqagxB4t0Pc3Padi1dOSFJUUKWMfh1ixjk/iZ
9QT7WTnIcUrRVM0Qwy1HWSoGWskMudxqWaqB/wdIUu8QIbtmUB9eNEsWX24Whxc2
T1XYsOVcTD1znBo6+8dB
=7dk8
-----END PGP SIGNATURE-----

--X78YbkCBd9ye7Cvs--
