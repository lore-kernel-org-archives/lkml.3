Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab3J3Wzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 18:55:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39530 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495Ab3J3Wz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 18:55:29 -0400
Date: Wed, 30 Oct 2013 15:54:55 -0700
From: tip-bot for David Rientjes <tipbot@zytor.com>
Message-ID: <tip-d68ce0177c1e51fb332369e0c99852a6d05668af@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        kys@microsoft.com, tglx@linutronix.de, hpa@linux.intel.com,
        rientjes@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        kys@microsoft.com, tglx@linutronix.de, rientjes@google.com,
        hpa@linux.intel.com
In-Reply-To: <alpine.DEB.2.02.1310111604160.31170@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1310111604160.31170@chino.kir.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/hyperv] x86, hyperv: Fix build error due to missing <asm
 /apic.h> include
Git-Commit-ID: d68ce0177c1e51fb332369e0c99852a6d05668af
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 30 Oct 2013 15:55:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d68ce0177c1e51fb332369e0c99852a6d05668af
Gitweb:     http://git.kernel.org/tip/d68ce0177c1e51fb332369e0c99852a6d05668af
Author:     David Rientjes <rientjes@google.com>
AuthorDate: Fri, 11 Oct 2013 16:07:31 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 30 Oct 2013 15:37:47 -0700

x86, hyperv: Fix build error due to missing <asm/apic.h> include

9e7827b5ea4c ("x86, hyperv: Get the local APIC timer frequency from the
hypervisor") breaks the build with some configs because apic.h isn't
directly included:

arch/x86/kernel/cpu/mshyperv.c: In function 'ms_hyperv_init_platform':
arch/x86/kernel/cpu/mshyperv.c:90:3: error: 'lapic_timer_frequency' undeclared (first use in this function)
arch/x86/kernel/cpu/mshyperv.c:90:3: note: each undeclared identifier is reported only once for each function it appears in

Fix it by including asm/apic.h.

Signed-off-by: David Rientjes <rientjes@google.com>
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1310111604160.31170@chino.kir.corp.google.com
Acked-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/mshyperv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 628ff50..9f6e9f8 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -25,6 +25,7 @@
 #include <asm/idle.h>
 #include <asm/irq_regs.h>
 #include <asm/i8259.h>
+#include <asm/apic.h>
 
 struct ms_hyperv_info ms_hyperv;
 EXPORT_SYMBOL_GPL(ms_hyperv);
