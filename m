Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbbAOOBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 09:01:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50756 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbbAOOBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 09:01:08 -0500
Date: Thu, 15 Jan 2015 04:59:56 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-7f530a2771fe7ea6a068340c9e22f814edfcc3c4@git.kernel.org>
Cc: benh@kernel.crashing.org, tony.luck@intel.com, hpa@linux.intel.com,
        JBeulich@suse.com, yinghai@kernel.org, bp@alien8.de, oren@scalemp.com,
        jiang.liu@linux.intel.com, hpa@zytor.com, joro@8bytes.org,
        richard@nod.at, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        rientjes@google.com, mingo@kernel.org, d.hatayama@jp.fujitsu.com
Reply-To: mingo@kernel.org, rientjes@google.com, d.hatayama@jp.fujitsu.com,
        richard@nod.at, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        joro@8bytes.org, hpa@linux.intel.com, JBeulich@suse.com,
        yinghai@kernel.org, jiang.liu@linux.intel.com, hpa@zytor.com,
        bp@alien8.de, oren@scalemp.com, benh@kernel.crashing.org,
        tony.luck@intel.com
In-Reply-To: <1420615903-28253-6-git-send-email-jiang.liu@linux.intel.com>
References: <1420615903-28253-6-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic:
  Kill useless variable x2apic_enabled in function enable_IR_x2apic()
Git-Commit-ID: 7f530a2771fe7ea6a068340c9e22f814edfcc3c4
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

Commit-ID:  7f530a2771fe7ea6a068340c9e22f814edfcc3c4
Gitweb:     http://git.kernel.org/tip/7f530a2771fe7ea6a068340c9e22f814edfcc3c4
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Wed, 7 Jan 2015 15:31:32 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 15 Jan 2015 11:24:22 +0100

x86/apic: Kill useless variable x2apic_enabled in function enable_IR_x2apic()

Local variable x2apic_enabled has been assigned to but never referred,
so kill it.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: iommu@lists.linux-foundation.org
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Rientjes <rientjes@google.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Jan Beulich <JBeulich@suse.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Oren Twaig <oren@scalemp.com>
Link: http://lkml.kernel.org/r/1420615903-28253-6-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/apic.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 5446733..2dbd3a0 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1595,7 +1595,7 @@ int __init enable_IR(void)
 void __init enable_IR_x2apic(void)
 {
 	unsigned long flags;
-	int ret, x2apic_enabled = 0;
+	int ret;
 	int hardware_init_ret;
 
 	if (!IS_ENABLED(CONFIG_X86_X2APIC)) {
@@ -1653,8 +1653,6 @@ void __init enable_IR_x2apic(void)
 		goto skip_x2apic;
 	}
 
-	x2apic_enabled = 1;
-
 	if (x2apic_supported() && !x2apic_mode) {
 		x2apic_mode = 1;
 		enable_x2apic();
