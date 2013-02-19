Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934658Ab3BSTrn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:47:43 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:55237 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932823Ab3BSTrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 14:47:42 -0500
From: Mathias Krause <minipli@googlemail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, PaX Team <pageexec@freemail.hu>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: [PATCH] x86: apic: Fix parsing of lapic cmdline option
Date: Tue, 19 Feb 2013 20:47:07 +0100
Message-Id: <1361303227-13174-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Including " lapic " in the kernel cmdline on an x86-64 kernel makes it
panic while parsing early params -- e.g. with no user visible output.

Fix this bug by ensuring arg is non-NULL before passing it to strncmp().

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Reported-by: PaX Team <pageexec@freemail.hu>
Cc: stable@vger.kernel.org	# v3.8
---
 arch/x86/kernel/apic/apic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index b994cc8..cbf5121 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -131,7 +131,7 @@ static int __init parse_lapic(char *arg)
 {
 	if (config_enabled(CONFIG_X86_32) && !arg)
 		force_enable_local_apic = 1;
-	else if (!strncmp(arg, "notscdeadline", 13))
+	else if (arg && !strncmp(arg, "notscdeadline", 13))
 		setup_clear_cpu_cap(X86_FEATURE_TSC_DEADLINE_TIMER);
 	return 0;
 }
-- 
1.7.10.4

