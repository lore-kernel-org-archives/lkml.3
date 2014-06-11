Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbaFKJFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:05:35 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49514 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaFKJFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 05:05:31 -0400
Date: Wed, 11 Jun 2014 11:05:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Waiman Long <Waiman.Long@hp.com>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, konrad.wilk@oracle.com, torvalds@linux-foundation.org,
        davej@redhat.com, jeremy@goop.org, paulmck@linux.vnet.ibm.com,
        raghavendra.kt@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [tip:locking/core] x86, locking/rwlocks: Enable qrwlocks on x86
Message-ID: <20140611090509.GC3588@twins.programming.kicks-ass.net>
References: <tip-r1xuzmdysvuhl3h86n5fbxi7@git.kernel.org>
 <1402474451.3798.44.camel@x220>
 <20140611085921.GJ3213@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i7F3eY7HS/tUJxUd"
Content-Disposition: inline
In-Reply-To: <20140611085921.GJ3213@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i7F3eY7HS/tUJxUd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 11, 2014 at 10:59:21AM +0200, Peter Zijlstra wrote:
> On Wed, Jun 11, 2014 at 10:14:11AM +0200, Paul Bolle wrote:
> > On Fri, 2014-06-06 at 05:20 -0700, tip-bot for Waiman Long wrote:
> > > +#if !defined(CONFIG_X86_OOSTORE) && !defined(CONFIG_X86_PPRO_FENCE)
> >=20
> > X86_OOSTORE was removed in v3.14, see commit 09df7c4c8097 ("x86: Remove
> > CONFIG_X86_OOSTORE"). So the first test can be removed here, as it will
> > always be true. Should I submit the trivial, but probably untested,
> > patch to do that or do you prefer to do that yourself?
>=20
> I was completely unaware of that removal. Yeah, I'll queue patch
> removing this new instance of it.
>=20
> Good to have it gone though, one little crazy less.

I've queued the below. Thanks!

---
Subject: x86, locking: No more OOSTORE nonsense
=46rom: Peter Zijlstra <peterz@infradead.org>
Date: Wed Jun 11 11:01:45 CEST 2014

Paul reported that X86_OOSTORE is dead, yay! Update a comment and
remove a newly added reference.

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-6w40duqjdmo3sslxtvisuh7w@git.kernel.org
---
 arch/x86/include/asm/barrier.h |    2 +-
 arch/x86/include/asm/qrwlock.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/barrier.h
+++ b/arch/x86/include/asm/barrier.h
@@ -99,7 +99,7 @@
 #if defined(CONFIG_X86_PPRO_FENCE)
=20
 /*
- * For either of these options x86 doesn't have a strong TSO memory
+ * For this option x86 doesn't have a strong TSO memory
  * model and we should fall back to full barriers.
  */
=20
--- a/arch/x86/include/asm/qrwlock.h
+++ b/arch/x86/include/asm/qrwlock.h
@@ -3,7 +3,7 @@
=20
 #include <asm-generic/qrwlock_types.h>
=20
-#if !defined(CONFIG_X86_OOSTORE) && !defined(CONFIG_X86_PPRO_FENCE)
+#ifndef CONFIG_X86_PPRO_FENCE
 #define queue_write_unlock queue_write_unlock
 static inline void queue_write_unlock(struct qrwlock *lock)
 {



--i7F3eY7HS/tUJxUd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTmBvFAAoJEHZH4aRLwOS65hAP/3H8Ctne9HyAsZqsZz3x5w0a
UO0OBtkxCvMlWx4bY+RMBL9Pi71aCHbVnuGdGJFECc38PhG3TLi3zJ7L0Gt4Zo4W
GLlnH0jhcH71zSv5K8Wrx+pEHPh6KgFZRvvon0Sd9pwsR+sPLbZ5WMLt1/M2f1Q/
UYH+fs7eKld2A30ZI4sWPn/SduSLSUj6DlWCjwAC+p+RC2EjgZGBEXzb7O7UDm/K
itbK5F0mlENfm3U/ATZfB751BTmszCPCVsl0u0Ia8ncI95xIFBtw9f+bdmFX900v
eiskUu0l5FB4gUNDtB93q/qf6g3clb5w7Hmbr8OcbtL+qCRISUejfZOU3ibO/Xqn
zMgrzaSOlhwYqIKTwWU7oTDWJShamsLDAnFLvLGKhrDbz/nFW1MG+q4fdYEehiNH
XxVf2a3Wq9LDXPhXH6HoCXM7+HU7zohzFTpWLXpvYWfKMF9BUEX3wBj/VXLOyNK3
3OOdc/Nve+olcY3S/Hnrv0Mz0F8AY6idR2Det6e/JqmdACGWVyptZfW51+j1uym3
XMydkM60foUUse8UdgtRagWRAXuFNgfyC8UE3Pbo8YxD8PxRkJjPq/ARczIE5+BO
kKJln7dDI9sv496l7wD0B/meLuxQ665ODUFlHgnfIK46WqxZB1v0vpXLxmo0vrZN
XFMkHfjS+5LIBQ3T+qn9
=7EV7
-----END PGP SIGNATURE-----

--i7F3eY7HS/tUJxUd--
