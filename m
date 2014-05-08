Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbaEHS0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 14:26:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:45201 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbaEHS0p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 14:26:45 -0400
Date: Thu, 8 May 2014 20:26:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        mingo@kernel.org, will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 20/20] arch: Rewrite generic atomic support
Message-ID: <20140508182642.GL2844@laptop.programming.kicks-ass.net>
References: <20140508135840.956784204@infradead.org>
 <20140508135852.940119622@infradead.org>
 <20140508152401.GA5177@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20140508152401.GA5177@ravnborg.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 05:24:01PM +0200, Sam Ravnborg wrote:
> >  
> > -/**
> > - * atomic_add_return - add integer to atomic variable
> > - * @i: integer value to add
> > - * @v: pointer of type atomic_t
> > - *
> > - * Atomically adds @i to @v and returns the result
> > - */
> For people not starign at kernel code every days these sparse comments
> is a help. If anything they should be improved rather than deleted.

Does something like this help? Its a bit tedious to have to repeat the
comment while we just collapsed all the implementations.


--- a/include/asm-generic/atomic.h
+++ b/include/asm-generic/atomic.h
@@ -18,6 +18,23 @@
 #include <asm/cmpxchg.h>
 #include <asm/barrier.h>
 
+/*
+ * atomic_$op() - $op integer to atomic variable
+ * @i: integer value to $op
+ * @v: pointer to the atomic variable
+ *
+ * Atomically $ops @i to @v. Does not strictly guarantee a memory-barrier, use
+ * smp_mb__{before,after}_atomic().
+ */
+
+/*
+ * atomic_$op_return() - $op interer to atomic variable and returns the result
+ * @i: integer value to $op
+ * @v: pointer to the atomic variable
+ *
+ * Atomically $ops @i to @v. Does imply a full memory barrier.
+ */
+
 #ifdef CONFIG_SMP
 
 /* we can build all atomic primitives from cmpxchg */
