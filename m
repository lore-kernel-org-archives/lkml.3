Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448Ab3LEDg5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 22:36:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38847 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab3LEDgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 22:36:54 -0500
Date: Wed, 4 Dec 2013 19:36:30 -0800
From: tip-bot for Fenghua Yu <tipbot@zytor.com>
Message-ID: <tip-2885432aaf15c1b7e65c787bfe7c5fec428296f0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1386202069-51515-1-git-send-email-fenghua.yu@intel.com>
References: <1386202069-51515-1-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/apic, doc:
  Justification for disabling IO APIC before Local APIC
Git-Commit-ID: 2885432aaf15c1b7e65c787bfe7c5fec428296f0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 04 Dec 2013 19:36:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2885432aaf15c1b7e65c787bfe7c5fec428296f0
Gitweb:     http://git.kernel.org/tip/2885432aaf15c1b7e65c787bfe7c5fec428296f0
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Wed, 4 Dec 2013 16:07:49 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 4 Dec 2013 19:33:21 -0800

x86/apic, doc: Justification for disabling IO APIC before Local APIC

Since erratum AVR31 in "Intel Atom Processor C2000 Product Family
Specification Update" is now published, I added a justification
comment for disabling IO APIC before Local APIC, as changed in commit:

522e66464467 x86/apic: Disable I/O APIC before shutdown of the local APIC

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1386202069-51515-1-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/reboot.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index da3c599..c752cb4 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -558,6 +558,17 @@ void native_machine_shutdown(void)
 {
 	/* Stop the cpus and apics */
 #ifdef CONFIG_X86_IO_APIC
+	/*
+	 * Disabling IO APIC before local APIC is a workaround for
+	 * erratum AVR31 in "Intel Atom Processor C2000 Product Family
+	 * Specification Update". In this situation, interrupts that target
+	 * a Logical Processor whose Local APIC is either in the process of
+	 * being hardware disabled or software disabled are neither delivered
+	 * nor discarded. When this erratum occurs, the processor may hang.
+	 *
+	 * Even without the erratum, it still makes sense to quiet IO APIC
+	 * before disabling Local APIC.
+	 */
 	disable_IO_APIC();
 #endif
 
