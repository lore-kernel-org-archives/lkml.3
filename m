Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719AbaHTIPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 04:15:46 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:52596 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbaHTIPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 04:15:44 -0400
From: Andreas Ruprecht <rupran@einserver.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Andreas Ruprecht <rupran@einserver.de>
Subject: [PATCH] arch: x86: kernel: apic: Remove unnecessary ifdef
Date: Wed, 20 Aug 2014 10:16:01 +0200
Message-Id: <1408522561-23389-1-git-send-email-rupran@einserver.de>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the file x2apic_uv_x.c, some code is compiled conditionally depending on
CONFIG_SMP. However, the file is only built, if CONFIG_X86_UV is enabled.

CONFIG_X86_UV depends on CONFIG_NUMA, which itself depends on CONFIG_SMP, so the
ifdef will always evaluate to true, if the file is compiled. Thus, it is
unnecessary and can be removed.

Signed-off-by: Andreas Ruprecht <rupran@einserver.de>
---
 arch/x86/kernel/apic/x2apic_uv_x.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 004f017..8e9dcfd 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -204,7 +204,6 @@ EXPORT_SYMBOL(sn_rtc_cycles_per_second);
 
 static int uv_wakeup_secondary(int phys_apicid, unsigned long start_rip)
 {
-#ifdef CONFIG_SMP
 	unsigned long val;
 	int pnode;
 
@@ -223,7 +222,6 @@ static int uv_wakeup_secondary(int phys_apicid, unsigned long start_rip)
 	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
 
 	atomic_set(&init_deasserted, 1);
-#endif
 	return 0;
 }
 
-- 
1.9.1

