Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbaIOUxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:53:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54700 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052AbaIOT1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:27:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.16 105/158] ACPI / video: Disable native_backlight on HP ENVY 15 Notebook PC
Date: Mon, 15 Sep 2014 12:25:44 -0700
Message-Id: <20140915192546.031089150@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 84c34858a85ecf9dabd72847d860c7d3fb7536e7 upstream.

Link: https://bugs.freedesktop.org/show_bug.cgi?id=81515
Reported-and-tested-by: Hohahiu <rakothedin@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/video.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -675,6 +675,17 @@ static struct dmi_system_id video_dmi_ta
 		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T520"),
 		},
 	},
+
+	/* The native backlight controls do not work on some older machines */
+	{
+	 /* https://bugs.freedesktop.org/show_bug.cgi?id=81515 */
+	 .callback = video_disable_native_backlight,
+	 .ident = "HP ENVY 15 Notebook",
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "HP ENVY 15 Notebook PC"),
+		},
+	},
 	{}
 };
 


