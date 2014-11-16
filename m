Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573AbaKPATz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 19:19:55 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34194 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932426AbaKPATq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 19:19:46 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: ralf@linux-mips.org
Cc: f.fainelli@gmail.com, jfraser@broadcom.com, dtor@chromium.org,
        tglx@linutronix.de, jason@lakedaemon.net, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 17/22] MIPS: BMIPS: Add PRId for BMIPS5200 (Whirlwind)
Date: Sat, 15 Nov 2014 16:17:41 -0800
Message-Id: <1416097066-20452-18-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1416097066-20452-1-git-send-email-cernekee@gmail.com>
References: <1416097066-20452-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a dual core (quad thread) BMIPS5000.  It needs a little extra
code to boot the second core (CPU2/CPU3), but for now we can treat it the
same as a single core BMIPS5000.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/include/asm/cpu.h  | 1 +
 arch/mips/kernel/cpu-probe.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/mips/include/asm/cpu.h b/arch/mips/include/asm/cpu.h
index dfdc77e..de9ca43 100644
--- a/arch/mips/include/asm/cpu.h
+++ b/arch/mips/include/asm/cpu.h
@@ -142,6 +142,7 @@
 #define PRID_IMP_BMIPS3300_BUG	0x0000
 #define PRID_IMP_BMIPS43XX	0xa000
 #define PRID_IMP_BMIPS5000	0x5a00
+#define PRID_IMP_BMIPS5200	0x5b00
 
 #define PRID_REV_BMIPS4380_LO	0x0040
 #define PRID_REV_BMIPS4380_HI	0x006f
diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index 94c4a0c..5477d91 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -1024,6 +1024,7 @@ static inline void cpu_probe_broadcom(struct cpuinfo_mips *c, unsigned int cpu)
 		break;
 	}
 	case PRID_IMP_BMIPS5000:
+	case PRID_IMP_BMIPS5200:
 		c->cputype = CPU_BMIPS5000;
 		__cpu_name[cpu] = "Broadcom BMIPS5000";
 		set_elf_platform(cpu, "bmips5000");
-- 
2.1.1

