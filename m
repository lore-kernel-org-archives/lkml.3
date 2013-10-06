Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab3JFOEz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 10:04:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46651 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479Ab3JFOEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 10:04:50 -0400
Date: Sun, 6 Oct 2013 07:04:39 -0700
From: "=?UTF-8?B?dGlwLWJvdCBmb3IgVmlsbGUgU3lyasOkbMOk?=" <tipbot@zytor.com>
Message-ID: <tip-8412da757776727796e9edd64ba94814cc08d536@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ville.syrjala@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ville.syrjala@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1380888964-14517-1-git-send-email-ville.syrjala@linux.intel.com>
References: <1380888964-14517-1-git-send-email-ville.syrjala@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/reboot:
  Add reboot quirk for Dell Latitude E5410
Git-Commit-ID: 8412da757776727796e9edd64ba94814cc08d536
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 06 Oct 2013 07:04:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8412da757776727796e9edd64ba94814cc08d536
Gitweb:     http://git.kernel.org/tip/8412da757776727796e9edd64ba94814cc08d536
Author:     Ville Syrjälä <ville.syrjala@linux.intel.com>
AuthorDate: Fri, 4 Oct 2013 15:16:04 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 6 Oct 2013 11:49:07 +0200

x86/reboot: Add reboot quirk for Dell Latitude E5410

Dell Latitude E5410 needs reboot=pci to actually reboot.

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: http://lkml.kernel.org/r/1380888964-14517-1-git-send-email-ville.syrjala@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/reboot.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index e643e74..7e920bf 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -326,6 +326,14 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E6320"),
 		},
 	},
+	{	/* Handle problems with rebooting on the Latitude E5410. */
+		.callback = set_pci_reboot,
+		.ident = "Dell Latitude E5410",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E5410"),
+		},
+	},
 	{	/* Handle problems with rebooting on the Latitude E5420. */
 		.callback = set_pci_reboot,
 		.ident = "Dell Latitude E5420",
