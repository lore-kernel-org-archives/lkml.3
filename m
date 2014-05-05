Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290AbaEETgg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 15:36:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:56968 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbaEETge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 15:36:34 -0400
Date: Mon, 5 May 2014 21:36:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
Message-ID: <20140505193629.GB11096@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.02.1405022111540.6261@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1405021611540.23984@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.02.1405022243550.6261@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1405022227420.25174@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1405022253530.25174@vincent-weaver-1.umelst.maine.edu>
 <20140505093124.GN17778@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405051200010.31049@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1405051309160.31072@vincent-weaver-1.umelst.maine.edu>
 <20140505171428.GU26782@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405051443260.31072@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jIYo0VRlfdMI9fLa"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405051443260.31072@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jIYo0VRlfdMI9fLa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 05, 2014 at 02:47:32PM -0400, Vince Weaver wrote:
> On Mon, 5 May 2014, Peter Zijlstra wrote:
>=20
> > Cute.. does the below cure?
> >=20
> >=20
> > ---
> > Subject: perf: Fix perf_event_init_context()
> > From: Peter Zijlstra <peterz@infradead.org>
> > Date: Mon May  5 19:12:20 CEST 2014
> >=20
> > perf_pin_task_context() can return NULL but perf_event_init_context()
> > assumes it will not, correct this.
>=20
> It makes the oops go away, but it does make the fuzzer become unkillable=
=20
> while using 100% CPU.

Ooh, I know that one. Its what my WSM-EP favours. I'll try and have a
look.

> It looks like it is stuck repeating this forever:
> 	perf_fuzzer-5256  [000]   275.943049: kmalloc:              (T.1262+0xe)=
 call_site=3Dffffffff810d022f ptr=3D0xffff8800cb028400 bytes_req=3D216 byte=
s_alloc=3D256 gfp_flags=3DGFP_KERNEL|GFP_ZERO
> 	perf_fuzzer-5256  [000]   275.943057: function:             perf_lock_ta=
sk_context
> 	perf_fuzzer-5256  [000]   275.943057: function:             alloc_perf_c=
ontext
> and memory is slowly leaking away.

Oh, usually when my WSM gets funny like this and I enable the tracer it
just stops being a computer and starts being a brick.

Might be a nice clue though.

--jIYo0VRlfdMI9fLa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTZ+gwAAoJEHZH4aRLwOS6k0AP/i7izbXXiDP132lVJcPxaYUV
AkDzxF6tWPw2hvEDabjvF1PYe/J2iGSZre9rMJh8EHWyW1cSmP/vIYxJvxm7rLjQ
9L3Dc7z6raK5ZxPAZcngmGokXqV3FDRpPty98ZkV9aBapvcd5rM3JTtJwyJUPsDp
bbqqiVO0ROAju27APz+9L7hX6UvAorLFD5EXFuVUr5lrbGo+hiepkBTlTivN6xry
M7UyuzX87OzWUuOgW8ISukUhZmTQac1P+i0meUzDyFsS3ZtwTbGiLl2XLOE3N6/X
ATlEzLB/oA5BL2gs5GtnK7FHykhsuEKPX9+aTumTZsXe2Cg6hLZ+48Q2Bp2MNiBQ
0jqnIOyuuVzYdzw7B3Dqd0pcwscwcdpDqRyNwhNLVYCyZadNwY8E0XwiKl0yWLXV
NSQ1jMfXwSJosAc+F+awI5qkVwqeo/1XGm0a0CHo5F1gFiDFSzKMMLO9kkRMBg7v
v9JBIVSPIcQJBW5VE8TlJCBwcrvDuxT0PJ1Zx/ZbOYelNvmmwI3SUCjFNwBFtl11
Feb1MBqF24Tp1qJh9qqwxS7MIVuhG3v8TXORqwCQLXRpr9w0X/2Wjv1xqNeXOHST
JPFFFwvdS4tt9yo+RrfaeyXn9u7czgV51VvIVWSAgH2QEsIXV5IEeaIuEIOoO4gs
369NWpucEw1Q2vVODinO
=ZIra
-----END PGP SIGNATURE-----

--jIYo0VRlfdMI9fLa--
