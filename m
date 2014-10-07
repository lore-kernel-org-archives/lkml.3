Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbaJGQzs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 12:55:48 -0400
Received: from amersmtp1.software.dell.com ([12.106.87.226]:43696 "EHLO
	amersmtp1.software.dell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753873AbaJGQzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 12:55:47 -0400
From: Ted Percival <ted@tedp.id.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
CC: Ted Percival <ted@tedp.id.au>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        "moderated list:XEN HYPERVISOR IN..." 
	<xen-devel@lists.xenproject.org>,
        "open list:X86 ARCHITECTURE..." <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/xen: Fix build failure without CONFIG_XEN_PVH
Date: Tue, 7 Oct 2014 10:55:24 -0600
Message-ID: <1412700924-2662-1-git-send-email-ted@tedp.id.au>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Mlf-Version: 8.0.4.2607
X-Mlf-UniqueId: o201410071655460137926
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes: 851861bb4cc0 ("x86/xen: Set EFER.NX and EFER.SCE in PVH guests")
Signed-off-by: Ted Percival <ted@tedp.id.au>
---
 arch/x86/xen/smp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/xen/smp.h b/arch/x86/xen/smp.h
index eed00a8..963d62a 100644
--- a/arch/x86/xen/smp.h
+++ b/arch/x86/xen/smp.h
@@ -11,7 +11,7 @@ extern void xen_send_IPI_self(int vector);
 #ifdef CONFIG_XEN_PVH
 extern void xen_pvh_early_cpu_init(int cpu, bool entry);
 #else
-static inline void xen_pvh_early_cpu_init(int cpu, bool entry);
+static inline void xen_pvh_early_cpu_init(int cpu, bool entry)
 {
 }
 #endif
-- 
1.9.1

