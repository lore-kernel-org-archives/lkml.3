Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460Ab3JJPt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:49:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52937 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757390Ab3JJPtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:49:20 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Masoud Sharbiani <msharbiani@twitter.com>, Vinson Lee <vlee@twitter.com>,
        Robin Holt <holt@sgi.com>, Russell King <rmk+kernel@arm.linux.org.uk>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Ingo Molnar <mingo@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 061/104] x86/reboot: Add quirk to make Dell C6100 use reboot=pci automatically
Date: Thu, 10 Oct 2013 08:41:49 -0700
Message-Id: <1381419752-29733-62-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masoud Sharbiani <msharbiani@twitter.com>

commit 4f0acd31c31f03ba42494c8baf6c0465150e2621 upstream.

Dell PowerEdge C6100 machines fail to completely reboot about 20% of the time.

Signed-off-by: Masoud Sharbiani <msharbiani@twitter.com>
Signed-off-by: Vinson Lee <vlee@twitter.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Link: http://lkml.kernel.org/r/1379717947-18042-1-git-send-email-vlee@freedesktop.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kernel/reboot.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 76fa1e9..90fd119 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -447,6 +447,22 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
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

