Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab3IZRaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 13:30:55 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39938 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab3IZRay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 13:30:54 -0400
From: Masoud Sharbiani <masoud.sharbiani@gmail.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com
Cc: x86@kernel.org, akpm@linux-foundation.org, holt@sgi.com,
        msharbiani@twitter.com, linux-kernel@vger.kernel.org
Subject: [PATCH] Patch x86: Remove the duplicate C6100 entry in quirky motherboard boot list.
Date: Thu, 26 Sep 2013 10:30:43 -0700
Message-Id: <1380216643-4683-1-git-send-email-masoud.sharbiani@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masoud Sharbiani <msharbiani@twitter.com>

Two entries for the same system type were added, with two different vendor names: 'Dell' and 'Dell, Inc.'. Since a prefix match is being used, we can eliminate the latter.

Signed-off-by: Masoud Sharbiani <msharbiani@twitter.com>
---
 arch/x86/kernel/reboot.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index f0783a6..d9333a4 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -362,14 +362,6 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 		.callback = set_pci_reboot,
 		.ident = "Dell PowerEdge C6100",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "C6100"),
-		},
-	},
-	{	/* Some C6100 machines were shipped with vendor being 'Dell'. */
-		.callback = set_pci_reboot,
-		.ident = "Dell PowerEdge C6100",
-		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "C6100"),
 		},
-- 
1.7.9.5

