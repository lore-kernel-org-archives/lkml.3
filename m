Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbaHRUAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 16:00:44 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:51308 "EHLO
	homiemail-a8.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751066AbaHRUAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 16:00:43 -0400
X-Greylist: delayed 101539 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Aug 2014 16:00:43 EDT
Message-ID: <1408392039.3718.6.camel@buesod1.americas.hpqcorp.net>
Subject: [PATCH BUGFIX] frv: Define cpu_relax_lowlatency()
From: Davidlohr Bueso <dave@stgolabs.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        davidlohr@hp.com
Date: Mon, 18 Aug 2014 13:00:39 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3a6bfbc9 (arch,locking: Ciao arch_mutex_cpu_relax()) broke building the frv
arch. Fixes errors such as:

kernel/locking/mcs_spinlock.h:87:2: error: implicit declaration of function 'cpu_relax_lowlatency'

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
Linus, as discussed, here's the resend.
Original thread: https://lkml.org/lkml/2014/8/5/442

 arch/frv/include/asm/processor.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/frv/include/asm/processor.h b/arch/frv/include/asm/processor.h
index a34f309..6554e78 100644
--- a/arch/frv/include/asm/processor.h
+++ b/arch/frv/include/asm/processor.h
@@ -129,7 +129,8 @@ unsigned long get_wchan(struct task_struct *p);
 #define	KSTK_EIP(tsk)	((tsk)->thread.frame0->pc)
 #define	KSTK_ESP(tsk)	((tsk)->thread.frame0->sp)
 
-#define cpu_relax()    barrier()
+#define cpu_relax() barrier()
+#define cpu_relax_lowlatency() cpu_relax()
 
 /* data cache prefetch */
 #define ARCH_HAS_PREFETCH
-- 
1.8.1.4



