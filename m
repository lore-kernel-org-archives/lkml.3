Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131AbaE2E15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:27:57 -0400
Received: from mail-yh0-f45.google.com ([209.85.213.45]:59197 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaE2E14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:27:56 -0400
Message-ID: <5386B75A.3010806@gmail.com>
Date: Thu, 29 May 2014 00:28:10 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: peterz@infradead.org, paulmck@linux.vnet.ibm.com
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v2 1/1] rename {before/after}_atomic_{inc/dec} to {before/after}_atomic
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 There is no reason to have separete barriers for atomic_inc and atomic_dec. 
 All the architectures use the same barriers for both.

 We can simplify it and just have {before/after}_atomic after renaming.

 I used coccinelle script to do the renames in the C files and did the rename by hand in the headers.

v2: 
* remove duplicate macros in missed files
* correct indentation

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 Documentation/atomic_ops.txt                     | 18 +++-----
 Documentation/memory-barriers.txt                | 11 ++---
 arch/alpha/include/asm/atomic.h                  |  6 +--
 arch/arc/include/asm/atomic.h                    |  6 +--
 arch/arm/include/asm/atomic.h                    |  6 +--
 arch/arm64/include/asm/atomic.h                  |  6 +--
 arch/avr32/include/asm/atomic.h                  |  6 +--
 arch/cris/include/asm/atomic.h                   |  6 +--
 arch/frv/include/asm/atomic.h                    |  6 +--
 arch/hexagon/include/asm/atomic.h                |  6 +--
 arch/ia64/include/asm/atomic.h                   |  6 +--
 arch/m32r/include/asm/atomic.h                   |  6 +--
 arch/m68k/include/asm/atomic.h                   |  6 +--
 arch/metag/include/asm/atomic.h                  |  6 +--
 arch/mips/include/asm/atomic.h                   |  6 +--
 arch/mn10300/include/asm/atomic.h                |  6 +--
 arch/parisc/include/asm/atomic.h                 |  6 +--
 arch/powerpc/include/asm/atomic.h                |  6 +--
 arch/powerpc/kernel/crash.c                      |  2 +-
 arch/s390/include/asm/atomic.h                   |  6 +--
 arch/sh/include/asm/atomic.h                     |  6 +--
 arch/sparc/include/asm/atomic_32.h               |  6 +--
 arch/sparc/include/asm/atomic_64.h               |  6 +--
 arch/tile/include/asm/atomic_32.h                |  6 +--
 arch/tile/include/asm/atomic_64.h                |  6 +--
 arch/tile/include/asm/bitops_32.h                |  2 +-
 arch/x86/include/asm/atomic.h                    |  6 +--
 arch/xtensa/include/asm/atomic.h                 |  6 +--
 drivers/base/power/domain.c                      |  2 +-
 drivers/cpuidle/coupled.c                        |  2 +-
 drivers/gpu/drm/drm_irq.c                        | 10 ++---
 drivers/gpu/drm/i915/i915_irq.c                  |  2 +-
 drivers/md/bcache/bcache.h                       |  2 +-
 drivers/md/bcache/closure.h                      |  2 +-
 drivers/md/dm-snap.c                             |  2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c | 10 ++---
 drivers/target/loopback/tcm_loop.c               |  4 +-
 drivers/target/target_core_alua.c                | 26 +++++------
 drivers/target/target_core_device.c              |  6 +--
 drivers/target/target_core_iblock.c              |  2 +-
 drivers/target/target_core_pr.c                  | 56 ++++++++++++------------
 drivers/target/target_core_transport.c           | 16 +++----
 drivers/target/target_core_ua.c                  | 10 ++---
 drivers/usb/gadget/tcm_usb_gadget.c              |  4 +-
 drivers/vhost/scsi.c                             |  2 +-
 drivers/w1/w1_family.c                           |  4 +-
 fs/btrfs/inode.c                                 |  6 +--
 fs/btrfs/ioctl.c                                 |  2 +-
 fs/nfs/dir.c                                     |  8 ++--
 fs/nfs/pnfs.h                                    |  2 +-
 include/asm-generic/atomic.h                     |  6 +--
 include/linux/buffer_head.h                      |  2 +-
 include/linux/genhd.h                            |  2 +-
 include/linux/interrupt.h                        |  6 +--
 include/net/ip_vs.h                              |  4 +-
 kernel/debug/debug_core.c                        |  4 +-
 kernel/futex.c                                   |  4 +-
 kernel/kmod.c                                    |  2 +-
 kernel/rcu/tree.c                                | 22 +++++-----
 kernel/rcu/tree_plugin.h                         |  8 ++--
 kernel/sched/cpupri.c                            |  6 +--
 net/ipv4/inetpeer.c                              |  2 +-
 net/netfilter/nf_conntrack_core.c                |  2 +-
 net/unix/af_unix.c                               |  2 +-
 64 files changed, 186 insertions(+), 243 deletions(-)

diff --git a/Documentation/atomic_ops.txt b/Documentation/atomic_ops.txt
index d9ca5be..635bc19 100644
--- a/Documentation/atomic_ops.txt
+++ b/Documentation/atomic_ops.txt
@@ -285,15 +285,13 @@ If a caller requires memory barrier semantics around an atomic_t
 operation which does not return a value, a set of interfaces are
 defined which accomplish this:
 
-	void smp_mb__before_atomic_dec(void);
-	void smp_mb__after_atomic_dec(void);
-	void smp_mb__before_atomic_inc(void);
-	void smp_mb__after_atomic_inc(void);
+	void smp_mb__before_atomic(void);
+	void smp_mb__after_atomic(void);
 
-For example, smp_mb__before_atomic_dec() can be used like so:
+For example, smp_mb__before_atomic() can be used like so:
 
 	obj->dead = 1;
-	smp_mb__before_atomic_dec();
+	smp_mb__before_atomic();
 	atomic_dec(&obj->ref_count);
 
 It makes sure that all memory operations preceding the atomic_dec()
@@ -302,14 +300,12 @@ operation.  In the above example, it guarantees that the assignment of
 "1" to obj->dead will be globally visible to other cpus before the
 atomic counter decrement.
 
-Without the explicit smp_mb__before_atomic_dec() call, the
+Without the explicit smp_mb__before_atomic() call, the
 implementation could legally allow the atomic counter update visible
 to other cpus before the "obj->dead = 1;" assignment.
 
-The other three interfaces listed are used to provide explicit
-ordering with respect to memory operations after an atomic_dec() call
-(smp_mb__after_atomic_dec()) and around atomic_inc() calls
-(smp_mb__{before,after}_atomic_inc()).
+The other interface listed is used to provide explicit
+ordering with respect to memory operations after an atomic_dec() call.
 
 A missing memory barrier in the cases where they are required by the
 atomic_t implementation above can have disastrous results.  Here is
diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index 556f951..79d359f 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -1583,10 +1583,8 @@ There are some more advanced barrier functions:
      insert anything more than a compiler barrier in a UP compilation.
 
 
- (*) smp_mb__before_atomic_dec();
- (*) smp_mb__after_atomic_dec();
- (*) smp_mb__before_atomic_inc();
- (*) smp_mb__after_atomic_inc();
+ (*) smp_mb__before_atomic();
+ (*) smp_mb__after_atomic();
 
      These are for use with atomic add, subtract, increment and decrement
      functions that don't return a value, especially when used for reference
@@ -1596,7 +1594,7 @@ There are some more advanced barrier functions:
      and then decrements the object's reference count:
 
 	obj->dead = 1;
-	smp_mb__before_atomic_dec();
+	smp_mb__before_atomic();
 	atomic_dec(&obj->ref_count);
 
      This makes sure that the death mark on the object is perceived to be set
@@ -2287,8 +2285,7 @@ With these the appropriate explicit memory barrier should be used if necessary
 
 
 The following also do _not_ imply memory barriers, and so may require explicit
-memory barriers under some circumstances (smp_mb__before_atomic_dec() for
-instance):
+memory barriers under some circumstances (smp_mb__before_atomic() for instance):
 
 	atomic_add();
 	atomic_sub();
diff --git a/arch/alpha/include/asm/atomic.h b/arch/alpha/include/asm/atomic.h
index 78b03ef..0bb2641 100644
--- a/arch/alpha/include/asm/atomic.h
+++ b/arch/alpha/include/asm/atomic.h
@@ -292,9 +292,7 @@ static inline long atomic64_dec_if_positive(atomic64_t *v)
 #define atomic_dec(v) atomic_sub(1,(v))
 #define atomic64_dec(v) atomic64_sub(1,(v))
 
-#define smp_mb__before_atomic_dec()	smp_mb()
-#define smp_mb__after_atomic_dec()	smp_mb()
-#define smp_mb__before_atomic_inc()	smp_mb()
-#define smp_mb__after_atomic_inc()	smp_mb()
+#define smp_mb__before_atomic()	smp_mb()
+#define smp_mb__after_atomic()		smp_mb()
 
 #endif /* _ALPHA_ATOMIC_H */
diff --git a/arch/arc/include/asm/atomic.h b/arch/arc/include/asm/atomic.h
index 03e494f..7047a3b 100644
--- a/arch/arc/include/asm/atomic.h
+++ b/arch/arc/include/asm/atomic.h
@@ -190,10 +190,8 @@ static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
 
 #endif /* !CONFIG_ARC_HAS_LLSC */
 
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
+#define smp_mb__before_atomic()	barrier()
+#define smp_mb__after_atomic()		barrier()
 
 /**
  * __atomic_add_unless - add unless the number is a given value
diff --git a/arch/arm/include/asm/atomic.h b/arch/arm/include/asm/atomic.h
index 9a92fd7..81918fa 100644
--- a/arch/arm/include/asm/atomic.h
+++ b/arch/arm/include/asm/atomic.h
@@ -241,10 +241,8 @@ static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 
 #define atomic_add_negative(i,v) (atomic_add_return(i, v) < 0)
 
-#define smp_mb__before_atomic_dec()	smp_mb()
-#define smp_mb__after_atomic_dec()	smp_mb()
-#define smp_mb__before_atomic_inc()	smp_mb()
-#define smp_mb__after_atomic_inc()	smp_mb()
+#define smp_mb__before_atomic()	smp_mb()
+#define smp_mb__after_atomic()		smp_mb()
 
 #ifndef CONFIG_GENERIC_ATOMIC64
 typedef struct {
diff --git a/arch/arm64/include/asm/atomic.h b/arch/arm64/include/asm/atomic.h
index 0237f08..253db51 100644
--- a/arch/arm64/include/asm/atomic.h
+++ b/arch/arm64/include/asm/atomic.h
@@ -152,10 +152,8 @@ static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 
 #define atomic_add_negative(i,v) (atomic_add_return(i, v) < 0)
 
-#define smp_mb__before_atomic_dec()	smp_mb()
-#define smp_mb__after_atomic_dec()	smp_mb()
-#define smp_mb__before_atomic_inc()	smp_mb()
-#define smp_mb__after_atomic_inc()	smp_mb()
+#define smp_mb__before_atomic()	smp_mb()
+#define smp_mb__after_atomic()		smp_mb()
 
 /*
  * 64-bit atomic operations.
diff --git a/arch/avr32/include/asm/atomic.h b/arch/avr32/include/asm/atomic.h
index 6140727..843233d 100644
--- a/arch/avr32/include/asm/atomic.h
+++ b/arch/avr32/include/asm/atomic.h
@@ -183,9 +183,7 @@ static inline int atomic_sub_if_positive(int i, atomic_t *v)
 
 #define atomic_dec_if_positive(v) atomic_sub_if_positive(1, v)
 
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
+#define smp_mb__before_atomic()	barrier()
+#define smp_mb__after_atomic()		barrier()
 
 #endif /*  __ASM_AVR32_ATOMIC_H */
diff --git a/arch/cris/include/asm/atomic.h b/arch/cris/include/asm/atomic.h
index 1056a5d..c1157a6 100644
--- a/arch/cris/include/asm/atomic.h
+++ b/arch/cris/include/asm/atomic.h
@@ -152,9 +152,7 @@ static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 }
 
 /* Atomic operations are already serializing */
-#define smp_mb__before_atomic_dec()    barrier()
-#define smp_mb__after_atomic_dec()     barrier()
-#define smp_mb__before_atomic_inc()    barrier()
-#define smp_mb__after_atomic_inc()     barrier()
+#define smp_mb__before_atomic()    	barrier()
+#define smp_mb__after_atomic()     	barrier()
 
 #endif
diff --git a/arch/frv/include/asm/atomic.h b/arch/frv/include/asm/atomic.h
index b86329d..7363aa2 100644
--- a/arch/frv/include/asm/atomic.h
+++ b/arch/frv/include/asm/atomic.h
@@ -30,10 +30,8 @@
  */
 
 /* Atomic operations are already serializing */
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
+#define smp_mb__before_atomic()	barrier()
+#define smp_mb__after_atomic()		barrier()
 
 #define ATOMIC_INIT(i)		{ (i) }
 #define atomic_read(v)		(*(volatile int *)&(v)->counter)
diff --git a/arch/hexagon/include/asm/atomic.h b/arch/hexagon/include/asm/atomic.h
index 17dc637..c2b9faf 100644
--- a/arch/hexagon/include/asm/atomic.h
+++ b/arch/hexagon/include/asm/atomic.h
@@ -176,9 +176,7 @@ static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 #define atomic_inc_return(v) (atomic_add_return(1, v))
 #define atomic_dec_return(v) (atomic_sub_return(1, v))
 
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
+#define smp_mb__before_atomic()	barrier()
+#define smp_mb__after_atomic()		barrier()
 
 #endif
diff --git a/arch/ia64/include/asm/atomic.h b/arch/ia64/include/asm/atomic.h
index 6e6fe18..7056f1c 100644
--- a/arch/ia64/include/asm/atomic.h
+++ b/arch/ia64/include/asm/atomic.h
@@ -209,9 +209,7 @@ atomic64_add_negative (__s64 i, atomic64_t *v)
 #define atomic64_dec(v)			atomic64_sub(1, (v))
 
 /* Atomic operations are already serializing */
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
+#define smp_mb__before_atomic()	barrier()
+#define smp_mb__after_atomic()		barrier()
 
 #endif /* _ASM_IA64_ATOMIC_H */
diff --git a/arch/m32r/include/asm/atomic.h b/arch/m32r/include/asm/atomic.h
index 0d81697..e58a59c 100644
--- a/arch/m32r/include/asm/atomic.h
+++ b/arch/m32r/include/asm/atomic.h
@@ -309,9 +309,7 @@ static __inline__ void atomic_set_mask(unsigned long  mask, atomic_t *addr)
 }
 
 /* Atomic operations are already serializing on m32r */
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
+#define smp_mb__before_atomic()	barrier()
+#define smp_mb__after_atomic()		barrier()
 
 #endif	/* _ASM_M32R_ATOMIC_H */
diff --git a/arch/m68k/include/asm/atomic.h b/arch/m68k/include/asm/atomic.h
index f4e32de..9eb13e4 100644
--- a/arch/m68k/include/asm/atomic.h
+++ b/arch/m68k/include/asm/atomic.h
@@ -211,9 +211,7 @@ static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
 
 
 /* Atomic operations are already serializing */
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
+#define smp_mb__before_atomic()	barrier()
+#define smp_mb__after_atomic()		barrier()
 
 #endif /* __ARCH_M68K_ATOMIC __ */
diff --git a/arch/metag/include/asm/atomic.h b/arch/metag/include/asm/atomic.h
index 307ecd2..820be65 100644
--- a/arch/metag/include/asm/atomic.h
+++ b/arch/metag/include/asm/atomic.h
@@ -39,10 +39,8 @@
 
 #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
+#define smp_mb__before_atomic()	barrier()
+#define smp_mb__after_atomic()		barrier()
 
 #endif
 
diff --git a/arch/mips/include/asm/atomic.h b/arch/mips/include/asm/atomic.h
index e8eb3d5..9b8fa66 100644
--- a/arch/mips/include/asm/atomic.h
+++ b/arch/mips/include/asm/atomic.h
@@ -765,9 +765,7 @@ static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
  * atomic*_return operations are serializing but not the non-*_return
  * versions.
  */
-#define smp_mb__before_atomic_dec()	smp_mb__before_llsc()
-#define smp_mb__after_atomic_dec()	smp_llsc_mb()
-#define smp_mb__before_atomic_inc()	smp_mb__before_llsc()
-#define smp_mb__after_atomic_inc()	smp_llsc_mb()
+#define smp_mb__before_atomic()	smp_mb__before_llsc()
+#define smp_mb__after_atomic()		smp_llsc_mb()
 
 #endif /* _ASM_ATOMIC_H */
diff --git a/arch/mn10300/include/asm/atomic.h b/arch/mn10300/include/asm/atomic.h
index 975e184..223c3e9 100644
--- a/arch/mn10300/include/asm/atomic.h
+++ b/arch/mn10300/include/asm/atomic.h
@@ -235,10 +235,8 @@ static inline void atomic_set_mask(unsigned long mask, unsigned long *addr)
 }
 
 /* Atomic operations are already serializing on MN10300??? */
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
+#define smp_mb__before_atomic()	barrier()
+#define smp_mb__after_atomic()		barrier()
 
 #endif /* __KERNEL__ */
 #endif /* CONFIG_SMP */
diff --git a/arch/parisc/include/asm/atomic.h b/arch/parisc/include/asm/atomic.h
index 472886c..d752a3a 100644
--- a/arch/parisc/include/asm/atomic.h
+++ b/arch/parisc/include/asm/atomic.h
@@ -143,10 +143,8 @@ static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
 
 #define ATOMIC_INIT(i)	{ (i) }
 
-#define smp_mb__before_atomic_dec()	smp_mb()
-#define smp_mb__after_atomic_dec()	smp_mb()
-#define smp_mb__before_atomic_inc()	smp_mb()
-#define smp_mb__after_atomic_inc()	smp_mb()
+#define smp_mb__before_atomic()	smp_mb()
+#define smp_mb__after_atomic()		smp_mb()
 
 #ifdef CONFIG_64BIT
 
diff --git a/arch/powerpc/include/asm/atomic.h b/arch/powerpc/include/asm/atomic.h
index e3b1d41..24c0605 100644
--- a/arch/powerpc/include/asm/atomic.h
+++ b/arch/powerpc/include/asm/atomic.h
@@ -270,10 +270,8 @@ static __inline__ int atomic_dec_if_positive(atomic_t *v)
 }
 #define atomic_dec_if_positive atomic_dec_if_positive
 
-#define smp_mb__before_atomic_dec()     smp_mb()
-#define smp_mb__after_atomic_dec()      smp_mb()
-#define smp_mb__before_atomic_inc()     smp_mb()
-#define smp_mb__after_atomic_inc()      smp_mb()
+#define smp_mb__before_atomic()     smp_mb()
+#define smp_mb__after_atomic()      smp_mb()
 
 #ifdef __powerpc64__
 
diff --git a/arch/powerpc/kernel/crash.c b/arch/powerpc/kernel/crash.c
index 18d7c80..51dbace 100644
--- a/arch/powerpc/kernel/crash.c
+++ b/arch/powerpc/kernel/crash.c
@@ -81,7 +81,7 @@ void crash_ipi_callback(struct pt_regs *regs)
 	}
 
 	atomic_inc(&cpus_in_crash);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 
 	/*
 	 * Starting the kdump boot.
diff --git a/arch/s390/include/asm/atomic.h b/arch/s390/include/asm/atomic.h
index 1d47061..5aace96 100644
--- a/arch/s390/include/asm/atomic.h
+++ b/arch/s390/include/asm/atomic.h
@@ -412,9 +412,7 @@ static inline long long atomic64_dec_if_positive(atomic64_t *v)
 #define atomic64_dec_and_test(_v)	(atomic64_sub_return(1, _v) == 0)
 #define atomic64_inc_not_zero(v)	atomic64_add_unless((v), 1, 0)
 
-#define smp_mb__before_atomic_dec()	smp_mb()
-#define smp_mb__after_atomic_dec()	smp_mb()
-#define smp_mb__before_atomic_inc()	smp_mb()
-#define smp_mb__after_atomic_inc()	smp_mb()
+#define smp_mb__before_atomic()	smp_mb()
+#define smp_mb__after_atomic()		smp_mb()
 
 #endif /* __ARCH_S390_ATOMIC__  */
diff --git a/arch/sh/include/asm/atomic.h b/arch/sh/include/asm/atomic.h
index f4c1c20..00745a9 100644
--- a/arch/sh/include/asm/atomic.h
+++ b/arch/sh/include/asm/atomic.h
@@ -62,9 +62,7 @@ static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 	return c;
 }
 
-#define smp_mb__before_atomic_dec()	smp_mb()
-#define smp_mb__after_atomic_dec()	smp_mb()
-#define smp_mb__before_atomic_inc()	smp_mb()
-#define smp_mb__after_atomic_inc()	smp_mb()
+#define smp_mb__before_atomic()	smp_mb()
+#define smp_mb__after_atomic()		smp_mb()
 
 #endif /* __ASM_SH_ATOMIC_H */
diff --git a/arch/sparc/include/asm/atomic_32.h b/arch/sparc/include/asm/atomic_32.h
index 905832a..ee960cd 100644
--- a/arch/sparc/include/asm/atomic_32.h
+++ b/arch/sparc/include/asm/atomic_32.h
@@ -53,9 +53,7 @@ extern void atomic_set(atomic_t *, int);
 #define atomic_sub_and_test(i, v) (atomic_sub_return(i, v) == 0)
 
 /* Atomic operations are already serializing */
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
+#define smp_mb__before_atomic()	barrier()
+#define smp_mb__after_atomic()		barrier()
 
 #endif /* !(__ARCH_SPARC_ATOMIC__) */
diff --git a/arch/sparc/include/asm/atomic_64.h b/arch/sparc/include/asm/atomic_64.h
index be56a24..5d1c9dc 100644
--- a/arch/sparc/include/asm/atomic_64.h
+++ b/arch/sparc/include/asm/atomic_64.h
@@ -109,9 +109,7 @@ static inline long atomic64_add_unless(atomic64_t *v, long a, long u)
 extern long atomic64_dec_if_positive(atomic64_t *v);
 
 /* Atomic operations are already serializing */
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
+#define smp_mb__before_atomic()	barrier()
+#define smp_mb__after_atomic()		barrier()
 
 #endif /* !(__ARCH_SPARC64_ATOMIC__) */
diff --git a/arch/tile/include/asm/atomic_32.h b/arch/tile/include/asm/atomic_32.h
index 1ad4a1f..6b9c8d9 100644
--- a/arch/tile/include/asm/atomic_32.h
+++ b/arch/tile/include/asm/atomic_32.h
@@ -175,10 +175,8 @@ static inline void atomic64_set(atomic64_t *v, long long n)
  * But after the word is updated, the routine issues an "mf" before returning,
  * and since it's a function call, we don't even need a compiler barrier.
  */
-#define smp_mb__before_atomic_dec()	smp_mb()
-#define smp_mb__before_atomic_inc()	smp_mb()
-#define smp_mb__after_atomic_dec()	do { } while (0)
-#define smp_mb__after_atomic_inc()	do { } while (0)
+#define smp_mb__before_atomic()	smp_mb()
+#define smp_mb__after_atomic()		do { } while (0)
 
 #endif /* !__ASSEMBLY__ */
 
diff --git a/arch/tile/include/asm/atomic_64.h b/arch/tile/include/asm/atomic_64.h
index ad220ee..0264586 100644
--- a/arch/tile/include/asm/atomic_64.h
+++ b/arch/tile/include/asm/atomic_64.h
@@ -106,10 +106,8 @@ static inline long atomic64_add_unless(atomic64_t *v, long a, long u)
 #define atomic64_inc_not_zero(v)	atomic64_add_unless((v), 1, 0)
 
 /* Atomic dec and inc don't implement barrier, so provide them if needed. */
-#define smp_mb__before_atomic_dec()	smp_mb()
-#define smp_mb__after_atomic_dec()	smp_mb()
-#define smp_mb__before_atomic_inc()	smp_mb()
-#define smp_mb__after_atomic_inc()	smp_mb()
+#define smp_mb__before_atomic()	smp_mb()
+#define smp_mb__after_atomic()		smp_mb()
 
 /* Define this to indicate that cmpxchg is an efficient operation. */
 #define __HAVE_ARCH_CMPXCHG
diff --git a/arch/tile/include/asm/bitops_32.h b/arch/tile/include/asm/bitops_32.h
index 386865a..9980d8c 100644
--- a/arch/tile/include/asm/bitops_32.h
+++ b/arch/tile/include/asm/bitops_32.h
@@ -121,7 +121,7 @@ static inline int test_and_change_bit(unsigned nr,
 	return (_atomic_xor(addr, mask) & mask) != 0;
 }
 
-/* See discussion at smp_mb__before_atomic_dec() in <asm/atomic_32.h>. */
+/* See discussion at smp_mb__before_atomic() in <asm/atomic_32.h>. */
 #define smp_mb__before_clear_bit()	smp_mb()
 #define smp_mb__after_clear_bit()	do {} while (0)
 
diff --git a/arch/x86/include/asm/atomic.h b/arch/x86/include/asm/atomic.h
index b17f4f4..0401a3d 100644
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -244,10 +244,8 @@ static inline void atomic_or_long(unsigned long *v1, unsigned long v2)
 		     : "memory")
 
 /* Atomic operations are already serializing on x86 */
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
+#define smp_mb__before_atomic()	barrier()
+#define smp_mb__after_atomic()		barrier()
 
 #ifdef CONFIG_X86_32
 # include <asm/atomic64_32.h>
diff --git a/arch/xtensa/include/asm/atomic.h b/arch/xtensa/include/asm/atomic.h
index e7fb447..f026301 100644
--- a/arch/xtensa/include/asm/atomic.h
+++ b/arch/xtensa/include/asm/atomic.h
@@ -388,10 +388,8 @@ static inline void atomic_set_mask(unsigned int mask, atomic_t *v)
 }
 
 /* Atomic operations are already serializing */
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
+#define smp_mb__before_atomic()	barrier()
+#define smp_mb__after_atomic()		barrier()
 
 #endif /* __KERNEL__ */
 
diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index ae098a2..eee55c1 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -105,7 +105,7 @@ static bool genpd_sd_counter_dec(struct generic_pm_domain *genpd)
 static void genpd_sd_counter_inc(struct generic_pm_domain *genpd)
 {
 	atomic_inc(&genpd->sd_count);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 }
 
 static void genpd_acquire_lock(struct generic_pm_domain *genpd)
diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
index cb6654b..73fe2f8 100644
--- a/drivers/cpuidle/coupled.c
+++ b/drivers/cpuidle/coupled.c
@@ -159,7 +159,7 @@ void cpuidle_coupled_parallel_barrier(struct cpuidle_device *dev, atomic_t *a)
 {
 	int n = dev->coupled->online_count;
 
-	smp_mb__before_atomic_inc();
+	smp_mb__before_atomic();
 	atomic_inc(a);
 
 	while (atomic_read(a) < n)
diff --git a/drivers/gpu/drm/drm_irq.c b/drivers/gpu/drm/drm_irq.c
index c2676b5..ec5c3f4 100644
--- a/drivers/gpu/drm/drm_irq.c
+++ b/drivers/gpu/drm/drm_irq.c
@@ -156,7 +156,7 @@ static void vblank_disable_and_save(struct drm_device *dev, int crtc)
 	 */
 	if ((vblrc > 0) && (abs64(diff_ns) > 1000000)) {
 		atomic_inc(&dev->vblank[crtc].count);
-		smp_mb__after_atomic_inc();
+		smp_mb__after_atomic();
 	}
 
 	/* Invalidate all timestamps while vblank irq's are off. */
@@ -864,9 +864,9 @@ static void drm_update_vblank_count(struct drm_device *dev, int crtc)
 		vblanktimestamp(dev, crtc, tslot) = t_vblank;
 	}
 
-	smp_mb__before_atomic_inc();
+	smp_mb__before_atomic();
 	atomic_add(diff, &dev->vblank[crtc].count);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 }
 
 /**
@@ -1330,9 +1330,9 @@ bool drm_handle_vblank(struct drm_device *dev, int crtc)
 		/* Increment cooked vblank count. This also atomically commits
 		 * the timestamp computed above.
 		 */
-		smp_mb__before_atomic_inc();
+		smp_mb__before_atomic();
 		atomic_inc(&dev->vblank[crtc].count);
-		smp_mb__after_atomic_inc();
+		smp_mb__after_atomic();
 	} else {
 		DRM_DEBUG("crtc %d: Redundant vblirq ignored. diff_ns = %d\n",
 			  crtc, (int) diff_ns);
diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index f98ba4e..0b99de9 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -2157,7 +2157,7 @@ static void i915_error_work_func(struct work_struct *work)
 			 * updates before
 			 * the counter increment.
 			 */
-			smp_mb__before_atomic_inc();
+			smp_mb__before_atomic();
 			atomic_inc(&dev_priv->gpu_error.reset_counter);
 
 			kobject_uevent_env(&dev->primary->kdev->kobj,
diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 82c9c5d..d2ebcf3 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -828,7 +828,7 @@ static inline bool cached_dev_get(struct cached_dev *dc)
 		return false;
 
 	/* Paired with the mb in cached_dev_attach */
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 	return true;
 }
 
diff --git a/drivers/md/bcache/closure.h b/drivers/md/bcache/closure.h
index 7ef7461..a08e3ee 100644
--- a/drivers/md/bcache/closure.h
+++ b/drivers/md/bcache/closure.h
@@ -243,7 +243,7 @@ static inline void set_closure_fn(struct closure *cl, closure_fn *fn,
 	cl->fn = fn;
 	cl->wq = wq;
 	/* between atomic_dec() in closure_put() */
-	smp_mb__before_atomic_dec();
+	smp_mb__before_atomic();
 }
 
 static inline void closure_queue(struct closure *cl)
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index ebddef5..4d84598 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -642,7 +642,7 @@ static void free_pending_exception(struct dm_snap_pending_exception *pe)
 	struct dm_snapshot *s = pe->snap;
 
 	mempool_free(pe, s->pending_pool);
-	smp_mb__before_atomic_dec();
+	smp_mb__before_atomic();
 	atomic_dec(&s->pending_exceptions_count);
 }
 
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 3b0d431..d22768e 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -1858,10 +1858,10 @@ void bnx2x_sp_event(struct bnx2x_fastpath *fp, union eth_rx_cqe *rr_cqe)
 		return;
 #endif
 
-	smp_mb__before_atomic_inc();
+	smp_mb__before_atomic();
 	atomic_inc(&bp->cq_spq_left);
 	/* push the change in bp->spq_left and towards the memory */
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 
 	DP(BNX2X_MSG_SP, "bp->cq_spq_left %x\n", atomic_read(&bp->cq_spq_left));
 
@@ -5500,7 +5500,7 @@ next_spqe:
 		spqe_cnt++;
 	} /* for */
 
-	smp_mb__before_atomic_inc();
+	smp_mb__before_atomic();
 	atomic_add(spqe_cnt, &bp->eq_spq_left);
 
 	bp->eq_cons = sw_cons;
@@ -13875,9 +13875,9 @@ static int bnx2x_drv_ctl(struct net_device *dev, struct drv_ctl_info *ctl)
 	case DRV_CTL_RET_L2_SPQ_CREDIT_CMD: {
 		int count = ctl->data.credit.credit_count;
 
-		smp_mb__before_atomic_inc();
+		smp_mb__before_atomic();
 		atomic_add(count, &bp->cq_spq_left);
-		smp_mb__after_atomic_inc();
+		smp_mb__after_atomic();
 		break;
 	}
 	case DRV_CTL_ULP_REGISTER_CMD: {
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index c886ad1..73ab75d 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -951,7 +951,7 @@ static int tcm_loop_port_link(
 	struct tcm_loop_hba *tl_hba = tl_tpg->tl_hba;
 
 	atomic_inc(&tl_tpg->tl_tpg_port_count);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 	/*
 	 * Add Linux/SCSI struct scsi_device by HCTL
 	 */
@@ -986,7 +986,7 @@ static void tcm_loop_port_unlink(
 	scsi_device_put(sd);
 
 	atomic_dec(&tl_tpg->tl_tpg_port_count);
-	smp_mb__after_atomic_dec();
+	smp_mb__after_atomic();
 
 	pr_debug("TCM_Loop_ConfigFS: Port Unlink Successful\n");
 }
diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index fcbe612..0b79b85 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -393,7 +393,7 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 					continue;
 
 				atomic_inc(&tg_pt_gp->tg_pt_gp_ref_cnt);
-				smp_mb__after_atomic_inc();
+				smp_mb__after_atomic();
 
 				spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
 
@@ -404,7 +404,7 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 
 				spin_lock(&dev->t10_alua.tg_pt_gps_lock);
 				atomic_dec(&tg_pt_gp->tg_pt_gp_ref_cnt);
-				smp_mb__after_atomic_dec();
+				smp_mb__after_atomic();
 				break;
 			}
 			spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
@@ -990,7 +990,7 @@ static void core_alua_do_transition_tg_pt_work(struct work_struct *work)
 		 * TARGET PORT GROUPS command
 		 */
 		atomic_inc(&mem->tg_pt_gp_mem_ref_cnt);
-		smp_mb__after_atomic_inc();
+		smp_mb__after_atomic();
 		spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
 
 		spin_lock_bh(&port->sep_alua_lock);
@@ -1020,7 +1020,7 @@ static void core_alua_do_transition_tg_pt_work(struct work_struct *work)
 
 		spin_lock(&tg_pt_gp->tg_pt_gp_lock);
 		atomic_dec(&mem->tg_pt_gp_mem_ref_cnt);
-		smp_mb__after_atomic_dec();
+		smp_mb__after_atomic();
 	}
 	spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
 	/*
@@ -1054,7 +1054,7 @@ static void core_alua_do_transition_tg_pt_work(struct work_struct *work)
 		core_alua_dump_state(tg_pt_gp->tg_pt_gp_alua_pending_state));
 	spin_lock(&dev->t10_alua.tg_pt_gps_lock);
 	atomic_dec(&tg_pt_gp->tg_pt_gp_ref_cnt);
-	smp_mb__after_atomic_dec();
+	smp_mb__after_atomic();
 	spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
 
 	if (tg_pt_gp->tg_pt_gp_transition_complete)
@@ -1116,7 +1116,7 @@ static int core_alua_do_transition_tg_pt(
 	 */
 	spin_lock(&dev->t10_alua.tg_pt_gps_lock);
 	atomic_inc(&tg_pt_gp->tg_pt_gp_ref_cnt);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 	spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
 
 	if (!explicit && tg_pt_gp->tg_pt_gp_implicit_trans_secs) {
@@ -1159,7 +1159,7 @@ int core_alua_do_port_transition(
 	spin_lock(&local_lu_gp_mem->lu_gp_mem_lock);
 	lu_gp = local_lu_gp_mem->lu_gp;
 	atomic_inc(&lu_gp->lu_gp_ref_cnt);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 	spin_unlock(&local_lu_gp_mem->lu_gp_mem_lock);
 	/*
 	 * For storage objects that are members of the 'default_lu_gp',
@@ -1176,7 +1176,7 @@ int core_alua_do_port_transition(
 		rc = core_alua_do_transition_tg_pt(l_tg_pt_gp,
 						   new_state, explicit);
 		atomic_dec(&lu_gp->lu_gp_ref_cnt);
-		smp_mb__after_atomic_dec();
+		smp_mb__after_atomic();
 		return rc;
 	}
 	/*
@@ -1190,7 +1190,7 @@ int core_alua_do_port_transition(
 
 		dev = lu_gp_mem->lu_gp_mem_dev;
 		atomic_inc(&lu_gp_mem->lu_gp_mem_ref_cnt);
-		smp_mb__after_atomic_inc();
+		smp_mb__after_atomic();
 		spin_unlock(&lu_gp->lu_gp_lock);
 
 		spin_lock(&dev->t10_alua.tg_pt_gps_lock);
@@ -1219,7 +1219,7 @@ int core_alua_do_port_transition(
 				tg_pt_gp->tg_pt_gp_alua_nacl = NULL;
 			}
 			atomic_inc(&tg_pt_gp->tg_pt_gp_ref_cnt);
-			smp_mb__after_atomic_inc();
+			smp_mb__after_atomic();
 			spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
 			/*
 			 * core_alua_do_transition_tg_pt() will always return
@@ -1230,7 +1230,7 @@ int core_alua_do_port_transition(
 
 			spin_lock(&dev->t10_alua.tg_pt_gps_lock);
 			atomic_dec(&tg_pt_gp->tg_pt_gp_ref_cnt);
-			smp_mb__after_atomic_dec();
+			smp_mb__after_atomic();
 			if (rc)
 				break;
 		}
@@ -1238,7 +1238,7 @@ int core_alua_do_port_transition(
 
 		spin_lock(&lu_gp->lu_gp_lock);
 		atomic_dec(&lu_gp_mem->lu_gp_mem_ref_cnt);
-		smp_mb__after_atomic_dec();
+		smp_mb__after_atomic();
 	}
 	spin_unlock(&lu_gp->lu_gp_lock);
 
@@ -1252,7 +1252,7 @@ int core_alua_do_port_transition(
 	}
 
 	atomic_dec(&lu_gp->lu_gp_ref_cnt);
-	smp_mb__after_atomic_dec();
+	smp_mb__after_atomic();
 	return rc;
 }
 
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 26416c1..11d26fe 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -225,7 +225,7 @@ struct se_dev_entry *core_get_se_deve_from_rtpi(
 			continue;
 
 		atomic_inc(&deve->pr_ref_count);
-		smp_mb__after_atomic_inc();
+		smp_mb__after_atomic();
 		spin_unlock_irq(&nacl->device_list_lock);
 
 		return deve;
@@ -1396,7 +1396,7 @@ int core_dev_add_initiator_node_lun_acl(
 	spin_lock(&lun->lun_acl_lock);
 	list_add_tail(&lacl->lacl_list, &lun->lun_acl_list);
 	atomic_inc(&lun->lun_acl_count);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 	spin_unlock(&lun->lun_acl_lock);
 
 	pr_debug("%s_TPG[%hu]_LUN[%u->%u] - Added %s ACL for "
@@ -1430,7 +1430,7 @@ int core_dev_del_initiator_node_lun_acl(
 	spin_lock(&lun->lun_acl_lock);
 	list_del(&lacl->lacl_list);
 	atomic_dec(&lun->lun_acl_count);
-	smp_mb__after_atomic_dec();
+	smp_mb__after_atomic();
 	spin_unlock(&lun->lun_acl_lock);
 
 	core_disable_device_list_for_node(lun, NULL, lacl->mapped_lun,
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 9e0232c..7e6b857 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -323,7 +323,7 @@ static void iblock_bio_done(struct bio *bio, int err)
 		 * Bump the ib_bio_err_cnt and release bio.
 		 */
 		atomic_inc(&ibr->ib_bio_err_cnt);
-		smp_mb__after_atomic_inc();
+		smp_mb__after_atomic();
 	}
 
 	bio_put(bio);
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 3013287..df35786 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -675,7 +675,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 	spin_lock(&dev->se_port_lock);
 	list_for_each_entry_safe(port, port_tmp, &dev->dev_sep_list, sep_list) {
 		atomic_inc(&port->sep_tg_pt_ref_cnt);
-		smp_mb__after_atomic_inc();
+		smp_mb__after_atomic();
 		spin_unlock(&dev->se_port_lock);
 
 		spin_lock_bh(&port->sep_alua_lock);
@@ -710,7 +710,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 				continue;
 
 			atomic_inc(&deve_tmp->pr_ref_count);
-			smp_mb__after_atomic_inc();
+			smp_mb__after_atomic();
 			spin_unlock_bh(&port->sep_alua_lock);
 			/*
 			 * Grab a configfs group dependency that is released
@@ -723,9 +723,9 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 				pr_err("core_scsi3_lunacl_depend"
 						"_item() failed\n");
 				atomic_dec(&port->sep_tg_pt_ref_cnt);
-				smp_mb__after_atomic_dec();
+				smp_mb__after_atomic();
 				atomic_dec(&deve_tmp->pr_ref_count);
-				smp_mb__after_atomic_dec();
+				smp_mb__after_atomic();
 				goto out;
 			}
 			/*
@@ -740,9 +740,9 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 						sa_res_key, all_tg_pt, aptpl);
 			if (!pr_reg_atp) {
 				atomic_dec(&port->sep_tg_pt_ref_cnt);
-				smp_mb__after_atomic_dec();
+				smp_mb__after_atomic();
 				atomic_dec(&deve_tmp->pr_ref_count);
-				smp_mb__after_atomic_dec();
+				smp_mb__after_atomic();
 				core_scsi3_lunacl_undepend_item(deve_tmp);
 				goto out;
 			}
@@ -755,7 +755,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 
 		spin_lock(&dev->se_port_lock);
 		atomic_dec(&port->sep_tg_pt_ref_cnt);
-		smp_mb__after_atomic_dec();
+		smp_mb__after_atomic();
 	}
 	spin_unlock(&dev->se_port_lock);
 
@@ -1110,7 +1110,7 @@ static struct t10_pr_registration *__core_scsi3_locate_pr_reg(
 					continue;
 			}
 			atomic_inc(&pr_reg->pr_res_holders);
-			smp_mb__after_atomic_inc();
+			smp_mb__after_atomic();
 			spin_unlock(&pr_tmpl->registration_lock);
 			return pr_reg;
 		}
@@ -1125,7 +1125,7 @@ static struct t10_pr_registration *__core_scsi3_locate_pr_reg(
 			continue;
 
 		atomic_inc(&pr_reg->pr_res_holders);
-		smp_mb__after_atomic_inc();
+		smp_mb__after_atomic();
 		spin_unlock(&pr_tmpl->registration_lock);
 		return pr_reg;
 	}
@@ -1155,7 +1155,7 @@ static struct t10_pr_registration *core_scsi3_locate_pr_reg(
 static void core_scsi3_put_pr_reg(struct t10_pr_registration *pr_reg)
 {
 	atomic_dec(&pr_reg->pr_res_holders);
-	smp_mb__after_atomic_dec();
+	smp_mb__after_atomic();
 }
 
 static int core_scsi3_check_implicit_release(
@@ -1349,7 +1349,7 @@ static void core_scsi3_tpg_undepend_item(struct se_portal_group *tpg)
 			&tpg->tpg_group.cg_item);
 
 	atomic_dec(&tpg->tpg_pr_ref_count);
-	smp_mb__after_atomic_dec();
+	smp_mb__after_atomic();
 }
 
 static int core_scsi3_nodeacl_depend_item(struct se_node_acl *nacl)
@@ -1369,7 +1369,7 @@ static void core_scsi3_nodeacl_undepend_item(struct se_node_acl *nacl)
 
 	if (nacl->dynamic_node_acl) {
 		atomic_dec(&nacl->acl_pr_ref_count);
-		smp_mb__after_atomic_dec();
+		smp_mb__after_atomic();
 		return;
 	}
 
@@ -1377,7 +1377,7 @@ static void core_scsi3_nodeacl_undepend_item(struct se_node_acl *nacl)
 			&nacl->acl_group.cg_item);
 
 	atomic_dec(&nacl->acl_pr_ref_count);
-	smp_mb__after_atomic_dec();
+	smp_mb__after_atomic();
 }
 
 static int core_scsi3_lunacl_depend_item(struct se_dev_entry *se_deve)
@@ -1408,7 +1408,7 @@ static void core_scsi3_lunacl_undepend_item(struct se_dev_entry *se_deve)
 	 */
 	if (!lun_acl) {
 		atomic_dec(&se_deve->pr_ref_count);
-		smp_mb__after_atomic_dec();
+		smp_mb__after_atomic();
 		return;
 	}
 	nacl = lun_acl->se_lun_nacl;
@@ -1418,7 +1418,7 @@ static void core_scsi3_lunacl_undepend_item(struct se_dev_entry *se_deve)
 			&lun_acl->se_lun_group.cg_item);
 
 	atomic_dec(&se_deve->pr_ref_count);
-	smp_mb__after_atomic_dec();
+	smp_mb__after_atomic();
 }
 
 static sense_reason_t
@@ -1552,14 +1552,14 @@ core_scsi3_decode_spec_i_port(
 				continue;
 
 			atomic_inc(&tmp_tpg->tpg_pr_ref_count);
-			smp_mb__after_atomic_inc();
+			smp_mb__after_atomic();
 			spin_unlock(&dev->se_port_lock);
 
 			if (core_scsi3_tpg_depend_item(tmp_tpg)) {
 				pr_err(" core_scsi3_tpg_depend_item()"
 					" for tmp_tpg\n");
 				atomic_dec(&tmp_tpg->tpg_pr_ref_count);
-				smp_mb__after_atomic_dec();
+				smp_mb__after_atomic();
 				ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 				goto out_unmap;
 			}
@@ -1573,7 +1573,7 @@ core_scsi3_decode_spec_i_port(
 						tmp_tpg, i_str);
 			if (dest_node_acl) {
 				atomic_inc(&dest_node_acl->acl_pr_ref_count);
-				smp_mb__after_atomic_inc();
+				smp_mb__after_atomic();
 			}
 			spin_unlock_irq(&tmp_tpg->acl_node_lock);
 
@@ -1587,7 +1587,7 @@ core_scsi3_decode_spec_i_port(
 				pr_err("configfs_depend_item() failed"
 					" for dest_node_acl->acl_group\n");
 				atomic_dec(&dest_node_acl->acl_pr_ref_count);
-				smp_mb__after_atomic_dec();
+				smp_mb__after_atomic();
 				core_scsi3_tpg_undepend_item(tmp_tpg);
 				ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 				goto out_unmap;
@@ -1647,7 +1647,7 @@ core_scsi3_decode_spec_i_port(
 			pr_err("core_scsi3_lunacl_depend_item()"
 					" failed\n");
 			atomic_dec(&dest_se_deve->pr_ref_count);
-			smp_mb__after_atomic_dec();
+			smp_mb__after_atomic();
 			core_scsi3_nodeacl_undepend_item(dest_node_acl);
 			core_scsi3_tpg_undepend_item(dest_tpg);
 			ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
@@ -3168,14 +3168,14 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 			continue;
 
 		atomic_inc(&dest_se_tpg->tpg_pr_ref_count);
-		smp_mb__after_atomic_inc();
+		smp_mb__after_atomic();
 		spin_unlock(&dev->se_port_lock);
 
 		if (core_scsi3_tpg_depend_item(dest_se_tpg)) {
 			pr_err("core_scsi3_tpg_depend_item() failed"
 				" for dest_se_tpg\n");
 			atomic_dec(&dest_se_tpg->tpg_pr_ref_count);
-			smp_mb__after_atomic_dec();
+			smp_mb__after_atomic();
 			ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 			goto out_put_pr_reg;
 		}
@@ -3273,7 +3273,7 @@ after_iport_check:
 				initiator_str);
 	if (dest_node_acl) {
 		atomic_inc(&dest_node_acl->acl_pr_ref_count);
-		smp_mb__after_atomic_inc();
+		smp_mb__after_atomic();
 	}
 	spin_unlock_irq(&dest_se_tpg->acl_node_lock);
 
@@ -3289,7 +3289,7 @@ after_iport_check:
 		pr_err("core_scsi3_nodeacl_depend_item() for"
 			" dest_node_acl\n");
 		atomic_dec(&dest_node_acl->acl_pr_ref_count);
-		smp_mb__after_atomic_dec();
+		smp_mb__after_atomic();
 		dest_node_acl = NULL;
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out;
@@ -3314,7 +3314,7 @@ after_iport_check:
 	if (core_scsi3_lunacl_depend_item(dest_se_deve)) {
 		pr_err("core_scsi3_lunacl_depend_item() failed\n");
 		atomic_dec(&dest_se_deve->pr_ref_count);
-		smp_mb__after_atomic_dec();
+		smp_mb__after_atomic();
 		dest_se_deve = NULL;
 		ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		goto out;
@@ -3880,7 +3880,7 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 		add_desc_len = 0;
 
 		atomic_inc(&pr_reg->pr_res_holders);
-		smp_mb__after_atomic_inc();
+		smp_mb__after_atomic();
 		spin_unlock(&pr_tmpl->registration_lock);
 		/*
 		 * Determine expected length of $FABRIC_MOD specific
@@ -3894,7 +3894,7 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 				" out of buffer: %d\n", cmd->data_length);
 			spin_lock(&pr_tmpl->registration_lock);
 			atomic_dec(&pr_reg->pr_res_holders);
-			smp_mb__after_atomic_dec();
+			smp_mb__after_atomic();
 			break;
 		}
 		/*
@@ -3956,7 +3956,7 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 
 		spin_lock(&pr_tmpl->registration_lock);
 		atomic_dec(&pr_reg->pr_res_holders);
-		smp_mb__after_atomic_dec();
+		smp_mb__after_atomic();
 		/*
 		 * Set the ADDITIONAL DESCRIPTOR LENGTH
 		 */
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 789aa9e..2179fee 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -736,7 +736,7 @@ void target_qf_do_work(struct work_struct *work)
 	list_for_each_entry_safe(cmd, cmd_tmp, &qf_cmd_list, se_qf_node) {
 		list_del(&cmd->se_qf_node);
 		atomic_dec(&dev->dev_qf_count);
-		smp_mb__after_atomic_dec();
+		smp_mb__after_atomic();
 
 		pr_debug("Processing %s cmd: %p QUEUE_FULL in work queue"
 			" context: %s\n", cmd->se_tfo->get_fabric_name(), cmd,
@@ -1149,7 +1149,7 @@ transport_check_alloc_task_attr(struct se_cmd *cmd)
 	 * Dormant to Active status.
 	 */
 	cmd->se_ordered_id = atomic_inc_return(&dev->dev_ordered_id);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 	pr_debug("Allocated se_ordered_id: %u for Task Attr: 0x%02x on %s\n",
 			cmd->se_ordered_id, cmd->sam_task_attr,
 			dev->transport->name);
@@ -1706,7 +1706,7 @@ static bool target_handle_task_attr(struct se_cmd *cmd)
 		return false;
 	case MSG_ORDERED_TAG:
 		atomic_inc(&dev->dev_ordered_sync);
-		smp_mb__after_atomic_inc();
+		smp_mb__after_atomic();
 
 		pr_debug("Added ORDERED for CDB: 0x%02x to ordered list, "
 			 " se_ordered_id: %u\n",
@@ -1724,7 +1724,7 @@ static bool target_handle_task_attr(struct se_cmd *cmd)
 		 * For SIMPLE and UNTAGGED Task Attribute commands
 		 */
 		atomic_inc(&dev->simple_cmds);
-		smp_mb__after_atomic_inc();
+		smp_mb__after_atomic();
 		break;
 	}
 
@@ -1829,7 +1829,7 @@ static void transport_complete_task_attr(struct se_cmd *cmd)
 
 	if (cmd->sam_task_attr == MSG_SIMPLE_TAG) {
 		atomic_dec(&dev->simple_cmds);
-		smp_mb__after_atomic_dec();
+		smp_mb__after_atomic();
 		dev->dev_cur_ordered_id++;
 		pr_debug("Incremented dev->dev_cur_ordered_id: %u for"
 			" SIMPLE: %u\n", dev->dev_cur_ordered_id,
@@ -1841,7 +1841,7 @@ static void transport_complete_task_attr(struct se_cmd *cmd)
 			cmd->se_ordered_id);
 	} else if (cmd->sam_task_attr == MSG_ORDERED_TAG) {
 		atomic_dec(&dev->dev_ordered_sync);
-		smp_mb__after_atomic_dec();
+		smp_mb__after_atomic();
 
 		dev->dev_cur_ordered_id++;
 		pr_debug("Incremented dev_cur_ordered_id: %u for ORDERED:"
@@ -1900,7 +1900,7 @@ static void transport_handle_queue_full(
 	spin_lock_irq(&dev->qf_cmd_lock);
 	list_add_tail(&cmd->se_qf_node, &cmd->se_dev->qf_cmd_list);
 	atomic_inc(&dev->dev_qf_count);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 	spin_unlock_irq(&cmd->se_dev->qf_cmd_lock);
 
 	schedule_work(&cmd->se_dev->qf_work_queue);
@@ -2875,7 +2875,7 @@ void transport_send_task_abort(struct se_cmd *cmd)
 		if (cmd->se_tfo->write_pending_status(cmd) != 0) {
 			cmd->transport_state |= CMD_T_ABORTED;
 			cmd->se_cmd_flags |= SCF_SEND_DELAYED_TAS;
-			smp_mb__after_atomic_inc();
+			smp_mb__after_atomic();
 			return;
 		}
 	}
diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core_ua.c
index 505519b..101858e 100644
--- a/drivers/target/target_core_ua.c
+++ b/drivers/target/target_core_ua.c
@@ -162,7 +162,7 @@ int core_scsi3_ua_allocate(
 		spin_unlock_irq(&nacl->device_list_lock);
 
 		atomic_inc(&deve->ua_count);
-		smp_mb__after_atomic_inc();
+		smp_mb__after_atomic();
 		return 0;
 	}
 	list_add_tail(&ua->ua_nacl_list, &deve->ua_list);
@@ -175,7 +175,7 @@ int core_scsi3_ua_allocate(
 		asc, ascq);
 
 	atomic_inc(&deve->ua_count);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 	return 0;
 }
 
@@ -190,7 +190,7 @@ void core_scsi3_ua_release_all(
 		kmem_cache_free(se_ua_cache, ua);
 
 		atomic_dec(&deve->ua_count);
-		smp_mb__after_atomic_dec();
+		smp_mb__after_atomic();
 	}
 	spin_unlock(&deve->ua_lock);
 }
@@ -251,7 +251,7 @@ void core_scsi3_ua_for_check_condition(
 		kmem_cache_free(se_ua_cache, ua);
 
 		atomic_dec(&deve->ua_count);
-		smp_mb__after_atomic_dec();
+		smp_mb__after_atomic();
 	}
 	spin_unlock(&deve->ua_lock);
 	spin_unlock_irq(&nacl->device_list_lock);
@@ -310,7 +310,7 @@ int core_scsi3_ua_clear_for_request_sense(
 		kmem_cache_free(se_ua_cache, ua);
 
 		atomic_dec(&deve->ua_count);
-		smp_mb__after_atomic_dec();
+		smp_mb__after_atomic();
 	}
 	spin_unlock(&deve->ua_lock);
 	spin_unlock_irq(&nacl->device_list_lock);
diff --git a/drivers/usb/gadget/tcm_usb_gadget.c b/drivers/usb/gadget/tcm_usb_gadget.c
index f058c03..819875c 100644
--- a/drivers/usb/gadget/tcm_usb_gadget.c
+++ b/drivers/usb/gadget/tcm_usb_gadget.c
@@ -1851,7 +1851,7 @@ static int usbg_port_link(struct se_portal_group *se_tpg, struct se_lun *lun)
 	struct usbg_tpg *tpg = container_of(se_tpg, struct usbg_tpg, se_tpg);
 
 	atomic_inc(&tpg->tpg_port_count);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 	return 0;
 }
 
@@ -1861,7 +1861,7 @@ static void usbg_port_unlink(struct se_portal_group *se_tpg,
 	struct usbg_tpg *tpg = container_of(se_tpg, struct usbg_tpg, se_tpg);
 
 	atomic_dec(&tpg->tpg_port_count);
-	smp_mb__after_atomic_dec();
+	smp_mb__after_atomic();
 }
 
 static int usbg_check_stop_free(struct se_cmd *se_cmd)
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index cf50ce9..aeb5131 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1255,7 +1255,7 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 			tpg->tv_tpg_vhost_count++;
 			tpg->vhost_scsi = vs;
 			vs_tpg[tpg->tport_tpgt] = tpg;
-			smp_mb__after_atomic_inc();
+			smp_mb__after_atomic();
 			match = true;
 		}
 		mutex_unlock(&tpg->tv_tpg_mutex);
diff --git a/drivers/w1/w1_family.c b/drivers/w1/w1_family.c
index 3bff6b3..3651ec8 100644
--- a/drivers/w1/w1_family.c
+++ b/drivers/w1/w1_family.c
@@ -139,9 +139,9 @@ void w1_family_get(struct w1_family *f)
 
 void __w1_family_get(struct w1_family *f)
 {
-	smp_mb__before_atomic_inc();
+	smp_mb__before_atomic();
 	atomic_inc(&f->refcnt);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 }
 
 EXPORT_SYMBOL(w1_unregister_family);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5f805bc..5a3b837 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7126,7 +7126,7 @@ static void btrfs_end_dio_bio(struct bio *bio, int err)
 		 * before atomic variable goto zero, we must make sure
 		 * dip->errors is perceived to be set.
 		 */
-		smp_mb__before_atomic_dec();
+		smp_mb__before_atomic();
 	}
 
 	/* if there are more bios still pending for this dio, just exit */
@@ -7306,7 +7306,7 @@ out_err:
 	 * before atomic variable goto zero, we must
 	 * make sure dip->errors is perceived to be set.
 	 */
-	smp_mb__before_atomic_dec();
+	smp_mb__before_atomic();
 	if (atomic_dec_and_test(&dip->pending_bios))
 		bio_io_error(dip->orig_bio);
 
@@ -7449,7 +7449,7 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 		return 0;
 
 	atomic_inc(&inode->i_dio_count);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 
 	/*
 	 * The generic stuff only does filemap_write_and_wait_range, which
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2f6d7b1..3f52bb7 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -642,7 +642,7 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 		return -EINVAL;
 
 	atomic_inc(&root->will_be_snapshoted);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 	btrfs_wait_nocow_write(root);
 
 	ret = btrfs_start_delalloc_inodes(root, 0);
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index d9f3d06..aa8dca7 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -2032,9 +2032,9 @@ static void nfs_access_free_entry(struct nfs_access_entry *entry)
 {
 	put_rpccred(entry->cred);
 	kfree(entry);
-	smp_mb__before_atomic_dec();
+	smp_mb__before_atomic();
 	atomic_long_dec(&nfs_access_nr_entries);
-	smp_mb__after_atomic_dec();
+	smp_mb__after_atomic();
 }
 
 static void nfs_access_free_list(struct list_head *head)
@@ -2232,9 +2232,9 @@ void nfs_access_add_cache(struct inode *inode, struct nfs_access_entry *set)
 	nfs_access_add_rbtree(inode, cache);
 
 	/* Update accounting */
-	smp_mb__before_atomic_inc();
+	smp_mb__before_atomic();
 	atomic_long_inc(&nfs_access_nr_entries);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 
 	/* Add inode to global LRU list */
 	if (!test_bit(NFS_INO_ACL_LRU_SET, &NFS_I(inode)->flags)) {
diff --git a/fs/nfs/pnfs.h b/fs/nfs/pnfs.h
index 0237939..c3058a0 100644
--- a/fs/nfs/pnfs.h
+++ b/fs/nfs/pnfs.h
@@ -275,7 +275,7 @@ pnfs_get_lseg(struct pnfs_layout_segment *lseg)
 {
 	if (lseg) {
 		atomic_inc(&lseg->pls_refcount);
-		smp_mb__after_atomic_inc();
+		smp_mb__after_atomic();
 	}
 	return lseg;
 }
diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.h
index 33bd2de..a7d81a6 100644
--- a/include/asm-generic/atomic.h
+++ b/include/asm-generic/atomic.h
@@ -183,10 +183,8 @@ static inline void atomic_set_mask(unsigned int mask, atomic_t *v)
 #endif
 
 /* Assume that atomic operations are already serializing */
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
+#define smp_mb__before_atomic()	barrier()
+#define smp_mb__after_atomic()		barrier()
 
 #endif /* __KERNEL__ */
 #endif /* __ASM_GENERIC_ATOMIC_H */
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index c40302f..7cbf837 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -278,7 +278,7 @@ static inline void get_bh(struct buffer_head *bh)
 
 static inline void put_bh(struct buffer_head *bh)
 {
-        smp_mb__before_atomic_dec();
+        smp_mb__before_atomic();
         atomic_dec(&bh->b_count);
 }
 
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 9f3c275..ec274e0 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -649,7 +649,7 @@ static inline void hd_ref_init(struct hd_struct *part)
 static inline void hd_struct_get(struct hd_struct *part)
 {
 	atomic_inc(&part->ref);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 }
 
 static inline int hd_struct_try_get(struct hd_struct *part)
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 051c850..fa17833 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -539,7 +539,7 @@ static inline void tasklet_hi_schedule_first(struct tasklet_struct *t)
 static inline void tasklet_disable_nosync(struct tasklet_struct *t)
 {
 	atomic_inc(&t->count);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 }
 
 static inline void tasklet_disable(struct tasklet_struct *t)
@@ -551,13 +551,13 @@ static inline void tasklet_disable(struct tasklet_struct *t)
 
 static inline void tasklet_enable(struct tasklet_struct *t)
 {
-	smp_mb__before_atomic_dec();
+	smp_mb__before_atomic();
 	atomic_dec(&t->count);
 }
 
 static inline void tasklet_hi_enable(struct tasklet_struct *t)
 {
-	smp_mb__before_atomic_dec();
+	smp_mb__before_atomic();
 	atomic_dec(&t->count);
 }
 
diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 5679d92..624a8a5 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -1204,7 +1204,7 @@ static inline bool __ip_vs_conn_get(struct ip_vs_conn *cp)
 /* put back the conn without restarting its timer */
 static inline void __ip_vs_conn_put(struct ip_vs_conn *cp)
 {
-	smp_mb__before_atomic_dec();
+	smp_mb__before_atomic();
 	atomic_dec(&cp->refcnt);
 }
 void ip_vs_conn_put(struct ip_vs_conn *cp);
@@ -1408,7 +1408,7 @@ static inline void ip_vs_dest_hold(struct ip_vs_dest *dest)
 
 static inline void ip_vs_dest_put(struct ip_vs_dest *dest)
 {
-	smp_mb__before_atomic_dec();
+	smp_mb__before_atomic();
 	atomic_dec(&dest->refcnt);
 }
 
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 2956c8d..1adf62b 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -534,7 +534,7 @@ return_normal:
 			kgdb_info[cpu].exception_state &=
 				~(DCPU_WANT_MASTER | DCPU_IS_SLAVE);
 			kgdb_info[cpu].enter_kgdb--;
-			smp_mb__before_atomic_dec();
+			smp_mb__before_atomic();
 			atomic_dec(&slaves_in_kgdb);
 			dbg_touch_watchdogs();
 			local_irq_restore(flags);
@@ -662,7 +662,7 @@ kgdb_restore:
 	kgdb_info[cpu].exception_state &=
 		~(DCPU_WANT_MASTER | DCPU_IS_SLAVE);
 	kgdb_info[cpu].enter_kgdb--;
-	smp_mb__before_atomic_dec();
+	smp_mb__before_atomic();
 	atomic_dec(&masters_in_kgdb);
 	/* Free kgdb_active */
 	atomic_set(&kgdb_active, -1);
diff --git a/kernel/futex.c b/kernel/futex.c
index 5f58927..b991ec0 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -267,7 +267,7 @@ static inline void futex_get_mm(union futex_key *key)
 	 * get_futex_key() implies a full barrier. This is relied upon
 	 * as full barrier (B), see the ordering comment above.
 	 */
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 }
 
 /*
@@ -280,7 +280,7 @@ static inline void hb_waiters_inc(struct futex_hash_bucket *hb)
 	/*
 	 * Full barrier (A), see the ordering comment above.
 	 */
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 #endif
 }
 
diff --git a/kernel/kmod.c b/kernel/kmod.c
index 6b375af..0ac67a5 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -498,7 +498,7 @@ int __usermodehelper_disable(enum umh_disable_depth depth)
 static void helper_lock(void)
 {
 	atomic_inc(&running_helpers);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 }
 
 static void helper_unlock(void)
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 0c47e30..88b4a1d 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -387,9 +387,9 @@ static void rcu_eqs_enter_common(struct rcu_dynticks *rdtp, long long oldval,
 	}
 	rcu_prepare_for_idle(smp_processor_id());
 	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
-	smp_mb__before_atomic_inc();  /* See above. */
+	smp_mb__before_atomic();  /* See above. */
 	atomic_inc(&rdtp->dynticks);
-	smp_mb__after_atomic_inc();  /* Force ordering with next sojourn. */
+	smp_mb__after_atomic();  /* Force ordering with next sojourn. */
 	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
 
 	/*
@@ -507,10 +507,10 @@ void rcu_irq_exit(void)
 static void rcu_eqs_exit_common(struct rcu_dynticks *rdtp, long long oldval,
 			       int user)
 {
-	smp_mb__before_atomic_inc();  /* Force ordering w/previous sojourn. */
+	smp_mb__before_atomic();  /* Force ordering w/previous sojourn. */
 	atomic_inc(&rdtp->dynticks);
 	/* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
-	smp_mb__after_atomic_inc();  /* See above. */
+	smp_mb__after_atomic();  /* See above. */
 	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
 	rcu_cleanup_after_idle(smp_processor_id());
 	trace_rcu_dyntick(TPS("End"), oldval, rdtp->dynticks_nesting);
@@ -635,10 +635,10 @@ void rcu_nmi_enter(void)
 	    (atomic_read(&rdtp->dynticks) & 0x1))
 		return;
 	rdtp->dynticks_nmi_nesting++;
-	smp_mb__before_atomic_inc();  /* Force delay from prior write. */
+	smp_mb__before_atomic();  /* Force delay from prior write. */
 	atomic_inc(&rdtp->dynticks);
 	/* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
-	smp_mb__after_atomic_inc();  /* See above. */
+	smp_mb__after_atomic();  /* See above. */
 	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
 }
 
@@ -657,9 +657,9 @@ void rcu_nmi_exit(void)
 	    --rdtp->dynticks_nmi_nesting != 0)
 		return;
 	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
-	smp_mb__before_atomic_inc();  /* See above. */
+	smp_mb__before_atomic();  /* See above. */
 	atomic_inc(&rdtp->dynticks);
-	smp_mb__after_atomic_inc();  /* Force delay to next write. */
+	smp_mb__after_atomic();  /* Force delay to next write. */
 	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
 }
 
@@ -2790,7 +2790,7 @@ void synchronize_sched_expedited(void)
 		s = atomic_long_read(&rsp->expedited_done);
 		if (ULONG_CMP_GE((ulong)s, (ulong)firstsnap)) {
 			/* ensure test happens before caller kfree */
-			smp_mb__before_atomic_inc(); /* ^^^ */
+			smp_mb__before_atomic(); /* ^^^ */
 			atomic_long_inc(&rsp->expedited_workdone1);
 			return;
 		}
@@ -2808,7 +2808,7 @@ void synchronize_sched_expedited(void)
 		s = atomic_long_read(&rsp->expedited_done);
 		if (ULONG_CMP_GE((ulong)s, (ulong)firstsnap)) {
 			/* ensure test happens before caller kfree */
-			smp_mb__before_atomic_inc(); /* ^^^ */
+			smp_mb__before_atomic(); /* ^^^ */
 			atomic_long_inc(&rsp->expedited_workdone2);
 			return;
 		}
@@ -2837,7 +2837,7 @@ void synchronize_sched_expedited(void)
 		s = atomic_long_read(&rsp->expedited_done);
 		if (ULONG_CMP_GE((ulong)s, (ulong)snap)) {
 			/* ensure test happens before caller kfree */
-			smp_mb__before_atomic_inc(); /* ^^^ */
+			smp_mb__before_atomic(); /* ^^^ */
 			atomic_long_inc(&rsp->expedited_done_lost);
 			break;
 		}
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 962d1d5..56db2f8 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2523,9 +2523,9 @@ static void rcu_sysidle_enter(struct rcu_dynticks *rdtp, int irq)
 	/* Record start of fully idle period. */
 	j = jiffies;
 	ACCESS_ONCE(rdtp->dynticks_idle_jiffies) = j;
-	smp_mb__before_atomic_inc();
+	smp_mb__before_atomic();
 	atomic_inc(&rdtp->dynticks_idle);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 	WARN_ON_ONCE(atomic_read(&rdtp->dynticks_idle) & 0x1);
 }
 
@@ -2590,9 +2590,9 @@ static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq)
 	}
 
 	/* Record end of idle period. */
-	smp_mb__before_atomic_inc();
+	smp_mb__before_atomic();
 	atomic_inc(&rdtp->dynticks_idle);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks_idle) & 0x1));
 
 	/*
diff --git a/kernel/sched/cpupri.c b/kernel/sched/cpupri.c
index 3031bac..a5635ad 100644
--- a/kernel/sched/cpupri.c
+++ b/kernel/sched/cpupri.c
@@ -164,7 +164,7 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
 		 * do a write memory barrier, and then update the count, to
 		 * make sure the vector is visible when count is set.
 		 */
-		smp_mb__before_atomic_inc();
+		smp_mb__before_atomic();
 		atomic_inc(&(vec)->count);
 		do_mb = 1;
 	}
@@ -184,14 +184,14 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
 		 * the new priority vec.
 		 */
 		if (do_mb)
-			smp_mb__after_atomic_inc();
+			smp_mb__after_atomic();
 
 		/*
 		 * When removing from the vector, we decrement the counter first
 		 * do a memory barrier and then clear the mask.
 		 */
 		atomic_dec(&(vec)->count);
-		smp_mb__after_atomic_inc();
+		smp_mb__after_atomic();
 		cpumask_clear_cpu(cpu, vec->mask);
 	}
 
diff --git a/net/ipv4/inetpeer.c b/net/ipv4/inetpeer.c
index 48f4244..56cd458 100644
--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -522,7 +522,7 @@ EXPORT_SYMBOL_GPL(inet_getpeer);
 void inet_putpeer(struct inet_peer *p)
 {
 	p->dtime = (__u32)jiffies;
-	smp_mb__before_atomic_dec();
+	smp_mb__before_atomic();
 	atomic_dec(&p->refcnt);
 }
 EXPORT_SYMBOL_GPL(inet_putpeer);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 75421f2..1f4f954 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -914,7 +914,7 @@ void nf_conntrack_free(struct nf_conn *ct)
 	nf_ct_ext_destroy(ct);
 	nf_ct_ext_free(ct);
 	kmem_cache_free(net->ct.nf_conntrack_cachep, ct);
-	smp_mb__before_atomic_dec();
+	smp_mb__before_atomic();
 	atomic_dec(&net->ct.count);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_free);
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index bb7e8ba..749f80c 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1207,7 +1207,7 @@ restart:
 	sk->sk_state	= TCP_ESTABLISHED;
 	sock_hold(newsk);
 
-	smp_mb__after_atomic_inc();	/* sock_hold() does an atomic_inc() */
+	smp_mb__after_atomic();	/* sock_hold() does an atomic_inc() */
 	unix_peer(sk)	= newsk;
 
 	unix_state_unlock(sk);
-- 
1.9.1
