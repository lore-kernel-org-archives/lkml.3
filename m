Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab3AVQwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 11:52:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34987 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051Ab3AVQwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 11:52:17 -0500
Date: Tue, 22 Jan 2013 08:50:58 -0800
From: tip-bot for Daniel J Blueman <daniel@numascale-asia.com>
Message-ID: <tip-8b84c8df38d5796da2e8cd051666d203ddabcb62@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, bp@alien8.de, daniel@numascale-asia.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@alien8.de, daniel@numascale-asia.com
In-Reply-To: <1353997932-8475-2-git-send-email-daniel@numascale-asia.com>
References: <1353997932-8475-2-git-send-email-daniel@numascale-asia.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86, AMD, NB:
  Use u16 for northbridge IDs in amd_get_nb_id
Git-Commit-ID: 8b84c8df38d5796da2e8cd051666d203ddabcb62
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 22 Jan 2013 08:51:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8b84c8df38d5796da2e8cd051666d203ddabcb62
Gitweb:     http://git.kernel.org/tip/8b84c8df38d5796da2e8cd051666d203ddabcb62
Author:     Daniel J Blueman <daniel@numascale-asia.com>
AuthorDate: Tue, 27 Nov 2012 14:32:10 +0800
Committer:  Borislav Petkov <bp@suse.de>
CommitDate: Thu, 10 Jan 2013 16:17:58 +0100

x86, AMD, NB: Use u16 for northbridge IDs in amd_get_nb_id

Change amd_get_nb_id to return u16 to support >255 memory controllers,
and related consistency fixes.

Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
Link: http://lkml.kernel.org/r/1353997932-8475-2-git-send-email-daniel@numascale-asia.com
Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 arch/x86/include/asm/processor.h | 2 +-
 arch/x86/kernel/cpu/amd.c        | 4 ++--
 drivers/edac/amd64_edac.c        | 5 +++--
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 888184b..cf50054 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -943,7 +943,7 @@ extern void start_thread(struct pt_regs *regs, unsigned long new_ip,
 extern int get_tsc_mode(unsigned long adr);
 extern int set_tsc_mode(unsigned int val);
 
-extern int amd_get_nb_id(int cpu);
+extern u16 amd_get_nb_id(int cpu);
 
 struct aperfmperf {
 	u64 aperf, mperf;
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 15239ff..782c456 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -364,9 +364,9 @@ static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
 #endif
 }
 
-int amd_get_nb_id(int cpu)
+u16 amd_get_nb_id(int cpu)
 {
-	int id = 0;
+	u16 id = 0;
 #ifdef CONFIG_SMP
 	id = per_cpu(cpu_llc_id, cpu);
 #endif
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index a3fe39b..29be39d 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -939,7 +939,8 @@ static u64 get_error_address(struct mce *m)
 		struct amd64_pvt *pvt;
 		u64 cc6_base, tmp_addr;
 		u32 tmp;
-		u8 mce_nid, intlv_en;
+		u16 mce_nid;
+		u8 intlv_en;
 
 		if ((addr & GENMASK(24, 47)) >> 24 != 0x00fdf7)
 			return addr;
@@ -2181,7 +2182,7 @@ static int init_csrows(struct mem_ctl_info *mci)
 }
 
 /* get all cores on this DCT */
-static void get_cpus_on_this_dct_cpumask(struct cpumask *mask, unsigned nid)
+static void get_cpus_on_this_dct_cpumask(struct cpumask *mask, u16 nid)
 {
 	int cpu;
 
