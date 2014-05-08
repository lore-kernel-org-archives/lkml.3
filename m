Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbaEHSRn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 14:17:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:45138 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbaEHSRm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 14:17:42 -0400
Date: Thu, 8 May 2014 20:17:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: geert@linux-m68k.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, mingo@kernel.org, will.deacon@arm.com,
        paulmck@linux.vnet.ibm.com, jesper.nilsson@axis.com, starvik@axis.com
Subject: Re: [PATCH 07/20] arch,cris: Fold atomic_ops
Message-ID: <20140508181734.GK2844@laptop.programming.kicks-ass.net>
References: <20140508135852.104572724@infradead.org>
 <CAMuHMdV7FUC+p5XqwLZmqJRLYv1qhu5hf0M_e5pASBRHgFAhCA@mail.gmail.com>
 <20140508160606.GD30445@twins.programming.kicks-ass.net>
 <20140508.133451.1383193780216133211.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20140508.133451.1383193780216133211.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 01:34:51PM -0400, David Miller wrote:
> You did this for sparc too.

I did indeed.

And sparc32 and sparc64 compile file without these spurious hunks.

I'm sure I needed that to make it compile at one point, but I suspect
they're remnants from the smp_mb__ shuffle which needed include file
changes.

But since then I've redone those and solved the compile issues
differently, but these hunks stuck around...

I've gone over the other patches, cris and sparc appear to be the only
ones so affected.

Just to make sure; these two hunks just went into the bit-bucket:

Index: linux-2.6/arch/sparc/include/asm/barrier_32.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/barrier_32.h
+++ linux-2.6/arch/sparc/include/asm/barrier_32.h
@@ -1,7 +1,6 @@
 #ifndef __SPARC_BARRIER_H
 #define __SPARC_BARRIER_H
 
-#include <asm/processor.h> /* for nop() */
 #include <asm-generic/barrier.h>
 
 #endif /* !(__SPARC_BARRIER_H) */
Index: linux-2.6/arch/sparc/include/asm/processor.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/processor.h
+++ linux-2.6/arch/sparc/include/asm/processor.h
@@ -6,6 +6,4 @@
 #include <asm/processor_32.h>
 #endif
 
-#define nop() 		__asm__ __volatile__ ("nop")
-
 #endif
