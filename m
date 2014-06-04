Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbaFDXXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:23:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40462 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600AbaFDXXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:23:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.14 199/228] ACPI / video: Add use_native_backlight quirks for more systems
Date: Wed,  4 Jun 2014 16:23:48 -0700
Message-Id: <20140604232354.424970329@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 43d9490244254d2d6adb0f3c6275c7b8d032a2dd upstream.

ThinkPad T430: extend the T430s entry to also cover the T430 (note we also
have another entry for T430's with a different DMI_PRODUCT_VERSION).

ThinkPad T430
Reported-and-tested-by: edm <fuffi.il.fuffo@gmail.com>
References: https://bugzilla.kernel.org/show_bug.cgi?id=51231

Thinkpad T530
Reported-and-tested-by: Balint Szigeti <balint.szgt@gmail.com>
References: https://bugzilla.redhat.com/show_bug.cgi?id=1089545

Acer Aspire 5742G
Reported-and-tested-by: AnAkkk <anakin.cs@gmail.com>
References: https://bugzilla.kernel.org/show_bug.cgi?id=35622

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/video.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -459,10 +459,10 @@ static struct dmi_system_id video_dmi_ta
 	},
 	{
 	 .callback = video_set_use_native_backlight,
-	 .ident = "ThinkPad T430s",
+	 .ident = "ThinkPad T430 and T430s",
 	 .matches = {
 		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T430s"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T430"),
 		},
 	},
 	{
@@ -474,6 +474,14 @@ static struct dmi_system_id video_dmi_ta
 		},
 	},
 	{
+	 .callback = video_set_use_native_backlight,
+	 .ident = "ThinkPad T530",
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T530"),
+		},
+	},
+	{
 	.callback = video_set_use_native_backlight,
 	.ident = "ThinkPad X1 Carbon",
 	.matches = {
@@ -506,6 +514,14 @@ static struct dmi_system_id video_dmi_ta
 		},
 	},
 	{
+	 .callback = video_set_use_native_backlight,
+	 .ident = "Acer Aspire 5742G",
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5742G"),
+		},
+	},
+	{
 	 .callback = video_set_use_native_backlight,
 	 .ident = "Acer Aspire V5-431",
 	 .matches = {


