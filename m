Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591AbaFEMud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 08:50:33 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33204 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbaFEMuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 08:50:32 -0400
Date: Thu, 5 Jun 2014 14:50:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Subject: Re: [PATCH 9/9] perf/x86: add syfs entry to disable HT bug workaround
Message-ID: <20140605125022.GF6758@twins.programming.kicks-ass.net>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
 <1401917658-26065-10-git-send-email-eranian@google.com>
 <CADknwL5S8QpzCAgrKHjbGTbEx7nA8L=Vu8d-UWAYCg6X25OcGw@mail.gmail.com>
 <CABPqkBSimH8Ob_q3dDtQiW_OwuS9nA4Gsx87H26ywNcmYd38Xw@mail.gmail.com>
 <CADknwL6s2ttb5E2JDr6bc_XkwpxnW5ecU-3Ns88=gvgPvLYkPg@mail.gmail.com>
 <CABPqkBQUUb+yEvC8y3oLc0DUbF3DJPzbt3sNL7Zqzufh6EYdRw@mail.gmail.com>
 <CADknwL71NC5wBG1tnqgJ6iiA4y+HYomGpufOn7V+MP2=m7+Mig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/aVve/J9H4Wl5yVO"
Content-Disposition: inline
In-Reply-To: <CADknwL71NC5wBG1tnqgJ6iiA4y+HYomGpufOn7V+MP2=m7+Mig@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/aVve/J9H4Wl5yVO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 05, 2014 at 12:16:01PM +0100, Matt Fleming wrote:
> On 5 June 2014 11:19, Stephane Eranian <eranian@google.com> wrote:
> > How would you know that you have a uniform workload from inside
> > the kernel?
>=20
> That's what I'm asking you ;-)
>=20
> >> Does cpu_sibling_map not give you some indication of whether HT is
> >> enabled? I think the topology_thread_cpumask() is the topology API for
> >> that. But I could most definitely be wrong. Hopefully someone on the
> >> Cc list will know.
> >>
> > Remember trying some of that, but when perf_event is initialized, those
> > masks are not yet setup properly.
>=20
> Oh, bummer.

So we init perf very early to get nmi-watchdog up and running, but
there's no reason you cannot register a second initcall later and flip
the switch from it there.

--/aVve/J9H4Wl5yVO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkGeOAAoJEHZH4aRLwOS6yKYQAKb+V3GUxzShWKn2E0CcGxcX
CnxoyBjRNIkLCxsI0BbtH7IKdKmhu88WOS2T1EapJ8f4wkOjBXvVXTQDR6GiVosa
trzmuZLk0OWCfUawsWp9PhrvwnhJGYmDH+pz3QJkCqcoBhWScDu025+1lOQjm9Ur
VbFd6RS9uhU7w6FXFOjZhm0S56hDgVVYvsjog84THlHHYG3AHS5etMbvP/BGKHoy
Ho0ACsy4C5CMKr6FLAFzXEILalCohslndjq3KXEiI2kSg9Ih62dWm8VI4VSOdazw
qfO+yufH8DC7RJ1hBtAJLB4/4XOqB1G8pbbpSyQtxpLdTGzu3zOPVuyBNAHzcHC0
zDrDIxJsKq2NVFS5Sm2B/BHh6qTCfc2Owv9D7sq8+CLgpUq4/k/nwODFV9riWGvP
W4vgrw1AthLV8Hug/bfFsyvr13wsVtB0JDEZOL6iHoUW2JGTLFfP9riSFNRDvRix
edf+GcdYIgrkJlG0XZlKF8u9SB4oH/H1bLA3F+S1ptpqTiI5hezPAizIqog4vNxI
50qpO3GWn4ulcnwL1enTEB+r7jWtzg6ICZI2zmuX1S/ZR43c1RKkUlGXJIX6mPU8
DEVgoyt+VDfoVddC/8BvGW9pC1QbM1F2ubj1erjxvPAGLA+JhSGLTzKlciEBAUwx
nuLk8Q2sBGkB4SacHbXu
=uJVi
-----END PGP SIGNATURE-----

--/aVve/J9H4Wl5yVO--
