Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbaEEUvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 16:51:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755884AbaEEUvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 16:51:12 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        imammedo@redhat.com, bp@suse.de, paul.gortmaker@windriver.com,
        JBeulich@suse.com, prarit@redhat.com, drjones@redhat.com,
        toshi.kani@hp.com, riel@redhat.com, gong.chen@linux.intel.com,
        andi@firstfloor.org, lenb@kernel.org, rjw@rjwysocki.net,
        linux-acpi@vger.kernel.org
Subject: [PATCH v5 3/4] x86: log error on secondary CPU wakeup failure at ERR level
Date: Mon,  5 May 2014 22:49:50 +0200
Message-Id: <1399322991-19329-4-git-send-email-imammedo@redhat.com>
In-Reply-To: <1399322991-19329-1-git-send-email-imammedo@redhat.com>
References: <1399322991-19329-1-git-send-email-imammedo@redhat.com>
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
Acked-by: Toshi Kani <toshi.kani@hp.com>
---
 arch/x86/kernel/smpboot.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 2988f69..ae2fd97 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -918,7 +918,7 @@ int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
 
 	err = do_boot_cpu(apicid, cpu, tidle);
 	if (err) {
-		pr_debug("do_boot_cpu failed %d\n", err);
+		pr_err("do_boot_cpu failed(%d) to wakeup CPU#%u\n", err, cpu);
 		return -EIO;
 	}
 
-- 
1.7.1

