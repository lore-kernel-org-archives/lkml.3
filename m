Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab3IIPQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:16:56 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:32010 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab3IIPQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:16:55 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        stefan.bader@canonical.com, stefano.stabellini@eu.citrix.com,
        jeremy@goop.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/5] xen/spinlock: We don't need the old structure anymore
Date: Mon,  9 Sep 2013 11:11:33 -0400
Message-Id: <1378739496-17468-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1378739496-17468-1-git-send-email-konrad.wilk@oracle.com>
References: <1378739496-17468-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we are using the generic ticketlock structs and these
old structures are not needed anymore.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reviewed-by: David Vrabel <david.vrabel@citrix.com>
---
 arch/x86/xen/spinlock.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index 0438b93..71db82c 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -81,7 +81,6 @@ static inline void spin_time_accum_blocked(u64 start)
 	spinlock_stats.time_blocked += delta;
 }
 #else  /* !CONFIG_XEN_DEBUG_FS */
-#define TIMEOUT			(1 << 10)
 static inline void add_stats(enum xen_contention_stat var, u32 val)
 {
 }
@@ -96,23 +95,6 @@ static inline void spin_time_accum_blocked(u64 start)
 }
 #endif  /* CONFIG_XEN_DEBUG_FS */
 
-/*
- * Size struct xen_spinlock so it's the same as arch_spinlock_t.
- */
-#if NR_CPUS < 256
-typedef u8 xen_spinners_t;
-# define inc_spinners(xl) \
-	asm(LOCK_PREFIX " incb %0" : "+m" ((xl)->spinners) : : "memory");
-# define dec_spinners(xl) \
-	asm(LOCK_PREFIX " decb %0" : "+m" ((xl)->spinners) : : "memory");
-#else
-typedef u16 xen_spinners_t;
-# define inc_spinners(xl) \
-	asm(LOCK_PREFIX " incw %0" : "+m" ((xl)->spinners) : : "memory");
-# define dec_spinners(xl) \
-	asm(LOCK_PREFIX " decw %0" : "+m" ((xl)->spinners) : : "memory");
-#endif
-
 struct xen_lock_waiting {
 	struct arch_spinlock *lock;
 	__ticket_t want;
-- 
1.8.3.1

