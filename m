Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab3AXUge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:36:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34859 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149Ab3AXUft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:35:49 -0500
Date: Thu, 24 Jan 2013 12:35:31 -0800
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-9611dc7a8de8a5c6244886dad020995b1a896236@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jbeulich@suse.com, JBeulich@suse.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        JBeulich@suse.com, jbeulich@suse.com, tglx@linutronix.de
In-Reply-To: <50AFB35102000078000AAECA@nat28.tlf.novell.com>
References: <50AFB35102000078000AAECA@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86:
  Convert a few mistaken __cpuinit annotations to __init
Git-Commit-ID: 9611dc7a8de8a5c6244886dad020995b1a896236
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 12:35:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9611dc7a8de8a5c6244886dad020995b1a896236
Gitweb:     http://git.kernel.org/tip/9611dc7a8de8a5c6244886dad020995b1a896236
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Fri, 23 Nov 2012 16:33:05 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 24 Jan 2013 17:12:19 +0100

x86: Convert a few mistaken __cpuinit annotations to __init

The first two are functions serving as initcalls; the SFI one is
only being called from __init code.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/50AFB35102000078000AAECA@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c | 2 +-
 arch/x86/mm/tlb.c                     | 2 +-
 arch/x86/platform/sfi/sfi.c           | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index fe9edec..0e46240 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -1227,7 +1227,7 @@ static struct notifier_block __cpuinitdata cacheinfo_cpu_notifier = {
 	.notifier_call = cacheinfo_cpu_callback,
 };
 
-static int __cpuinit cache_sysfs_init(void)
+static int __init cache_sysfs_init(void)
 {
 	int i;
 
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 13a6b29..282375f 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -335,7 +335,7 @@ static const struct file_operations fops_tlbflush = {
 	.llseek = default_llseek,
 };
 
-static int __cpuinit create_tlb_flushall_shift(void)
+static int __init create_tlb_flushall_shift(void)
 {
 	debugfs_create_file("tlb_flushall_shift", S_IRUSR | S_IWUSR,
 			    arch_debugfs_dir, NULL, &fops_tlbflush);
diff --git a/arch/x86/platform/sfi/sfi.c b/arch/x86/platform/sfi/sfi.c
index 7785b72..bcd1a70 100644
--- a/arch/x86/platform/sfi/sfi.c
+++ b/arch/x86/platform/sfi/sfi.c
@@ -35,7 +35,7 @@
 static unsigned long sfi_lapic_addr __initdata = APIC_DEFAULT_PHYS_BASE;
 
 /* All CPUs enumerated by SFI must be present and enabled */
-static void __cpuinit mp_sfi_register_lapic(u8 id)
+static void __init mp_sfi_register_lapic(u8 id)
 {
 	if (MAX_LOCAL_APIC - id <= 0) {
 		pr_warning("Processor #%d invalid (max %d)\n",
