Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbaEVHAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 03:00:39 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52948 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbaEVHAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 03:00:38 -0400
Date: Thu, 22 May 2014 09:00:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: spinlock recursion in migrate_swap_stop
Message-ID: <20140522070029.GK30445@twins.programming.kicks-ass.net>
References: <5371122D.6020605@oracle.com>
 <537AB86B.4020901@oracle.com>
 <20140520110431.GX2485@laptop.programming.kicks-ass.net>
 <537B52BD.1080807@oracle.com>
 <537CA54A.8030408@oracle.com>
 <20140522053540.GA26857@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iQbDWBcONlRwAlo5"
Content-Disposition: inline
In-Reply-To: <20140522053540.GA26857@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iQbDWBcONlRwAlo5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 22, 2014 at 11:05:40AM +0530, Srikar Dronamraju wrote:
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index 927fa33..b5e11c7 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -1154,6 +1156,7 @@ int migrate_swap(struct task_struct *cur, struct =
task_struct *p)
> >                 goto out;
> >
> >         trace_sched_swap_numa(cur, arg.src_cpu, p, arg.dst_cpu);
> > +       BUG_ON(cur =3D=3D p);
>=20
> I am not sure how this check can ever be successful because at the start
> of this function migrate_swap() we have
>=20
>   if (arg.src_cpu =3D=3D arg.dst_cpu)
> 	  goto out;
>=20
>=20
> if cur is actually p; then should the above condition should always be
> successul right?
>=20
> Or am I missing something?

Yeah, current might have migrated while we were looking for a target.

--iQbDWBcONlRwAlo5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTfaCNAAoJEHZH4aRLwOS6Oj4QAJvsp+1wn021MmGdoEC2Se0C
LmLpwLF5VuRh4JjX/h8q+aYfPW13NxK7p3rTIhr8HDJfGuMSNS5C7iSe2JF/H3+i
+lbeZYuI5b1X4ByioUuvUz0i5NywrZB0BSGLn0doZJPN+hjxvI3/gyz+ehUfz1q1
bPgkDIasBoYiX/osAjQwtTxvMpS1H+QNExKPy6EsQO1xowej6gxwgcgbjQK749x1
8W5nH6jSlkgPZ7dSu/iAqK6oMFTWaow5eJENCY9eQWDSoyu//DS12Uk8JxMWnJ8E
4I8CjShOP4stmg/SGCJugjpGMSIGBJHJs6y94hgiLVPRrWxmHa5YV5fqHfEI9Uo4
uwVH6E8eAEKCOE/A4mN7leS8Bmg2qIoxgBPl4k9PapFNIn81tjdwIRcwnNdv/YxH
a8aZnAiDu3XvMDPDkzDHxM6ozgB2fjOmzUYK+wM5MasnsWFCmp+qB1JsjBfW05MG
QqbfaEmWd4e6Yi57vBAONlDAvFFgb3qmHsrtuUo24CvvgQPjVUyN63cKYKNE6aEr
9iEb8TEl34ASMWU//vwWFDC5v9o/dbOtr3YgxbhGCAV7x9XSQypIhBIBqnI50QsX
y212LR0CaQpmLu9A89KcR6aWyUb6R31yJXjcMlqB6rvWd3w1+F/De231wkHoBdlu
feZJXfXJezN1WcCyi013
=LTDn
-----END PGP SIGNATURE-----

--iQbDWBcONlRwAlo5--
