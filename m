Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965225Ab3GCTEh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:04:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23390 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965028Ab3GCTAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:31 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=4hGfEwxHZUsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=iooJ0GssOn4A:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=gLzmc-TWAAAA:8 a=QyXUC8HyAAAA:8 a=fBeKd2HRWbP4T1pgm1MA:9 a=MSl-tDqOz04A:10 a=9Z3QmPHuB9oA:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184059.473706974@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ash Willis <ashwillis@programmer.net>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [087/141] ACPI / video: ignore BIOS initial backlight value for HP Pavilion g6
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0087-ACPI-video-ignore-BIOS-initial-backlight-value-for-H.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Ash Willis <ashwillis.kernel@gmail.com>

[ Upstream commit 780a6ec640a3fed671fc2c40e4dd30c03eca3ac3 ]

This patch addresses kernel bug 56661. BIOS reports an incorrect
backlight value, causing the driver to switch off the backlight
completely during startup. This patch ignores the incorrect value from
BIOS.

References: https://bugzilla.kernel.org/show_bug.cgi?id=56661
Signed-off-by: Ash Willis <ashwillis@programmer.net>
Cc: All <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/acpi/video.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index ecdd2d7..69b1677 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -449,6 +449,14 @@ static struct dmi_system_id video_dmi_table[] __initdata = {
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
-- 
1.7.10.4


