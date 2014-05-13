Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933972AbaEMKct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:32:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:40597 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932693AbaEMKcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:32:48 -0400
Date: Tue, 13 May 2014 12:32:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: Do not zero sg->cpumask and sg->sgp->power in
 build_sched_groups
Message-ID: <20140513103244.GY30445@twins.programming.kicks-ass.net>
References: <1398865178-12577-1-git-send-email-dietmar.eggemann@arm.com>
 <5371D8B5.3070701@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="P7peSLPSdcfcL2or"
Content-Disposition: inline
In-Reply-To: <5371D8B5.3070701@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--P7peSLPSdcfcL2or
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 13, 2014 at 09:32:53AM +0100, Dietmar Eggemann wrote:
> Hi Peter,
>=20
> On 30/04/14 14:39, Dietmar Eggemann wrote:
> > From: Dietmar Eggemann <Dietmar.Eggemann@arm.com>
> >=20
> > There is no need to zero struct sched_group member cpumask and struct
> > sched_group_power member power since both structures are already alloca=
ted
> > as zeroed memory in __sdt_alloc().
> >=20
> > This patch has been tested with
> > BUG_ON(!cpumask_empty(sched_group_cpus(sg))); and BUG_ON(sg->sgp->power=
);
> > in build_sched_groups() on ARM TC2 and INTEL i5 M520 platform including
> > CPU hotplug scenarios.
> >=20
> > Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
> > ---
> >  kernel/sched/core.c |    2 --
> >  1 file changed, 2 deletions(-)
> >=20
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index 9cae286824bb..6bc51aebbf1b 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -5807,8 +5807,6 @@ build_sched_groups(struct sched_domain *sd, int c=
pu)
> >  			continue;
> > =20
> >  		group =3D get_group(i, sdd, &sg);
> > -		cpumask_clear(sched_group_cpus(sg));
> > -		sg->sgp->power =3D 0;
> >  		cpumask_setall(sched_group_mask(sg));
> > =20
> >  		for_each_cpu(j, span) {
> >=20
>=20
> I think this one slipped through the cracks. Could you have a look?

Yeah, got stuck in the backlog :/

Seems simple enough, queued it, we'll see if anything explodes ;-)

--P7peSLPSdcfcL2or
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTcfTMAAoJEHZH4aRLwOS6iDYP/2+/Gsb5aq/98aIlW+UdEeoX
9flnBY+PElSnxens7xkCa5Nj38Vu+SqnYUyoQ1Ja/GtOaHYFwjw7Z/CJIvIRjjh8
THXU9KQXz4MMcoE1U9DKXNZTyH02947qvUnFxqvFS31MwjQqkTRVndTcFIAGa9W7
d0+JTIBufmzY3jZYwQMkSi8HRmt2m2EUJy4/ktQBAbT54JxfjuikeT+DMXdmOvOP
O7kYLusH8/MNWS8PecD6GUMtBeaQhLsvz1/sBZ2svn/RGX5LfNK0THKNxXjIqFxV
z6TMQ8UzUK9mKvg+FzOiJ8Bl3upXMVKK5wJgfkgAejgyij1LGMzx2rHcY4prtE74
XYJ7EhrTpYxvICAuFnJM6nX+THAmZhyyTfenT48UqdjLlD0Cb59lze9RY9cWKTcx
AK0HvFzTT0bQXKHKbJrMNSVAAlS2vXWXR8065IA91W1f+U03BlXQriFnaLcCGLd2
rvj0zsRPYjB8lUKFAdeNAVwxS6XP5DOls6XQUpwEfnH+qmRviEsNeKTJFy9qSFXW
TBY1XT68xlQoWWsm/hvvhPk/kVEhkbKQvclfEi6Ahc7YKW6/llRtKrmuBBvscW2d
uQSiegTXFuvvdh3pNaj6IQB+Bs8gOM1pH3F7bJBVp0tkVA8Br0s1lLh8C7Na3OBx
UGaGZ0rwlvm8HfqSjKQA
=nljD
-----END PGP SIGNATURE-----

--P7peSLPSdcfcL2or--
