Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbaDKMnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 08:43:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754818AbaDKMm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 08:42:58 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        imammedo@redhat.com, bp@suse.de, paul.gortmaker@windriver.com,
        JBeulich@suse.com, prarit@redhat.com, drjones@redhat.com,
        toshi.kani@hp.com, riel@redhat.com, gong.chen@linux.intel.com,
        andi@firstfloor.org, lenb@kernel.org, rjw@rjwysocki.net,
        linux-acpi@vger.kernel.org
Subject: [PATCH v3 2/5] x86: log error on secondary CPU wakeup failure at ERR level
Date: Thu, 10 Apr 2014 19:14:18 +0200
Message-Id: <1397150061-29735-3-git-send-email-imammedo@redhat.com>
In-Reply-To: <1397150061-29735-1-git-send-email-imammedo@redhat.com>
References: <1397150061-29735-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If system is running without debug level logging,
it will not log error if do_boot_cpu() failed to
wakeup AP. It may lead to silent AP bringup
failures at boot time.
Change message level to KERN_ERR to make error
visible to user as it's done on other architectures.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 arch/x86/kernel/smpboot.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 5e57a0a..853473d 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -883,7 +883,7 @@ int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
 
 	err = do_boot_cpu(apicid, cpu, tidle);
 	if (err) {
-		pr_debug("do_boot_cpu failed %d\n", err);
+		pr_err("do_boot_cpu failed(%d) to wakeup CPU#%u\n", err, cpu);
 		return -EIO;
 	}
 
-- 
1.7.1

