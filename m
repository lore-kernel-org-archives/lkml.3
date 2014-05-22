Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbaEVG71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 02:59:27 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52910 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbaEVG70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 02:59:26 -0400
Date: Thu, 22 May 2014 08:59:15 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Dave Jones <davej@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: spinlock recursion in migrate_swap_stop
Message-ID: <20140522065915.GJ30445@twins.programming.kicks-ass.net>
References: <5371122D.6020605@oracle.com>
 <537AB86B.4020901@oracle.com>
 <20140520110431.GX2485@laptop.programming.kicks-ass.net>
 <537B52BD.1080807@oracle.com>
 <537CA54A.8030408@oracle.com>
 <20140521131948.GF2485@laptop.programming.kicks-ass.net>
 <20140521164959.GI5226@laptop.programming.kicks-ass.net>
 <537D6244.6040106@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ukxq3d9/SFe4Ri4s"
Content-Disposition: inline
In-Reply-To: <537D6244.6040106@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ukxq3d9/SFe4Ri4s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 21, 2014 at 10:34:44PM -0400, Sasha Levin wrote:
> On 05/21/2014 12:49 PM, Peter Zijlstra wrote:
> > On Wed, May 21, 2014 at 03:19:48PM +0200, Peter Zijlstra wrote:
> >> > On Wed, May 21, 2014 at 09:08:26AM -0400, Sasha Levin wrote:
> >>> > > +++ b/kernel/sched/core.c
> >>> > > @@ -1154,6 +1156,7 @@ int migrate_swap(struct task_struct *cur, s=
truct task_struct *p)
> >>> > >                 goto out;
> >>> > >=20
> >>> > >         trace_sched_swap_numa(cur, arg.src_cpu, p, arg.dst_cpu);
> >>> > > +       BUG_ON(cur =3D=3D p);
> >>> > >         ret =3D stop_two_cpus(arg.dst_cpu, arg.src_cpu, migrate_s=
wap_stop, &arg);
> >>> > >=20
> >>> > >  out:
> >>> > >=20
> >>> > >=20
> >>> > > Which seems to get hit. This sounds like a race with task moving =
to
> >>> > > other cpu maybe?
> >> >=20
> >> > Oi, good call that, lemme go stare.
> > I think something simple like this should be sufficient to avoid the
> > problem of selecting oneself as a flip target.
>=20
> Why would that happen in the first place?

We do all that with preemption enabled, because its big and expensive,
so its entirely possible that current (env->p) got moved around while we
were doing it, at which point we'll look at it as a possible dst, while
its already our src.



--ukxq3d9/SFe4Ri4s
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTfaBDAAoJEHZH4aRLwOS6cIgP/1sCWt0wxLdNzJ6EdB1msBLq
irR5BEzFMbAJpIX7zMMYrombkJvq1+8Tp2A3CiIJrn0yZ+lHaGZaolKxW4wNyASF
O312bhtY7NF7x2xB4H6wJjeTsTsonJpjRPDIU5L0NrFZ3RJl+uZlb2owjGjM61fG
vPtFgwGoxHHE6bS7b96kVnGejMmdXgQXtDcjz2RfLrfNi+wuLOdXkJu840z9GFhI
DQ4MW6tmKWPRHrCAawogRMskiACXJItvWSkoGqh0f0Z5mKxbPixresUw29TPYdZc
bli9r1sSy7XImxk3DJ7t4O2ql1zilDqCd+3sXvK4KbCTx8i7RBUlkNiptbemDrBT
XoPas3LrsKJLeHMss9U2R105KzrvmqE36kZKBpq0AXhgSSP18S6E5dDvyapTprEM
EIqBBltf/8IrgYUYJsiHmCOWonTx8csthjy+fGUXeDeufJ3SQaa9X70q2ahYTNnn
bvks92ZznKC6kx8Ju947RbHHhWDQym1DICQYawodwGGyJuad6RJOIzoYqQEM6z22
dfPbNuQGZLtwa6BZ2WACBZSzFvVMFsz2OxgwWdAekC73b3opRFLMOQIM0UpHHpCs
2Cmyc5niE0wv9mpoQxbl6/sMv8jrtFig/vy0ReSq81pYN8utnhwHWSwW6Sg3D8KE
BKagYx9arajpv5ReEU3v
=L8YP
-----END PGP SIGNATURE-----

--ukxq3d9/SFe4Ri4s--
