Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933852AbaEKTZu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:25:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48430 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757669AbaEKTZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:25:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 3.14 74/83] thinkpad_acpi: Fix inconsistent mute LED after resume
Date: Sun, 11 May 2014 21:20:15 +0200
Message-Id: <20140511191916.581057013@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191907.024339448@linuxfoundation.org>
References: <20140511191907.024339448@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 119f449866ad18785b0445adaf0d2859c6dbdaa3 upstream.

The mute LED states have to be restored after resume.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=70351
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/thinkpad_acpi.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -8447,9 +8447,21 @@ static void mute_led_exit(void)
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


