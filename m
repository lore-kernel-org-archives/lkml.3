Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933607AbaKLBfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:35:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59688 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932641AbaKLBfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:35:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: [PATCH 3.17 295/319] samsung-laptop: Add broken-acpi-video quirk for NC210/NC110
Date: Wed, 12 Nov 2014 10:17:13 +0900
Message-Id: <20141112011041.677057059@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 5a1426c99f9b7aa11d60c4e6b7a3211bb5321696 upstream.

The acpi-video backlight interface on the NC210 does not work, blacklist it
and use the samsung-laptop interface instead.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=861573
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/samsung-laptop.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -1561,6 +1561,16 @@ static struct dmi_system_id __initdata s
 	},
 	{
 	 .callback = samsung_dmi_matched,
+	 .ident = "NC210",
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "NC210/NC110"),
+		DMI_MATCH(DMI_BOARD_NAME, "NC210/NC110"),
+		},
+	 .driver_data = &samsung_broken_acpi_video,
+	},
+	{
+	 .callback = samsung_dmi_matched,
 	 .ident = "730U3E/740U3E",
 	 .matches = {
 		DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),


