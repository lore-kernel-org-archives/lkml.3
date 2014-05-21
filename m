Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611AbaEUH3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 03:29:53 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56670 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbaEUH3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 03:29:52 -0400
Date: Wed, 21 May 2014 09:29:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: Juri Lelli <juri.lelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] sched/dl: Fix race between dl_task_timer() and
 sched_setaffinity()
Message-ID: <20140521072945.GD30445@twins.programming.kicks-ass.net>
References: <20140516213003.10384.7946.stgit@localhost>
 <20140519151233.5043b749361e1b384f1e5562@gmail.com>
 <783871400527879@web2j.yandex.ru>
 <20140520000026.GD11096@twins.programming.kicks-ass.net>
 <1413311400562533@web30m.yandex.ru>
 <20140520075315.GQ2485@laptop.programming.kicks-ass.net>
 <20140520101730.ab593e41d5ee5949740de52e@gmail.com>
 <3056991400578422@web14g.yandex.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Mm7SuNQsQ9gs8/y1"
Content-Disposition: inline
In-Reply-To: <3056991400578422@web14g.yandex.ru>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Mm7SuNQsQ9gs8/y1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 20, 2014 at 01:33:42PM +0400, Kirill Tkhai wrote:
> [PATCH] sched/dl: Fix race in dl_task_timer()
>=20
> Throttled task is still on rq, and it may be moved to other cpu
> if user is playing with sched_setaffinity(). Therefore, unlocked
> task_rq() access makes the race.
>=20
> Juri Lelli reports he got this race when dl_bandwidth_enabled()
> was not set.
>=20
> Other thing, pointed by Peter Zijlstra:
>=20
>    "Now I suppose the problem can still actually happen when
>     you change the root domain and trigger a effective affinity
>     change that way".
>=20
> To fix that we do the same as made in __task_rq_lock(). We do not
> use __task_rq_lock() itself, because it has a useful lockdep check,
> which is not correct in case of dl_task_timer(). We do not need
> pi_lock locked here. This case is an exception (PeterZ):
>=20
>    "The only reason we don't strictly need ->pi_lock now is because
>     we're guaranteed to have p->state =3D=3D TASK_RUNNING here and are
>     thus free of ttwu races".
>=20
> Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
> CC: Juri Lelli <juri.lelli@gmail.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Ingo Molnar <mingo@redhat.com>
> Cc: <stable@vger.kernel.org> # v3.14
> ---

thanks Kirill!

--Mm7SuNQsQ9gs8/y1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTfFXoAAoJEHZH4aRLwOS6JD8P+gNjuZV25nYq6vMEWqI3rTuD
N+PzB/xH6RQ/id2WQi+ZGps9A6ZaKu84JgOmRe6ETjyme90bb8R5njUqRJ+oacZZ
+F3sJkhsHi6h5A4jnO7Y5pCFbc+wy9fhsr6z2MgW8Vgwd812vuUZXa3hHcfsjY2C
xlQOmrwDM77ZdNqeIqeG45PIfdb1xTophWUyWPXuy7ZgSVc1SsupMMJ1/2++TngD
MBEA/+j+IFJiacIMaxB5QrtzOVJlscW3SUmi74df/V9oTQnKUa1ntHhi6FaPLWG0
x1w7VwtWsq/immcFtN2aSwF4l7XVbmSBO2Z9PYTA0ckw9qX7vbNXxuO9tZ1BM+7Y
u9iie0LVVQVGjRXeuxHO+7sA5tO6bMAD5v0MS64Y0Sa8CDmsm7xXUlM82flin/o/
oWSDRJyo5EYsFB9WbCiX2PhCNoYxjj5TZEgG+SxnwXOfm+28cPrJGjqmGg4uinVk
/3+q1MYlYraXl2efFwBV7JOuGKIqdsf5LXHN1atp4VNbQYlDftFzh/H/u+VQEVCD
YaS/O/diP6IEDydmmb3cqhcQlnFTMc0+lOVT0Ehgg2apgYK3Zwqu3W+LxPETwev8
Ud3bgRJaJPHujemchjZzPlbjf8sP/1dLVhkRyxhcSHaDQ19VF1ka6jJoVvUg88lQ
X6nsH5s7PQUa507JpxY3
=7Y8/
-----END PGP SIGNATURE-----

--Mm7SuNQsQ9gs8/y1--
