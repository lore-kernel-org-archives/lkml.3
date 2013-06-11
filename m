Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab3FKUcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:32:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41689 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756324Ab3FKUDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:03:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ash Willis <ashwillis@programmer.net>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 20/32] ACPI / video: ignore BIOS initial backlight value for HP Pavilion g6
Date: Tue, 11 Jun 2013 13:03:19 -0700
Message-Id: <20130611200128.470576272@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611200126.214442788@linuxfoundation.org>
References: <20130611200126.214442788@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ash Willis <ashwillis.kernel@gmail.com>

commit 780a6ec640a3fed671fc2c40e4dd30c03eca3ac3 upstream.

This patch addresses kernel bug 56661. BIOS reports an incorrect
backlight value, causing the driver to switch off the backlight
completely during startup. This patch ignores the incorrect value from
BIOS.

References: https://bugzilla.kernel.org/show_bug.cgi?id=56661
Signed-off-by: Ash Willis <ashwillis@programmer.net>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/video.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -449,6 +449,14 @@ static struct dmi_system_id video_dmi_ta
 	},
 	{
 	 .callback = video_ignore_initial_backlight,
+	 .ident = "HP Pavilion g6 Notebook PC",
+	 .matches = {
+		 DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
+		 DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion g6 Notebook PC"),
+		},
+	},
+	{
+	 .callback = video_ignore_initial_backlight,
 	 .ident = "HP Pavilion m4",
 	 .matches = {
 		DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),


