Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578AbaGANIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 09:08:31 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54116 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841AbaGANIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 09:08:30 -0400
Date: Tue, 1 Jul 2014 15:08:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Zhihui Zhang <zzhsuny@gmail.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
        Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [PATCH] [sched] Don't account time after deadline twice
Message-ID: <20140701130816.GR6758@twins.programming.kicks-ass.net>
References: <1404091570-5041-1-git-send-email-zzhsuny@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JhY86nTAwD/oWhC3"
Content-Disposition: inline
In-Reply-To: <1404091570-5041-1-git-send-email-zzhsuny@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JhY86nTAwD/oWhC3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 29, 2014 at 09:26:10PM -0400, Zhihui Zhang wrote:
> Unless we want to double-penalize an overrun task, the time after the dea=
dline
> and before the current time is already accounted in the negative dl_se->r=
untime
> value. So we can leave it as is in the case of dmiss && rorun.

Juri?

> Signed-off-by: Zhihui Zhang <zzhsuny@gmail.com>
> ---
>  kernel/sched/deadline.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>=20
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index fc4f98b1..67df0d6 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -579,10 +579,8 @@ int dl_runtime_exceeded(struct rq *rq, struct sched_=
dl_entity *dl_se)
>  	 * the next instance. Thus, if we do not account that, we are
>  	 * stealing bandwidth from the system at each deadline miss!
>  	 */
> -	if (dmiss) {
> -		dl_se->runtime =3D rorun ? dl_se->runtime : 0;
> -		dl_se->runtime -=3D rq_clock(rq) - dl_se->deadline;
> -	}
> +	if (dmiss && !rorun)
> +		dl_se->runtime =3D dl_se->deadline - rq_clock(rq);
> =20
>  	return 1;
>  }
> --=20
> 1.8.1.2
>=20

--JhY86nTAwD/oWhC3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTsrLAAAoJEHZH4aRLwOS6swgP/Re0hVvgpAhHxp+RBrqvhqrv
cze6U0EM9pqrbzJ+mJ6vGOmhiwdYOVVZGwUX3YvIVjnQZCcvusByio1ZbvoPszaG
nQMG1lTYwm3cVta8hbf9POJNvs+twA6D4n+4rzQ6ClpS6qyXIbVqa9xPQD85W6cv
M/lEhgt5O9YXUbLgy912Jeq7iwBgmiG2ratQ21s9XDbtbTuCZvzjPIZUsyJmC6gE
tLW1HyRg2nBeg+SoyESFr4Po0FLyYPcqs/M8XxFqkGMfT9w61PgP9hsplrygJGe/
FpMCZ2htwgROmiZ6ZXjPccUrWMf8PAhemiC6BHuy5EdFlGDUeUcE63hQdAhUU8BT
Dd53wQScPnvPd8uafHT4IwAXDOXOpZnQ0A1Yc0OsyNgk/H4FE2A5u5aa5jncl7TS
rDKZEuSf2mHTAtReVSnXcZIdm0/d27Prc7r+0qqrU0jb7Ip1RoH8zYNYRmzNOS2+
7LLGajPaH2+YQTFe+OFBf4vWX85njMupBtgvISToctfZciCq2TqQP9dcfMv5EM2f
cl46UTZUboK/ZNLGo8Rxm+/WrJhQbe2WhPdK2neeenL0Zdh7q+qhmZx4OSWPnZsR
+rxrIXBz3ooDtTxg57RRMJZegHoxmVJ8NBSwJfHgu000iWmb1KtMIUHADxetSEc3
kqgj22kdC+h+jPYDd1JW
=MBPj
-----END PGP SIGNATURE-----

--JhY86nTAwD/oWhC3--
