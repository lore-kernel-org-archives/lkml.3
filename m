Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbaEBQUq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:20:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43765 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbaEBPjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:39:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Matthew Garrett <matthew.garrett@nebula.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 134/151] thinkpad_acpi: Fix inconsistent mute LED after resume
Date: Fri,  2 May 2014 08:38:42 -0700
Message-Id: <1399045139-4531-135-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 119f449866ad18785b0445adaf0d2859c6dbdaa3 upstream.

The mute LED states have to be restored after resume.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=70351
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/platform/x86/thinkpad_acpi.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 58b0274..7b5e523 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -8453,9 +8453,21 @@ static void mute_led_exit(void)
 		tpacpi_led_set(i, false);
 }
 
+static void mute_led_resume(void)
+{
+	int i;
+
+	for (i = 0; i < TPACPI_LED_MAX; i++) {
+		struct tp_led_table *t = &led_tables[i];
+		if (t->state >= 0)
+			mute_led_on_off(t, t->state);
+	}
+}
+
 static struct ibm_struct mute_led_driver_data = {
 	.name = "mute_led",
 	.exit = mute_led_exit,
+	.resume = mute_led_resume,
 };
 
 /****************************************************************************
-- 
1.9.1

