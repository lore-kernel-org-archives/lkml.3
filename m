Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbaIIJIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 05:08:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:43624 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055AbaIIJIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:08:37 -0400
Date: Tue, 9 Sep 2014 11:08:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com
Subject: Re: [PATCH v4 11/22] perf: add ITRACE_START record to indicate that
 tracing has started
Message-ID: <20140909090830.GZ19379@twins.programming.kicks-ass.net>
References: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1408538179-792-12-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="co37zgScbM0c70lw"
Content-Disposition: inline
In-Reply-To: <1408538179-792-12-git-send-email-alexander.shishkin@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--co37zgScbM0c70lw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2014 at 03:36:08PM +0300, Alexander Shishkin wrote:
> For counters such as instruction tracing, it is useful for the decoder
> to know which tasks are running when the event is first scheduled in,
> before the first sched_switch.
>=20
> To single out such instruction tracing pmus, this patch alse introduces
> ITRACE PMU capability.

You forgot to tell why. Also explain why.

The next context switch event will also tell you the previous task. So
this seems like superfluous information. Also if you really want this
you could simply emit an empty AUX record I suppose, no need to create
yet another record type.

--co37zgScbM0c70lw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUDsOOAAoJEHZH4aRLwOS65lwP/1b46N2ymvLD79ay5zS9fPF3
ZF/ORYzanKNfg/RgkN9F8salX0rjEzhZC6CsUaFIFsgLK+j+lxG9nfMLLTQ2LQBi
vaXth3pj5/s7zVDRlOtjdaYQElTzwCItrbopOE1kTXIFzllaDLxKmYANQOvNCjU9
XQhgiO3Cln3lHmwBO5gJCN7suDkxPMAdRaoQs6XhggT71pw4tB9qsduScrRLGcgk
/cX6Fd8M37MVHsWc6cNUhzdCV23G8kMhs/AAnaDRzvRipXeDK1MQ/rkwgFsRqp8s
S1OniBha5jSD0hBW46AnzvRUWkls3rB5k5djk5gMUUz7wChdlPv+cxWKLIrWD2Nw
wHwqen9sRL+WvFHvve03nchi1nicKG8Q6wfBSMPAHbdSWJZFoncGl/dPj+NKCjfo
w5St6Be8qxM4Q0AMCLaGLTdAAGWFZXQNobUvR1ht+CE/ODMqgYAFRl56Y8L9e5jz
we71AXGybiLRHTKual0YMs+SyJBnSIUTByZd4GcEoYCfZvvrF+G+/7aRdbutOKX6
qRj9i+9WUOk2vu+7CvAoEpEKuDSeBONkOSShkVYshPjJIlWTXg4+NM6K3v0GE2tf
PUly0sCwgY54IHwmO3rLc0f7l13Z22wMDGv7NhuotO/g5zOeu4XjVahFaLFcl32s
8Q9CLHVCQ1HCtjaZZOjW
=inxV
-----END PGP SIGNATURE-----

--co37zgScbM0c70lw--
