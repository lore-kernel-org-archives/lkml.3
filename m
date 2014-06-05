Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbaFEOVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:21:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:52638 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbaFEOVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:21:39 -0400
Date: Thu, 5 Jun 2014 16:21:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Subject: Re: [PATCH 5/9] perf/x86: implement cross-HT corruption bug
 workaround
Message-ID: <20140605142135.GM6758@twins.programming.kicks-ass.net>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
 <1401917658-26065-6-git-send-email-eranian@google.com>
 <20140605140400.GM3213@twins.programming.kicks-ass.net>
 <CABPqkBQRDpbkF73sWKXiXJOO0Jbeb9tRTWqScbjNdTG50EN3ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x38akuY2VS0PywU3"
Content-Disposition: inline
In-Reply-To: <CABPqkBQRDpbkF73sWKXiXJOO0Jbeb9tRTWqScbjNdTG50EN3ug@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x38akuY2VS0PywU3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 05, 2014 at 04:15:17PM +0200, Stephane Eranian wrote:
> On Thu, Jun 5, 2014 at 4:04 PM, Peter Zijlstra <peterz@infradead.org> wro=
te:
> > On Wed, Jun 04, 2014 at 11:34:14PM +0200, Stephane Eranian wrote:
> >> +
> >> +     /*
> >> +      * Modify static constraint with current dynamic
> >> +      * state of thread
> >> +      *
> >> +      * EXCLUSIVE: sibling counter measuring exclusive event
> >> +      * SHARED   : sibling counter measuring non-exclusive event
> >> +      * UNUSED   : sibling counter unused
> >> +      */
> >> +     for_each_set_bit(i, cx->idxmsk, X86_PMC_IDX_MAX) {
> >> +             /*
> >> +              * exclusive event in sibling counter
> >> +              * our corresponding counter cannot be used
> >> +              * regardless of our event
> >> +              */
> >> +             if (xl->state[i] =3D=3D INTEL_EXCL_EXCLUSIVE)
> >> +                     __clear_bit(i, cx->idxmsk);
> >> +             /*
> >> +              * if measuring an exclusive event, sibling
> >> +              * measuring non-exclusive, then counter cannot
> >> +              * be used
> >> +              */
> >> +             if (is_excl && xl->state[i] =3D=3D INTEL_EXCL_SHARED)
> >> +                     __clear_bit(i, cx->idxmsk);
> >> +     }
> >> +
> >> +     /*
> >> +      * recompute actual bit weight for scheduling algorithm
> >> +      */
> >> +     cx->weight =3D hweight64(cx->idxmsk64);
> >
> > So I think we talked about this a bit; what happens if CPU0 (taking your
> > 4 core HSW-client) is first to program its counters and takes all 4 in
> > exclusive mode?
> >
> > Then there's none left for CPU4.
> >
> > Did I miss where we avoid that problem, or is that an actual issue?
>=20
> Yes, this patch series does not address this problem yet. It will be
> in a second series.
> Don't have a good solution yet.

We could limit each cpu to num_counters/2 exclusive slots. That'll still
be painful with some constrained events I imagine, but in general that
should 'work' I suppose.

--x38akuY2VS0PywU3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkHzvAAoJEHZH4aRLwOS6MzUP+wcSuV8Y6wDmU9tmebEaSMYr
WwMUNyX05s+VXen6dlYP/4PdpEYvCwQ7X6Di1BkspQQyCEp1N4tWIJgWUo6ypHft
MIyPPygT5754DSccAAALB+8prAyX/R+eyC5jrBpgT1zQUdfpZ2ArM+ZNRk6yegzT
f4/5QBx477zFLS1YwD/mFxR0ffiNItZV+JoID0n3yx5oN7qIcbKG4a6X0WcvHrLZ
J7F7uHSbxSEF4Tvs/5BQi/2RUOh30p5dJPNhjKESOlF/CmtYUPEDfVXQZMNl461a
6IZmgypewB2Y3Z+T0OfYpga3FlPikpa47EsTG0P6kt53h370jGUljN7eig+br6eN
BFsfXPlI8mCcEjrOpG6z6or3fxcbDxBmQthOyV90FlYDZsh1LJwVUmP1V8wN2ENQ
jNmC0ORYYoFGfSdLWVc96SglMyUXZY9iPii7NvRFERCblf5JbsoSCO9iD9ATzfBl
cKc5an/hnkRP7IXIhI1rO8WbDg+/9B/t/fOZZGdtkKhIcGauNtcbovQpdW9Z3ou9
Os04ihX6i5D2UHJS+m4OOJid6gxW+i8pQfO1OPYYBv2jPA50XPM6ZyN+xiXiODQG
qjyY49ijf236MFp2ma7idfZ4NTUS6dG2hFNRuiZV0uOSEatc7qKtuM0bfLMqZlQw
KswQOnTwg9FvW7MtwhLy
=3S4w
-----END PGP SIGNATURE-----

--x38akuY2VS0PywU3--
