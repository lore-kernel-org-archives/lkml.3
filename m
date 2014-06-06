Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbaFFLfO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 07:35:14 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43785 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaFFLfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 07:35:12 -0400
Date: Fri, 6 Jun 2014 13:34:54 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <mgalbraith@suse.de>
Cc: zhdxzx@sina.com, linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, dhillf <dhillf@gmail.com>,
        "hillf.zj" <hillf.zj@alibaba-inc.com>
Subject: Re: sched: how to pick runqueue when checking task hot?
Message-ID: <20140606113454.GR3213@twins.programming.kicks-ass.net>
References: <20140606065956.854A6718001@webmail.sinamail.sina.com.cn>
 <20140606101508.GP3213@twins.programming.kicks-ass.net>
 <1402053383.5859.8.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xSu31lw3TgkWXnjh"
Content-Disposition: inline
In-Reply-To: <1402053383.5859.8.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xSu31lw3TgkWXnjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 06, 2014 at 01:16:23PM +0200, Mike Galbraith wrote:
> On Fri, 2014-06-06 at 12:15 +0200, Peter Zijlstra wrote:
>=20
> > > --- a/kernel/sched/fair.c	Fri Jun  6 12:37:37 2014
> > > +++ b/kernel/sched/fair.c	Fri Jun  6 14:32:34 2014
> > > @@ -5051,7 +5051,7 @@ task_hot(struct task_struct *p, u64 now)
> > >  	/*
> > >  	 * Buddy candidates are cache hot:
> > >  	 */
> > > -	if (sched_feat(CACHE_HOT_BUDDY) && this_rq()->nr_running &&
> > > +	if (sched_feat(CACHE_HOT_BUDDY) && task_rq(p)->nr_running &&
> > >  			(&p->se =3D=3D cfs_rq_of(&p->se)->next ||
> > >  			 &p->se =3D=3D cfs_rq_of(&p->se)->last))
> > >  		return 1;
> >=20
> > That does appear to make more sense indeed, seeing how buddies are pairs
> > of tasks, so protecting a lone task doesn't make sense.
> >=20
> >=20
> > Mike, how did you intend this code to work?
>=20
> IIRC, this_rq()->nr_running was to say if we're idle, we don't care that
> it's last/next, pull it.  Not sure I'm the one who did that, but could
> be, I didn't look.
>=20

commit f685ceacab07d3f6c236f04803e2f2f0dbcc5afb
Author: Mike Galbraith <efault@gmx.de>
Date:   Fri Oct 23 23:09:22 2009 +0200

    sched: Strengthen buddies and mitigate buddy induced latencies

=2E..

-       if (sched_feat(CACHE_HOT_BUDDY) &&
+       if (sched_feat(CACHE_HOT_BUDDY) && this_rq()->nr_running &&
                        (&p->se =3D=3D cfs_rq_of(&p->se)->next ||
                         &p->se =3D=3D cfs_rq_of(&p->se)->last))

Yeah, was you ;-)

OK, so we want dst_rq. Thanks!


--xSu31lw3TgkWXnjh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkadeAAoJEHZH4aRLwOS6kwAP/0vDvbvbzO1uXDoWTiKaIfkS
WfIguI/iMhtw5J8g/wjX5eKMKd1LN4ieQihakBjsMVsMwJzHSlOxY4azf8pRXSsJ
LCrcgGPCJ/U5lt2S3+kwRCswnlxuwh889Uk2ULlzkozLfb4S9XwKrRFr6jPRj9i2
h1qkdF5sHSrtr/K9/3ZwCAZxSSt35HQjYyW27UjxTLFweNRUOcXtY/iQO420Kz1F
8AbFkDY7FXVkI/Z0u2pzIZwEQLu+Gpje0OdhFs8er4racNGY+B2HUDQHiaxIBOBo
1PcmUFHPsCIwVKKPJ+tWvrukAEv5IcZeE44GQlAQGXs5e49wnpivpxtWQ8ipJiIm
dSN1AR04n/d/oGKhRx3iCKus/du2OvZ9RIBhJKRDzo/3SzMX6/NpBhiQwb+MKa7D
6CwR8d1RqEfvwR9XmvWFZnvkepBH99arz3RFtepv8KKoGKWBdbESLcjDPgBpEbuA
SMRUt8/bdXbpI1gRkxaFoazMLtSV41J9bFQwMeLg6QO8ATBXTQAvYFeJTci1olbg
ryUhIPvZI4iiiK/R9j9AQoLf2jbyqyls8dECJOvMeNu3e5SmRj3Sh6L15jgK+qj7
CtfigrOmHxVsZHudruCva92yUdflqLrDB29PxwvpwS3+E2DsJ4HiD6hpMf3bJdBx
Ox3iH/bC6QRX1d2BppD3
=KpKH
-----END PGP SIGNATURE-----

--xSu31lw3TgkWXnjh--
