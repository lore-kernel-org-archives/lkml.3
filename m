Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbbAONBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 08:01:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50036 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143AbbAONBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 08:01:14 -0500
Date: Thu, 15 Jan 2015 05:00:14 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-89356cf20ecb0b9975b1dad9ed605dd4c6e68bcd@git.kernel.org>
Cc: tglx@linutronix.de, bp@alien8.de, JBeulich@suse.com, hpa@linux.intel.com,
        yinghai@kernel.org, joro@8bytes.org, d.hatayama@jp.fujitsu.com,
        rientjes@google.com, linux-kernel@vger.kernel.org, oren@scalemp.com,
        jiang.liu@linux.intel.com, mingo@kernel.org, richard@nod.at,
        benh@kernel.crashing.org, tony.luck@intel.com, hpa@zytor.com
Reply-To: hpa@linux.intel.com, yinghai@kernel.org, joro@8bytes.org,
        oren@scalemp.com, jiang.liu@linux.intel.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        d.hatayama@jp.fujitsu.com, tglx@linutronix.de, JBeulich@suse.com,
        bp@alien8.de, tony.luck@intel.com, hpa@zytor.com, richard@nod.at,
        benh@kernel.crashing.org
In-Reply-To: <1420615903-28253-7-git-send-email-jiang.liu@linux.intel.com>
References: <1420615903-28253-7-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic:
  Correctly detect X2APIC status in function enable_IR()
Git-Commit-ID: 89356cf20ecb0b9975b1dad9ed605dd4c6e68bcd
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

Commit-ID:  89356cf20ecb0b9975b1dad9ed605dd4c6e68bcd
Gitweb:     http://git.kernel.org/tip/89356cf20ecb0b9975b1dad9ed605dd4c6e68bcd
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Wed, 7 Jan 2015 15:31:33 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 15 Jan 2015 11:24:23 +0100

x86/apic: Correctly detect X2APIC status in function enable_IR()

X2APIC will be disabled if user specifies "nox2apic" on kernel command
line, even when x2apic_preenabled is true. So correctly detect X2APIC
status by using x2apic_enabled() instead of x2apic_preenabled.

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
Link: http://lkml.kernel.org/r/1420615903-28253-7-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/apic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 2dbd3a0..11358df 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1581,7 +1581,7 @@ int __init enable_IR(void)
 		return -1;
 	}
 
-	if (!x2apic_preenabled && skip_ioapic_setup) {
+	if (!x2apic_enabled() && skip_ioapic_setup) {
 		pr_info("Skipped enabling intr-remap because of skipping "
 			"io-apic setup\n");
 		return -1;
