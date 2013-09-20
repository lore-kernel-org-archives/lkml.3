Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab3ITW7K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 18:59:10 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:44644 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab3ITW7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 18:59:08 -0400
From: Vinson Lee <vlee@freedesktop.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Robin Holt <holt@sgi.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org
Cc: Vinson Lee <vlee@freedesktop.org>,
        Masoud Sharbiani <msharbiani@twitter.com>, stable@vger.kernel.org,
        Vinson Lee <vlee@twitter.com>
Subject: [PATCH] x86: Add quirk to make Dell C6100 use reboot=pci.
Date: Fri, 20 Sep 2013 15:59:07 -0700
Message-Id: <1379717947-18042-1-git-send-email-vlee@freedesktop.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masoud Sharbiani <msharbiani@twitter.com>

Dell PowerEdge C6100 machines fail to completely reboot about 20% of the
time.

Signed-off-by: Masoud Sharbiani <msharbiani@twitter.com>
Cc: stable@vger.kernel.org
Signed-off-by: Vinson Lee <vlee@twitter.com>
---
 arch/x86/kernel/reboot.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index df1b604..d139208 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -479,6 +479,22 @@ static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Precision M6600"),
 		},
 	},
+	{	/* Handle problems with rebooting on the Dell PowerEdge C6100. */
+		.callback = set_pci_reboot,
+		.ident = "Dell PowerEdge C6100",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "C6100"),
+		},
+	},
+	{	/* Some C6100 machines were shipped with vendor being 'Dell'. */
+		.callback = set_pci_reboot,
+		.ident = "Dell PowerEdge C6100",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "C6100"),
+		},
+	},
 	{ }
 };
 
-- 
1.8.1.2

