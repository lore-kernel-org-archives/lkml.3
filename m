Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaFJM04 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 08:26:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:49209 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaFJM0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 08:26:55 -0400
Date: Tue, 10 Jun 2014 14:26:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Subject: Re: [PATCH 4/9] perf/x86: add cross-HT counter exclusion
 infrastructure
Message-ID: <20140610122649.GH6758@twins.programming.kicks-ass.net>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
 <1401917658-26065-5-git-send-email-eranian@google.com>
 <20140605082935.GI3213@twins.programming.kicks-ass.net>
 <CABPqkBQG=SMvtdvpBMnZx4Etf5rRoy3=K81RLNRcPEgBh7Yqdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nCRcqX7cEx7rr7Pe"
Content-Disposition: inline
In-Reply-To: <CABPqkBQG=SMvtdvpBMnZx4Etf5rRoy3=K81RLNRcPEgBh7Yqdg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nCRcqX7cEx7rr7Pe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 10, 2014 at 01:53:45PM +0200, Stephane Eranian wrote:
> On Thu, Jun 5, 2014 at 10:29 AM, Peter Zijlstra <peterz@infradead.org> wr=
ote:
> > On Wed, Jun 04, 2014 at 11:34:13PM +0200, Stephane Eranian wrote:
> >> @@ -2020,12 +2050,29 @@ static void intel_pmu_cpu_starting(int cpu)
> >>
> >>       if (x86_pmu.lbr_sel_map)
> >>               cpuc->lbr_sel =3D &cpuc->shared_regs->regs[EXTRA_REG_LBR=
];
> >> +
> >> +     if (x86_pmu.flags & PMU_FL_EXCL_CNTRS) {
> >> +             for_each_cpu(i, topology_thread_cpumask(cpu)) {
> >> +                     struct intel_excl_cntrs *c;
> >> +
> >> +                     c =3D per_cpu(cpu_hw_events, i).excl_cntrs;
> >> +                     if (c && c->core_id =3D=3D core_id) {
> >> +                             cpuc->kfree_on_online[1] =3D cpuc->excl_=
cntrs;
> >> +                             cpuc->excl_cntrs =3D c;
> >> +                             cpuc->excl_thread_id =3D 1;
> >> +                             break;
> >> +                     }
> >> +             }
> >> +             cpuc->excl_cntrs->core_id =3D core_id;
> >> +             cpuc->excl_cntrs->refcnt++;
> >> +     }
> >>  }
> >
> > This hard assumes theres only ever 2 threads, which is true and I
> > suppose more in arch/x86 will come apart the moment Intel makes a chip
> > with more, still, do we have topology_thread_id() or so to cure this?
>=20
> I assume your comment is relative to kfree_on_online[].
> This code is specific to the HT bug, so yes, it assumes 2 threads and that
> only one entry of the two excl_cntrs structs needs to be freed.
> Doing otherwise, would require a list and will never be used to its full
> potential.

That and ->excl_thread_id =3D 1, I was thinking that if we'd somehow have
4 threads, some of them need to have =3D [23] in there.



--nCRcqX7cEx7rr7Pe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTlvmJAAoJEHZH4aRLwOS6+hsP/RMQ/GKOz9mjs+X665aeSr+6
TwTWcaTpXB/G1S0rYKHzpTk80mDZbbwL3Fmbhb4kUIVYlgWmzjeqfbHc2JYOIJGy
nEfpRSCGov2IrfnJ+OWk7gBGsh9MSjK4EyURGlos8gZKIYbF+eZdGCtjnq+NeJrp
PgtWvVTfKDv2T+Nwba59hvcnoDsGsakDgdlxCi0BXFfhCDZf1dm7Jo22w/CKwwRX
6f3Z8emyg9cRRnOMjS++7T5XNpfwI6jvnsm3ueMEdA/qcyrflwWBhggVkMEYqmgg
EZsxAZfaxSZae+HYqbEtQ6WZOTSF/Chad4zgh4dPopraaNO0w73gCY2LkHUAZmiH
IeBQbPokXRPUviHwqpvEKZconYP6t53v+ArN+PPB4VPxqkpgVsU/TCLfla9Eitu7
wcG4Prp3ylIFUhrVItcMxxCIViTt7CBAhO5rojq9WR2hAb2qujqknieMfAl9SJv+
lZ6sQuCVqDVczAzzqm/GUXC7mELmTu3yv62N7fszlse66NU6zzz1Dmm0I5bmflvW
3oHlb+3VQ9o/WGm/JlEXWjq+8SgXAGIR9Ro2buLyg2oGHm5YQFr743+/Q5mb0qFd
vMVKXQS3qrWrpzIG3SnWmjFXYGjN3pjZT8EuWRQyV9r9BAaO+78G8XQR+55wSE/O
bvESCi61nOqdHUoHM96C
=mm8W
-----END PGP SIGNATURE-----

--nCRcqX7cEx7rr7Pe--
