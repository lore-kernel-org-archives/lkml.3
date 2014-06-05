Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbaFER6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 13:58:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51606 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbaFER6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 13:58:37 -0400
Date: Thu, 5 Jun 2014 10:58:24 -0700
From: tip-bot for Igor Mammedov <tipbot@zytor.com>
Message-ID: <tip-feef1e8ecbadf24f8e6829c935df8683cabae41b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        imammedo@redhat.com, tglx@linutronix.de, toshi.kani@hp.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        imammedo@redhat.com, tglx@linutronix.de, toshi.kani@hp.com
In-Reply-To: <1401975765-22328-3-git-send-email-imammedo@redhat.com>
References: <1401975765-22328-3-git-send-email-imammedo@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/smpboot:
  Log error on secondary CPU wakeup failure at ERR level
Git-Commit-ID: feef1e8ecbadf24f8e6829c935df8683cabae41b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  feef1e8ecbadf24f8e6829c935df8683cabae41b
Gitweb:     http://git.kernel.org/tip/feef1e8ecbadf24f8e6829c935df8683cabae41b
Author:     Igor Mammedov <imammedo@redhat.com>
AuthorDate: Thu, 5 Jun 2014 15:42:44 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jun 2014 16:33:07 +0200

x86/smpboot: Log error on secondary CPU wakeup failure at ERR level

If system is running without debug level logging,
it will not log error if do_boot_cpu() failed to
wakeup AP. It may lead to silent AP bringup
failures at boot time.
Change message level to KERN_ERR to make error
visible to user as it's done on other architectures.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
Acked-by: Toshi Kani <toshi.kani@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1401975765-22328-3-git-send-email-imammedo@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/smpboot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 2988f69..ae2fd975 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -918,7 +918,7 @@ int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
 
 	err = do_boot_cpu(apicid, cpu, tidle);
 	if (err) {
-		pr_debug("do_boot_cpu failed %d\n", err);
+		pr_err("do_boot_cpu failed(%d) to wakeup CPU#%u\n", err, cpu);
 		return -EIO;
 	}
 
