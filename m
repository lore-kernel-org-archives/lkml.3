Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536AbaJRUUJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 16:20:09 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:56761 "EHLO
	homiemail-a9.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751429AbaJRUUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 16:20:07 -0400
Message-ID: <1413663590.17869.14.camel@linux-t7sj.site>
Subject: Re: [PATCH] futex: Ensure get_futex_key_refs() always implies a
 barrier
From: Davidlohr Bueso <dave@stgolabs.net>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
        Matteo Franchin <Matteo.Franchin@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Darren Hart <dvhart@infradead.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>
Date: Sat, 18 Oct 2014 13:19:50 -0700
In-Reply-To: <5442C045.2040909@linux.intel.com>
References: <1413563929-2664-1-git-send-email-catalin.marinas@arm.com>
	 <5442C045.2040909@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-10-18 at 14:32 -0500, Darren Hart wrote:
> Which is not incomplete (lacking the explicit smp_mb()) added by this
> patch. Perhaps the MB implementation of get_futex_key_refs() need not be
> explicitly enumerated here?

Agreed, how about this:

diff --git a/kernel/futex.c b/kernel/futex.c
index 21f7e41..7a0805a 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -143,9 +143,8 @@
  *
  * Where (A) orders the waiters increment and the futex value read through
  * atomic operations (see hb_waiters_inc) and where (B) orders the write
- * to futex and the waiters read -- this is done by the barriers in
- * get_futex_key_refs(), through either ihold or atomic_inc, depending on the
- * futex type.
+ * to futex and the waiters read -- this is done by the barriers for both
+ * shared and private futexes in get_futex_key_refs().
  *
  * This yields the following case (where X:=waiters, Y:=futex):
  *



