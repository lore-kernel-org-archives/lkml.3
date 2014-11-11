Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaKKL0A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:26:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57741 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287AbaKKLLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:11:04 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 129/170] Input: i8042 - quirks for Fujitsu Lifebook A544 and Lifebook AH544
Date: Tue, 11 Nov 2014 11:08:08 +0000
Message-Id: <1415704129-12709-130-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 993b3a3f80a7842a48cd46c2b41e1b3ef6302468 upstream.

These models need i8042.notimeout, otherwise the touchpad will not work.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=69731
BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1111138
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/input/serio/i8042-x86ia64io.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 713e3ddb43bd..11137969f1d5 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -616,6 +616,22 @@ static const struct dmi_system_id __initconst i8042_dmi_notimeout_table[] = {
 		},
 	},
 	{
+		/* Fujitsu A544 laptop */
+		/* https://bugzilla.redhat.com/show_bug.cgi?id=1111138 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK A544"),
+		},
+	},
+	{
+		/* Fujitsu AH544 laptop */
+		/* https://bugzilla.kernel.org/show_bug.cgi?id=69731 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK AH544"),
+		},
+	},
+	{
 		/* Fujitsu U574 laptop */
 		/* https://bugzilla.kernel.org/show_bug.cgi?id=69731 */
 		.matches = {
-- 
2.1.0

