Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759085AbaGXNjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:39:35 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56610 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758924AbaGXNje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:39:34 -0400
Date: Thu, 24 Jul 2014 15:39:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: rjw@rjwysocki.net, linux-kernel@vger.kernel.org
Subject: [PATCH] irq: Warn when shared interrupts do not match on NO_SUSPEND
Message-ID: <20140724133921.GY6758@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lZl9LXaXBWDq3P64"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lZl9LXaXBWDq3P64
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Subject: irq: Warn when shared interrupts do not match on NO_SUSPEND

When suspend_device_irqs() iterates all descriptors, its pointless if
one has NO_SUSPEND set while another has not.

Validate on request_irq() that NO_SUSPEND state maches for SHARED
interrupts.

Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/irq/manage.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 88657d7bc9dd..27a1fe028afb 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1077,9 +1077,12 @@ __setup_irq(unsigned int irq, struct irq_desc *desc,=
 struct irqaction *new)
 		 * set the trigger type must match. Also all must
 		 * agree on ONESHOT.
 		 */
+
+#define IRQF_MISMATCH \
+	(IRQF_TRIGGER_MASK | IRQF_ONESHOT | IRQF_NO_SUSPEND)
+
 		if (!((old->flags & new->flags) & IRQF_SHARED) ||
-		    ((old->flags ^ new->flags) & IRQF_TRIGGER_MASK) ||
-		    ((old->flags ^ new->flags) & IRQF_ONESHOT))
+		    ((old->flags ^ new->flags) & IRQF_MISMATCH))
 			goto mismatch;
=20
 		/* All handlers must agree on per-cpuness */

--lZl9LXaXBWDq3P64
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT0QyJAAoJEHZH4aRLwOS6dXAP/32Y1aTffDLRl97ei7y+ULx8
I8p0IBt4qnt8Xbh0c32yoCnn3A5YPlP5TaEXBK5bPhjI504vPI/rGYsk/jrZTEED
WQdn0sXbXXendJi0uu2qumR2ZeKz5Xl4onDGQyDdTFXimAyi1Ufd1du5e4Bb1pTs
LN3hgE7mQt43PUZGa75XVMhCizImTLx5u1A/hFRfY2shys6mRmQJLnvCyVkYGnLA
QI2oJiMq9z7SyauaBCO2RH1wU2imSa3iag/vrMZmRxe56+mHlif5qT82LqJ2DC80
/4LEVwNjd3TpoJrBWBuNlFtz43fTfVKPb8GuV5pIS2AIY3uIaJaiqIpHGE4NRo7p
8HE61f5/50mLqSjMhQ1D6wqV59JyCNu/CO4fdrE/DQlE1mLica1Yq2bA6au+LCTN
diersYwUgGHXkdgt2qsvmWsiOPp0L/mohQ21zUqhfOUhWOjXldZ0l0i8QeBT88qe
4I9mayCT6gcfRWrc+f/o6wmJ7f4EdCM9VeBFi2EwKV6bzcld/IzIao91rajz3x/b
MC+QDItBjH07SAXhKdsI98IzyEgNTszXpFKrJgp+SVPoiZSSlbazdpwVRPU6Ekyr
yvF2To95QXgRyAI8dV7mhF8jFjmR04/C3uCmgecja871kWqQtGfTkrT/Cf0WlIIV
J3L/k/twCpTNagwGab1o
=8nrh
-----END PGP SIGNATURE-----

--lZl9LXaXBWDq3P64--
