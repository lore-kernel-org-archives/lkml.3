Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab3IZS7L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 14:59:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54380 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab3IZS7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 14:59:09 -0400
Date: Thu, 26 Sep 2013 11:58:38 -0700
From: tip-bot for Masoud Sharbiani <tipbot@zytor.com>
Message-ID: <tip-b5eafc6f07c95e9f3dd047e72737449cb03c9956@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, msharbiani@twitter.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, msharbiani@twitter.com
In-Reply-To: <1380216643-4683-1-git-send-email-masoud.sharbiani@gmail.com>
References: <1380216643-4683-1-git-send-email-masoud.sharbiani@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/reboot] x86/reboot:
  Remove the duplicate C6100 entry in the reboot quirks list
Git-Commit-ID: b5eafc6f07c95e9f3dd047e72737449cb03c9956
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 26 Sep 2013 11:58:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b5eafc6f07c95e9f3dd047e72737449cb03c9956
Gitweb:     http://git.kernel.org/tip/b5eafc6f07c95e9f3dd047e72737449cb03c9956
Author:     Masoud Sharbiani <msharbiani@twitter.com>
AuthorDate: Thu, 26 Sep 2013 10:30:43 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 26 Sep 2013 20:52:37 +0200

x86/reboot: Remove the duplicate C6100 entry in the reboot quirks list

Two entries for the same system type were added, with two different vendor
names: 'Dell' and 'Dell, Inc.'.

Since a prefix match is being used by the DMI parsing code, we can eliminate
the latter as redundant.

Reported-by: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Masoud Sharbiani <msharbiani@twitter.com>
Cc: holt@sgi.com
Link: http://lkml.kernel.org/r/1380216643-4683-1-git-send-email-masoud.sharbiani@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/reboot.c | 8 --------
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
