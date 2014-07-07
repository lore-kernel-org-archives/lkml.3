Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750906AbaGGTHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 15:07:16 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51510 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbaGGTHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 15:07:13 -0400
Date: Mon, 7 Jul 2014 21:06:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        mingo@kernel.org, Waiman.Long@hp.com, davidlohr@hp.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, riel@redhat.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, hpa@zytor.com,
        tim.c.chen@linux.intel.com, konrad.wilk@oracle.com, aswin@hp.com,
        scott.norton@hp.com, chegu_vinod@hp.com, david@fromorbit.com
Subject: Re: [PATCH 0/4] MCS spinlocks: Cancellable MCS spinlock rework
Message-ID: <20140707190637.GI19379@twins.programming.kicks-ass.net>
References: <1404759019-4268-1-git-send-email-jason.low2@hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RdtFsg6OMqKngl0P"
Content-Disposition: inline
In-Reply-To: <1404759019-4268-1-git-send-email-jason.low2@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RdtFsg6OMqKngl0P
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 07, 2014 at 11:50:15AM -0700, Jason Low wrote:
> The main purpose of this patchset is to reduce the size of the
> cancellable MCS spinlock and reduce the overhead of rwsem
> (currently the largest lock in the kernel).
>=20
> The overhead of the cancellable MCS lock is a pointer to a per-cpu  node
> structure which requires 64 bits on 64 bit systems. Instead of a pointer
> to the per-cpu node, we can instead store the CPU # corresponding to the
> node in atomic_t. This reduces the overhead by 32 bits on 64 bit systems.
>=20
> This then opens the opportunity to reduce the size of the rw_semaphore
> structure (one of the current users of this MCS lock) by moving around so=
me
> of its fields. Due to padding, we would reduce the size of that structure
> by 64 bits (on 64 bit systems). This makes it more in line with the size
> of the mutex structure.

Dave Chinner was very interested in this..

--RdtFsg6OMqKngl0P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTuu+9AAoJEHZH4aRLwOS6EpMP/A/hNrDLu0RrsU+TrCqDL/Yl
G6UyqE4fFdQT5c7it1S5x7utqDYlQOktrJFuvh6sfjmThnH2YoqRMVKr4cfyKtHH
6S6WIhWwhYBSjBzkcLPaKG5D69b98WjZ4o1/2HQmub0pl0x0v8FgrVJ0IzXRxkg1
+4NaaHahmsjUWEkdGvMAAnOSDMdik5Ul7o9WpfnjxHEwZPafe5qkaH1ODv7hZxgA
rqv7v4hABI1HcHqFgesIUWtqhS9VmTF8rjEG2vxmM1yzHX1SrmaPQcranom+aPTE
ZPJ/ikRdhTJBZMnEPDy4UeEniY/kjKmbSfDh81GJmCXsC5RlyOrGSQ2WpzuUhly8
iklOTEV0B9ulH0wjhvA6+2DdahCUlJPSCYoy3KYYpbFgB2JH1jYWI8RYheYHMAsq
MFt0qO7rvEnzWm/UsU0BTmWnbanjL6f8ZyR15rerUp8XsmLc6UlddW/tuJNaLCxy
3HfJQ/GoaRrTmTcU/3u0j485yBWLtPIR796u77piHKwhCG0b0J7jXSmdMl7prwi/
Hu5YpkkusXGqaaYv8HpR4JKGCwUSYXqjkoU3Z7Z0o4SwSUU3EdKkIz4dUh/C6h7m
OhS+rUWxKWxY8r9wnZgWdU9ioM0/KDNQC5v+xg8UsXEpy359xv30ramh3Nw/weKw
v2+afjzi7NZ74PNdezCS
=8d1b
-----END PGP SIGNATURE-----

--RdtFsg6OMqKngl0P--
