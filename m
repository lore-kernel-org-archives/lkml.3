Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372AbaEIRGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 13:06:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:50155 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757098AbaEIRGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 13:06:54 -0400
Date: Fri, 9 May 2014 19:06:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Hogan <james.hogan@imgtec.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "luto@amacapital.net" <luto@amacapital.net>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "umgwanakikbuti@gmail.com" <umgwanakikbuti@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Will Deacon <Will.Deacon@arm.com>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC][PATCH 6/8] sched,idle: Avoid spurious wakeup IPIs
Message-ID: <20140509170649.GG13658@twins.programming.kicks-ass.net>
References: <20140411134243.160989490@infradead.org>
 <20140411135218.478299389@infradead.org>
 <CAAG0J9_q1KsUx10-XAb7AJnxv2ehctg6q1KME7ahsk1OZV8vZQ@mail.gmail.com>
 <20140509141520.GV2844@laptop.programming.kicks-ass.net>
 <20140509144034.GF7950@arm.com>
 <20140509145002.GW2844@laptop.programming.kicks-ass.net>
 <20140509145745.GI7950@arm.com>
 <20140509170234.GZ30445@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sgneBHv3152wZ8jf"
Content-Disposition: inline
In-Reply-To: <20140509170234.GZ30445@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sgneBHv3152wZ8jf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 09, 2014 at 07:02:34PM +0200, Peter Zijlstra wrote:
> OK, so I'll queue a patch removing TIF_POLLING_NRFLAG for arm64.


---
Subject: arm64: Remove TIF_POLLING_NRFLAG
=46rom: Peter Zijlstra <peterz@infradead.org>
Date: Fri May  9 19:04:00 CEST 2014

The only idle method for arm64 is WFI and it therefore
unconditionally requires the reschedule interrupt when idle.

Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/arm64/include/asm/thread_info.h |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -95,13 +95,11 @@ static inline struct thread_info *curren
  *  TIF_NEED_RESCHED	- rescheduling necessary
  *  TIF_NOTIFY_RESUME	- callback before returning to user
  *  TIF_USEDFPU		- FPU was used by this task this quantum (SMP)
- *  TIF_POLLING_NRFLAG	- true if poll_idle() is polling TIF_NEED_RESCHED
  */
 #define TIF_SIGPENDING		0
 #define TIF_NEED_RESCHED	1
 #define TIF_NOTIFY_RESUME	2	/* callback before returning to user */
 #define TIF_SYSCALL_TRACE	8
-#define TIF_POLLING_NRFLAG	16
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
 #define TIF_FREEZE		19
 #define TIF_RESTORE_SIGMASK	20

--sgneBHv3152wZ8jf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTbQspAAoJEHZH4aRLwOS659QP/jg2siwjcbb2KQ6pIosXsYQn
VNPZJ+Mx2xTGnhbz+e4z7wTSEHUCcWVdPmkwkjmn6muOMtjpe3mJReyVjziGcYkU
XkkOjuwpwvV81Ga3XkPM3uKmUdiHg/3+7uLhCIZpOXE/0LZNNkpHmmLcwARRxW06
Vm+zNBBZZdqePaWq/Gg3NsupA1pHeAgKW8pgCZch2tEPNyfhEX2jr0S2j1G8X8zm
9t9fgcuqWroBZaGor2dNie7037GyKzF9oQBHsUkhfOSHsuoLaEEdMyaE6Ely8SCs
H27AWv5xCKhnW6rokmqzngurYt9yIk/FjS2spkDdhQeqeaGKg+aQe1PtNj6q0bsY
dFSzUGPxNd5YledHPjdQjP94S71CY7vbbyFt72O8HL90Q3BStQGwbp1ISWtJ1Rrp
YVhLzMDoOG5jQpnSMbYoDzOjk7fA0EXb1icRs/S+E1qekdM0w8L8lcL+hsHz8zhV
YNzCRY4VF7fLyDbKfNtybeo/mxU+pD0bV3kY2TSbphKYfkI7c68JY9qjBCG7mh87
/vBhbVHIum4iZp2aCXn++sJjG00XA+869wjALnCeVYvw0nAEFV6HEIP4i8/A+gNK
DYrUi5fNebKXgYb1bsShvJGB90OdzQsUKEAB+fReiu/GLrZk+s17OMI7M5n/x5cN
xpe8axYrQG00+w3Erbrb
=994z
-----END PGP SIGNATURE-----

--sgneBHv3152wZ8jf--
