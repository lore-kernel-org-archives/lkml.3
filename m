Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbaFVQqQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 12:46:16 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50155 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbaFVQqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 12:46:14 -0400
Date: Sun, 22 Jun 2014 18:46:03 +0200
From: Borislav Petkov <bp@alien8.de>
To: x86-ml <x86@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] RAS fix for 3.17
Message-ID: <20140622164603.GA3385@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

please queue this for 3.17. We had it ready earlier but decided to delay
it for an extra testing period.

Thanks.

--
The following changes since commit a497c3ba1d97fc69c1e78e7b96435ba8c2cb42ee:

  Linux 3.16-rc2 (2014-06-21 19:02:54 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/ras_for_3.17

for you to fetch changes up to 38356c1fbd8cd0f44a32ede2c97f0eb639d06613:

  x86, MCE: Kill CPU_POST_DEAD (2014-06-22 18:36:39 +0200)

----------------------------------------------------------------
CPU_POST_DEAD is one of thorns in the path to getting CPU hotplug
seriously cleaned up. Kill its incarnation here in the MCE code.

----------------------------------------------------------------
Borislav Petkov (1):
      x86, MCE: Kill CPU_POST_DEAD

 arch/x86/kernel/cpu/mcheck/mce.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index bb92f38153b2..8fecdd34f2d2 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2385,6 +2385,10 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 			threshold_cpu_callback(action, cpu);
 		mce_device_remove(cpu);
 		mce_intel_hcpu_update(cpu);
+
+		/* intentionally ignoring frozen here */
+		if (!(action & CPU_TASKS_FROZEN))
+			cmci_rediscover();
 		break;
 	case CPU_DOWN_PREPARE:
 		smp_call_function_single(cpu, mce_disable_cpu, &action, 1);
@@ -2396,11 +2400,6 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		break;
 	}
 
-	if (action == CPU_POST_DEAD) {
-		/* intentionally ignoring frozen here */
-		cmci_rediscover();
-	}
-
 	return NOTIFY_OK;
 }
 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
