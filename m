Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbaFDM3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 08:29:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:46469 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaFDM3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 08:29:17 -0400
Date: Wed, 4 Jun 2014 14:29:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: "riel@redhat.com" <riel@redhat.com>,
        "laijs@cn.fujitsu.com" <laijs@cn.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>
Subject: Re: [PATCH] sched: Fix migration_cpu_stop() return value
Message-ID: <20140604122909.GE13658@twins.programming.kicks-ass.net>
References: <20140604104122.GL30445@twins.programming.kicks-ass.net>
 <5962011401880725@web26h.yandex.ru>
 <20140604120338.GH13930@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bNvn4bxlrUVLu6cT"
Content-Disposition: inline
In-Reply-To: <20140604120338.GH13930@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bNvn4bxlrUVLu6cT
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 04, 2014 at 02:03:38PM +0200, Peter Zijlstra wrote:
> On Wed, Jun 04, 2014 at 03:18:45PM +0400, Kirill Tkhai wrote:
> > Hi, Peter,
> >=20
> > 04.06.2014, 14:41, "Peter Zijlstra" <peterz@infradead.org>:
> > > =A0A while ago I did a similar patch for some debugging, but looking =
at it
> > > =A0again today I realized we should probably fix this anyway.
> > >
> > > =A0---
> > > =A0Subject: sched: Fix migration_cpu_stop() return value
> > >
> > > =A0There are a number of migration_cpu_stop() users; and some actuall=
y care
> > > =A0about the success of the migration. So report this.
> > >
> > > =A0In particular migrate_task_to() as used from task_numa_migrate()
> > > =A0actually tests this return value.
> > >
> > > =A0Also change set_cpus_allowed_ptr() to propagate this return value,=
 since
> > > =A0it already returns other errors.
> > >
> > > =A0Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> > > =A0Cc: Ingo Molnar <mingo@redhat.com>
> > > =A0Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> > > =A0---
> > > =A0=A0kernel/sched/core.c | =A0=A015 +++++++++++----
> > > =A0=A01 file changed, 11 insertions(+), 4 deletions(-)
> > (snipped everything because of bad email editor)
> >=20
> > In set_cpus_allowed_ptr() p->on_rq branch can not fail.
> >=20
> > We've changed affinity and released rq's lock, so task can migrate
> > on allowed cpu only (even if migration_cpu_stop fails).
> >=20
> > And it's a little ambiguously how user should react on this EAGAIN.
>=20
> Try again? So one reason it might fail is because the task got migrated
> in between the stop_cpu_call(migration_cpu_stop) call getting to
> __migrate_task().
>=20
> Esp. if you look at migrate_task_to() its fairly easy to fail this.
> Currently it reports success, even though we completely failed to
> migrate.
>=20
> On -EAGAIN, re-evaluate the target and try again (later). Like for the
> numa case, we'll try again on the next task_numa_migrate() call if its
> still relevant.

Argh, I just realized that the one case the numa code is interested in
is actually reported as success (task_cpu() !=3D cpu).

I'll go make a new patch..

--bNvn4bxlrUVLu6cT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjxEVAAoJEHZH4aRLwOS6118P/3AHwKzN1Fap3eoxkRIxztSd
z4U0FTXhG6AKMoNsm+f6ZTxRfEorxlNl6MZxwcB0/dNdNxpkxVWO/YtfZjcksDvS
DJQLwVLgCPBfZkSkc4w93Q+q2J8fEyJaQwpb2P/c2DWy1IPKmxLhZaLiXetnNl6x
wpddrwLgRsfDTY12lX4qe2cs4711+j+lBe/C8pEA9KpP4s2g0USmdnBGOCrtbcN0
lfJSaHeHoDZ9sGb/TnxOtDeSBffxLAEZ9C4Zp3u9s/b5Cilf1u9L6vsxzNR6kDeX
BhE32odeUzl0OhFhDsp73YBUcSTjUYQN7DUqWMAOolb5RuXEf4LukagMO64ICaIZ
XiqXMf/LaLoPvfyEfZmoj3LcroevBAzjMagnxzjCYZRRwt+VYVKysNOB6anwFARl
xs4ZBkn34jTT1hs+83n22Wr1b51n2q8X+k5T/9o7KsE1MA+CcWAT+ac729JQE+v+
8VNK6/Ct5SUSU5wsHQ5Ox0/nMD5TX9V+m9AwqZowiFl4iz3NSWEMiFUTvuBAI/PT
DTKf4kO0hs5WN6iLdF6BnpdEPgJBw4NXl6n0al7A4i6Ng2qIpeMxzAfZ55tS8aPZ
el/5nP2wTRytOtsK7Pdx/dOe9miPdmWkcVUC3OqqycOFepd2mVz4PsJQHmxZmOZJ
9nj5Hh7E5Z32IQGUw+kW
=wXAe
-----END PGP SIGNATURE-----

--bNvn4bxlrUVLu6cT--
