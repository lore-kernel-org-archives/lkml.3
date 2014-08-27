Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936016AbaH0VzB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:55:01 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:42964 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933809AbaH0Vy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:54:59 -0400
Date: Wed, 27 Aug 2014 16:54:55 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH percpu/for-3.18-consistent-ops] Revert "powerpc: Replace
 __get_cpu_var uses"
In-Reply-To: <20140827214946.GA21396@mtj.dyndns.org>
Message-ID: <alpine.DEB.2.11.1408271653510.20761@gentwo.org>
References: <20140827142243.6277eaff@canb.auug.org.au> <20140827152609.GA379@htj.dyndns.org> <20140828074349.10e86372@canb.auug.org.au> <20140827214946.GA21396@mtj.dyndns.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014, Tejun Heo wrote:

> Weird, the build-bot reported success on all powerpc configs on the
> percpu branches w/o the revert.  I wonder what's going on.

I think this will fix it but I have no way of verifying it.


Subject: Define __ARCH_SET_SOFTIRQ_PENDING to avoid duplicate defs

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/arch/powerpc/include/asm/hardirq.h
===================================================================
--- linux.orig/arch/powerpc/include/asm/hardirq.h
+++ linux/arch/powerpc/include/asm/hardirq.h
@@ -20,6 +20,7 @@ typedef struct {
 DECLARE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);

 #define __ARCH_IRQ_STAT
+#define __ARCH_SET_SOFTIRQ_PENDING

 #define local_softirq_pending()	__this_cpu_read(irq_stat.__softirq_pending)
 #define set_softirq_pending(x) __this_cpu_write(irq_stat._softirq_pending, (x))
