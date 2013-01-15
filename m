Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933158Ab3AOWuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:50:16 -0500
Received: from mail.kernel.org ([198.145.19.201]:45890 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932980Ab3AOWuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:50:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Seth Forshee <seth.forshee@canonical.com>,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [ 056/171] samsung-laptop: Add quirk for broken acpi_video backlight on N250P
Date: Tue, 15 Jan 2013 14:43:41 -0800
Message-Id: <20130115224317.464750149@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seth Forshee <seth.forshee@canonical.com>

commit e04c200f1f2de8eaa2f5af6d97e7e213a1abb424 upstream.

BugLink: http://bugs.launchpad.net/bugs/1086921
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/samsung-laptop.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -1506,6 +1506,16 @@ static struct dmi_system_id __initdata s
 		},
 	 .driver_data = &samsung_broken_acpi_video,
 	},
+	{
+	 .callback = samsung_dmi_matched,
+	 .ident = "N250P",
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "N250P"),
+		DMI_MATCH(DMI_BOARD_NAME, "N250P"),
+		},
+	 .driver_data = &samsung_broken_acpi_video,
+	},
 	{ },
 };
 MODULE_DEVICE_TABLE(dmi, samsung_dmi_table);


