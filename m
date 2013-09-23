Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab3IWNia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 09:38:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43226 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab3IWNi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 09:38:26 -0400
Date: Mon, 23 Sep 2013 06:37:40 -0700
From: tip-bot for Masoud Sharbiani <tipbot@zytor.com>
Message-ID: <tip-4f0acd31c31f03ba42494c8baf6c0465150e2621@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rmk+kernel@arm.linux.org.uk, holt@sgi.com, stable@vger.kernel.org,
        tglx@linutronix.de, gxt@mprc.pku.edu.cn, msharbiani@twitter.com,
        vlee@twitter.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        holt@sgi.com, rmk+kernel@arm.linux.org.uk, stable@vger.kernel.org,
        tglx@linutronix.de, gxt@mprc.pku.edu.cn, vlee@twitter.com,
        msharbiani@twitter.com
In-Reply-To: <1379717947-18042-1-git-send-email-vlee@freedesktop.org>
References: <1379717947-18042-1-git-send-email-vlee@freedesktop.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/reboot:
  Add quirk to make Dell C6100 use reboot=pci automatically
Git-Commit-ID: 4f0acd31c31f03ba42494c8baf6c0465150e2621
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 23 Sep 2013 06:37:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4f0acd31c31f03ba42494c8baf6c0465150e2621
Gitweb:     http://git.kernel.org/tip/4f0acd31c31f03ba42494c8baf6c0465150e2621
Author:     Masoud Sharbiani <msharbiani@twitter.com>
AuthorDate: Fri, 20 Sep 2013 15:59:07 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 23 Sep 2013 10:26:08 +0200

x86/reboot: Add quirk to make Dell C6100 use reboot=pci automatically

Dell PowerEdge C6100 machines fail to completely reboot about 20% of the time.

Signed-off-by: Masoud Sharbiani <msharbiani@twitter.com>
Signed-off-by: Vinson Lee <vlee@twitter.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/1379717947-18042-1-git-send-email-vlee@freedesktop.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/reboot.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 563ed91..5f4ad27 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -358,6 +358,22 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
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
 
