Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbaIKILs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:11:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:54601 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133AbaIKILn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:11:43 -0400
Date: Thu, 11 Sep 2014 10:11:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Ingo Molnar <mingo@kernel.org>,
        Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: BUG uncore_assign_events
Message-ID: <20140911081137.GT6758@twins.programming.kicks-ass.net>
References: <20140910091626.GO16043@twins.programming.kicks-ass.net>
 <20140910215908.GL4120@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AUv0/Bqt5dWl9oeU"
Content-Disposition: inline
In-Reply-To: <20140910215908.GL4120@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AUv0/Bqt5dWl9oeU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2014 at 11:59:08PM +0200, Andi Kleen wrote:
> > # addr2line -i -e ivb-ep-build/vmlinux ffffffff81025f18
> >=20
> > arch/x86/include/asm/bitops.h:318
> > arch/x86/kernel/cpu/perf_event_intel_uncore.c:3339
>=20
> i =3D=3D zero  (ok)
> c points to some kernel looking address
> hwc->idx is 64
>=20
>      /* fastpath, try to reuse previous register */
>         for (i =3D 0; i < n; i++) {
>                 hwc =3D &box->event_list[i]->hw;
>                 c =3D hwc->constraint;
>=20
>                 /* never assigned */
>                 if (hwc->idx =3D=3D -1)
>                         break;
>=20
>                 /* constraint still honored */
>                 if (!test_bit(hwc->idx, c->idxmsk))
>                         break;
>=20
> My best bet is something goes wrong in uncore_pmu_to_box or
> uncore_event_to_pmu in hte caller, so the box is bogus.
>=20
> Did the test do CPU hot plug?

Dunno, I don't think it does. Its just the perf_fuzzer thing. A quick
grep of the source doesn't show hotplug stuff.

--AUv0/Bqt5dWl9oeU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUEVkxAAoJEHZH4aRLwOS6wAcP+gIJjS7G/YbH0TXsa+DfmX/+
EFt5Uk7+h9prZIHPvcju2x2XS9O6MjYpOJoZOIdP98134hU3gihFVTPRZGwtkqlM
GfJnwvjZ3Iowbg+4WSLSQY+tMcznAWKb6WpT5mQGCHiwig/LpcAzXzPNJUNoyDQe
8SGSHUxQRGt8eqcHLc028IuRscV+ZSfdiVmdsY66XWFX1I07OBcP0dEC9ZbcZs+O
aTgqjVpOt7Nun6yps9Vr0SVzzhCGHLHlCSwC2YWIcsdXulScGKKc/l2U7gUE1EtW
GNSIRyA7D4O9lbakbP5gsM/TMGmpEqdICoBolDRlGPn0lmtOKBAJ0FY0Cfx5BCqj
Ozbz+rWfoz6u35VXgEFYjiHVjXXFU2Xxvdiw5SJmgW77xsRnKBEA2hDA5yeQ/2ru
NHh0j8X6xNdOx8QTSj6vpChbv6pp1g4ATfyDzUTvaHL/DQxrX47UAaC4hk6Ex8hp
NNq/p4Y0dt3mZhX5eppIh6ojKoATwQIZ91bkXenUGh3UD/iL+3X7vhQxkhfaA4Lg
2FJm1U5Avx1/hFiFvzN6uCyhPFlXnDt10Ivn3depTGtfwyeEpBvTDsRHMXqVL9e2
KrL6ZPSSgsUkInq1nWjWgmgC2FOGAj6DiuGDNzuKpY01/5eAQ0lzGPRyj8J7nqt1
c5gXlAeNRwlmHGU0tSPX
=jK6Z
-----END PGP SIGNATURE-----

--AUv0/Bqt5dWl9oeU--
