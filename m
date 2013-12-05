Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab3LEMaJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 07:30:09 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:51632 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756632Ab3LEMaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 07:30:00 -0500
Date: Thu, 5 Dec 2013 13:29:55 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Henrik Austad <henrik@austad.us>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: [PATCH v4 tip/core/locking 3/4] Documentation/memory-barriers.txt:
 Prohibit speculative writes
Message-ID: <20131205122955.GC20562@gmail.com>
References: <20131204224628.GA30159@linux.vnet.ibm.com>
 <20131205105928.GA27382@austad.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131205105928.GA27382@austad.us>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(here's #3.)

----- Forwarded message from "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> -----

Date: Wed,  4 Dec 2013 14:46:58 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org, mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
	tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Richard Henderson <rth@twiddle.net>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner
	<mattst88@gmail.com>, Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>, Catalin Marinas
	<catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Haavard Skinnemoen <hskinnemoen@gmail.com>, Hans-Christian Egtvedt <egtvedt@samfundet.no>, Mike
	Frysinger <vapier@gentoo.org>, Mark Salter <msalter@redhat.com>, Aurelien Jacquiot <a-jacquiot@ti.com>, Mikael Starvik <starvik@axis.com>, Jesper Nilsson
	<jesper.nilsson@axis.com>, Yoshinori Sato <ysato@users.sourceforge.jp>, Richard Kuo <rkuo@codeaurora.org>, Tony Luck <tony.luck@intel.com>, Fenghua Yu
	<fenghua.yu@intel.com>, Hirokazu Takata <takata@linux-m32r.org>, Geert Uytterhoeven <geert@linux-m68k.org>, James Hogan <james.hogan@imgtec.com>, Michal Simek
	<monstr@monstr.eu>, Ralf Baechle <ralf@linux-mips.org>, Koichi Yasutake <yasutake.koichi@jp.panasonic.com>, Jonas Bonn <jonas@southpole.se>, "James E.J.
	Bottomley" <jejb@parisc-linux.org>, Helge Deller <deller@gmx.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Anatolij
	Gustschin <agust@denx.de>, Josh Boyer <jwboyer@gmail.com>, Matt Porter <mporter@kernel.crashing.org>, Vitaly Bordug <vitb@kernel.crashing.org>, Kumar Gala
	<galak@kernel.crashing.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chen Liqin <liqin.linux@gmail.com>, Lennox
	Wu <lennox.wu@gmail.com>, Paul Mundt <lethal@linux-sh.org>, "David S. Miller" <davem@davemloft.net>, Chris Metcalf <cmetcalf@tilera.com>, Jeff Dike
	<jdike@addtoit.com>, Richard Weinberger <richard@nod.at>, Guan Xuetao <gxt@mprc.pku.edu.cn>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH tip/core/locking 3/4] Documentation/memory-barriers.txt: Prohibit speculative writes

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

No SMP architecture currently supporting Linux allows speculative writes,
so this commit updates Documentation/memory-barriers.txt to prohibit
them in Linux core code.  It also records restrictions on their use.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Mark Salter <msalter@redhat.com>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Anatolij Gustschin <agust@denx.de>
Cc: Josh Boyer <jwboyer@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Vitaly Bordug <vitb@kernel.crashing.org>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Chen Liqin <liqin.linux@gmail.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
---
 Documentation/memory-barriers.txt | 183 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 175 insertions(+), 8 deletions(-)

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index 2d22da095a60..3e4429ef1458 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -571,11 +571,10 @@ dependency barrier to make it work correctly.  Consider the following bit of
 code:
 
 	q = ACCESS_ONCE(a);
-	if (p) {
-		<data dependency barrier>
-		q = ACCESS_ONCE(b);
+	if (q) {
+		<data dependency barrier>  /* BUG: No data dependency!!! */
+		p = ACCESS_ONCE(b);
 	}
-	x = *q;
 
 This will not have the desired effect because there is no actual data
 dependency, but rather a control dependency that the CPU may short-circuit
@@ -584,11 +583,176 @@ the load from b as having happened before the load from a.  In such a
 case what's actually required is:
 
 	q = ACCESS_ONCE(a);
-	if (p) {
+	if (q) {
 		<read barrier>
-		q = ACCESS_ONCE(b);
+		p = ACCESS_ONCE(b);
 	}
-	x = *q;
+
+However, stores are not speculated.  This means that ordering -is- provided
+in the following example:
+
+	q = ACCESS_ONCE(a);
+	if (ACCESS_ONCE(q)) {
+		ACCESS_ONCE(b) = p;
+	}
+
+Please note that ACCESS_ONCE() is not optional!  Without the ACCESS_ONCE(),
+the compiler is within its rights to transform this example:
+
+	q = a;
+	if (q) {
+		b = p;  /* BUG: Compiler can reorder!!! */
+		do_something();
+	} else {
+		b = p;  /* BUG: Compiler can reorder!!! */
+		do_something_else();
+	}
+
+into this, which of course defeats the ordering:
+
+	b = p;
+	q = a;
+	if (q)
+		do_something();
+	else
+		do_something_else();
+
+Worse yet, if the compiler is able to prove (say) that the value of
+variable a is always non-zero, it would be well within its rights
+to optimize the original example by eliminating the "if" statement
+as follows:
+
+	q = a;
+	b = p;  /* BUG: Compiler can reorder!!! */
+	do_something();
+
+The solution is again ACCESS_ONCE(), which preserves the ordering between
+the load from variable a and the store to variable b:
+
+	q = ACCESS_ONCE(a);
+	if (q) {
+		ACCESS_ONCE(b) = p;
+		do_something();
+	} else {
+		ACCESS_ONCE(b) = p;
+		do_something_else();
+	}
+
+You could also use barrier() to prevent the compiler from moving
+the stores to variable b, but barrier() would not prevent the
+compiler from proving to itself that a==1 always, so ACCESS_ONCE()
+is also needed.
+
+It is important to note that control dependencies absolutely require a
+a conditional.  For example, the following "optimized" version of
+the above example breaks ordering:
+
+	q = ACCESS_ONCE(a);
+	ACCESS_ONCE(b) = p;  /* BUG: No ordering vs. load from a!!! */
+	if (q) {
+		/* ACCESS_ONCE(b) = p; -- moved up, BUG!!! */
+		do_something();
+	} else {
+		/* ACCESS_ONCE(b) = p; -- moved up, BUG!!! */
+		do_something_else();
+	}
+
+It is of course legal for the prior load to be part of the conditional,
+for example, as follows:
+
+	if (ACCESS_ONCE(a) > 0) {
+		ACCESS_ONCE(b) = q / 2;
+		do_something();
+	} else {
+		ACCESS_ONCE(b) = q / 3;
+		do_something_else();
+	}
+
+This will again ensure that the load from variable a is ordered before the
+stores to variable b.
+
+In addition, you need to be careful what you do with the local variable q,
+otherwise the compiler might be able to guess the value and again remove
+the needed conditional.  For example:
+
+	q = ACCESS_ONCE(a);
+	if (q % MAX) {
+		ACCESS_ONCE(b) = p;
+		do_something();
+	} else {
+		ACCESS_ONCE(b) = p;
+		do_something_else();
+	}
+
+If MAX is defined to be 1, then the compiler knows that (q % MAX) is
+equal to zero, in which case the compiler is within its rights to
+transform the above code into the following:
+
+	q = ACCESS_ONCE(a);
+	ACCESS_ONCE(b) = p;
+	do_something_else();
+
+This transformation loses the ordering between the load from variable a
+and the store to variable b.  If you are relying on this ordering, you
+should do something like the following:
+
+	q = ACCESS_ONCE(a);
+	BUILD_BUG_ON(MAX <= 1); /* Order load from a with store to b. */
+	if (q % MAX) {
+		ACCESS_ONCE(b) = p;
+		do_something();
+	} else {
+		ACCESS_ONCE(b) = p;
+		do_something_else();
+	}
+
+Finally, control dependencies do -not- provide transitivity.  This is
+demonstrated by two related examples:
+
+	CPU 0                     CPU 1
+	=====================     =====================
+	r1 = ACCESS_ONCE(x);      r2 = ACCESS_ONCE(y);
+	if (r1 >= 0)              if (r2 >= 0)
+	  ACCESS_ONCE(y) = 1;       ACCESS_ONCE(x) = 1;
+
+	assert(!(r1 == 1 && r2 == 1));
+
+The above two-CPU example will never trigger the assert().  However,
+if control dependencies guaranteed transitivity (which they do not),
+then adding the following two CPUs would guarantee a related assertion:
+
+	CPU 2                     CPU 3
+	=====================     =====================
+	ACCESS_ONCE(x) = 2;       ACCESS_ONCE(y) = 2;
+
+	assert(!(r1 == 2 && r2 == 2 && x == 1 && y == 1)); /* FAILS!!! */
+
+But because control dependencies do -not- provide transitivity, the
+above assertion can fail after the combined four-CPU example completes.
+If you need the four-CPU example to provide ordering, you will need
+smp_mb() between the loads and stores in the CPU 0 and CPU 1 code fragments.
+
+In summary:
+
+  (*) Control dependencies can order prior loads against later stores.
+      However, they do -not- guarantee any other sort of ordering:
+      Not prior loads against later loads, nor prior stores against
+      later anything.  If you need these other forms of ordering,
+      use smb_rmb(), smp_wmb(), or, in the case of prior stores and
+      later loads, smp_mb().
+
+  (*) Control dependencies require at least one run-time conditional
+      between the prior load and the subsequent store.  If the compiler
+      is able to optimize the conditional away, it will have also
+      optimized away the ordering.  Careful use of ACCESS_ONCE() can
+      help to preserve the needed conditional.
+
+  (*) Control dependencies require that the compiler avoid reordering the
+      dependency into nonexistence.  Careful use of ACCESS_ONCE() or
+      barrier() can help to preserve your control dependency.
+
+  (*) Control dependencies do -not- provide transitivity.  If you
+      need transitivity, use smp_mb().
 
 
 SMP BARRIER PAIRING
@@ -1083,7 +1247,10 @@ compiler from moving the memory accesses either side of it to the other side:
 
 	barrier();
 
-This is a general barrier - lesser varieties of compiler barrier do not exist.
+This is a general barrier -- there are no read-read or write-write variants
+of barrier().  Howevever, ACCESS_ONCE() can be thought of as a weak form
+for barrier() that affects only the specific accesses flagged by the
+ACCESS_ONCE().
 
 The compiler barrier has no direct effect on the CPU, which may then reorder
 things however it wishes.
-- 
1.8.1.5


----- End forwarded message -----
