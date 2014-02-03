Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbaBCNdM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 08:33:12 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:36719 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaBCNdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 08:33:10 -0500
Date: Mon, 3 Feb 2014 14:31:02 +0100
From: Henrik Austad <henrik@austad.us>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched/core: fix sched_rt_global_validate
Message-ID: <20140203133102.GA13556@austad.us>
References: <1391186607-11247-1-git-send-email-juri.lelli@gmail.com>
 <20140203095302.GA13242@austad.us>
 <52EF6BED.7050001@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <52EF6BED.7050001@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 03, 2014 at 11:14:05AM +0100, Juri Lelli wrote:
> On 02/03/2014 10:53 AM, Henrik Austad wrote:
> > On Fri, Jan 31, 2014 at 05:43:27PM +0100, Juri Lelli wrote:
> >> Don't compare sysctl_sched_rt_runtime against sysctl_sched_rt_period if
> >> the former is equal to RUNTIME_INF, otherwise disabling -rt bandwidth
> >> management always fails.
> >>
> >> Cc: Ingo Molnar <mingo@redhat.com>
> >> Cc: Peter Zijlstra <peterz@infradead.org>
> >> Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
> >> ---
> >>  kernel/sched/core.c |    3 ++-
> >>  1 file changed, 2 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> >> index 210a12a..5c0a304 100644
> >> --- a/kernel/sched/core.c
> >> +++ b/kernel/sched/core.c
> >> @@ -7477,7 +7477,8 @@ static int sched_rt_global_validate(void)
> >>  	if (sysctl_sched_rt_period <=3D 0)
> >>  		return -EINVAL;
> >> =20
> >> -	if (sysctl_sched_rt_runtime > sysctl_sched_rt_period)
> >> +	if ((sysctl_sched_rt_runtime !=3D RUNTIME_INF) &&
> >> +		(sysctl_sched_rt_runtime > sysctl_sched_rt_period))
> >>  		return -EINVAL;
> >=20
> > Won't this be caught by the test above?
> >=20
> > #define RUNTIME_INF ((u64)~0ULL)
> >=20
> > which means that if sysctl_sched_rt_runtime is set to RUNTIME_INF, it w=
ill=20
> > trigger on the previous test, and the first part of this test will alwa=
ys=20
> > be true.
> >=20
> > Or have I suffered catastrophic monday-morning braindamage?
> >=20
>=20
> As I understand it. When you do
>=20
>  echo -1 > /proc/sys/kernel/sched_rt_runtime_us
>=20
> sysctl_sched_rt_runtime is actually set to -1 (being an int).

Yes.

> But then you compare it against and unsigned int, so the cast converts it=
 to
> actually be RUNTIME_INF, and thus greater than sysctl_sched_rt_period (so=
 the
> function returns -EINVAL, while you'd want it to return 0, as you are dis=
abling
> -rt throttling).

Ah, yes, it comes down to my early-monday brain hemorrhage, mixing up=20
rt_period and rt_runtime. My apologies!

> Makes sense?

Yes it does.

--=20
Henrik Austad

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlLvmhYACgkQ6k5VT6v45lnXgACfcOD8NhFYSlMu4/ExsOJZU+Qr
4tQAn3xoaSQa6SzZgdiQslwqx9IJtZK1
=BDIP
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
