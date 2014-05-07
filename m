Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369AbaEGJgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 05:36:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46428 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652AbaEGJgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 05:36:49 -0400
Date: Wed, 7 May 2014 02:31:06 -0700
From: tip-bot for Christian Gmeiner <tipbot@zytor.com>
Message-ID: <tip-aadca6fa4068ad1f92c492bc8507b7ed350825a2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, mjg59@srcf.ucam.org, davej@redhat.com,
        aubrey.li@linux.intel.com, akpm@linux-foundation.org,
        fenghua.yu@intel.com, tglx@linutronix.de, christian.gmeiner@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, mjg59@srcf.ucam.org, davej@redhat.com,
        aubrey.li@linux.intel.com, akpm@linux-foundation.org,
        fenghua.yu@intel.com, christian.gmeiner@gmail.com, tglx@linutronix.de
In-Reply-To: <1399446114-2147-1-git-send-email-christian.gmeiner@gmail.com>
References: <1399446114-2147-1-git-send-email-christian.gmeiner@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/reboot: Add reboot quirk for Certec BPC600
Git-Commit-ID: aadca6fa4068ad1f92c492bc8507b7ed350825a2
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

Commit-ID:  aadca6fa4068ad1f92c492bc8507b7ed350825a2
Gitweb:     http://git.kernel.org/tip/aadca6fa4068ad1f92c492bc8507b7ed350825a2
Author:     Christian Gmeiner <christian.gmeiner@gmail.com>
AuthorDate: Wed, 7 May 2014 09:01:54 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 7 May 2014 11:22:10 +0200

x86/reboot: Add reboot quirk for Certec BPC600

Certec BPC600 needs reboot=pci to actually reboot.

Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Li Aubrey <aubrey.li@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1399446114-2147-1-git-send-email-christian.gmeiner@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/reboot.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 3399d3a..52b1157 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -191,6 +191,16 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 		},
 	},
 
+	/* Certec */
+	{       /* Handle problems with rebooting on Certec BPC600 */
+		.callback = set_pci_reboot,
+		.ident = "Certec BPC600",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Certec"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "BPC600"),
+		},
+	},
+
 	/* Dell */
 	{	/* Handle problems with rebooting on Dell DXP061 */
 		.callback = set_bios_reboot,
