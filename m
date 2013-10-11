Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab3JKKnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:43:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58557 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757903Ab3JKKnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:43:17 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Masoud Sharbiani <msharbiani@twitter.com>, Vinson Lee <vlee@twitter.com>,
        Robin Holt <holt@sgi.com>, Russell King <rmk+kernel@arm.linux.org.uk>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Ingo Molnar <mingo@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 039/100] x86/reboot: Add quirk to make Dell C6100 use reboot=pci automatically
Date: Fri, 11 Oct 2013 11:41:09 +0100
Message-Id: <1381488130-30235-40-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kernel/reboot.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 2a29384..d1ef8a7 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -459,6 +459,22 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
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
1.8.3.2

