Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab3JGCFz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 22:05:55 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:38022 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab3JGCFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 22:05:53 -0400
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH] acpi: add missing win8 OSI comment to blacklist
Date: Sun,  6 Oct 2013 20:59:55 -0500
Message-Id: <1381111195-21597-1-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.8.4-fc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In my original patch[1] I wrote a comment describing the reason for
disabling Windows 2012 OSI mode for a group of machines, however, due to
unknown reasons (probably a conflict resolution mismatch), the comment
was dropped in 94fb982 (ACPI: blacklist win8 OSI for buggy laptops).

Since Matthew Garrett is making a big deal out of the lack of comments
in a separate patch[2], it might make sense to re-introduce the missing
comment so that other patch is not blocked and users don't suffer.

[1] http://article.gmane.org/gmane.linux.acpi.devel/63427
[2] http://thread.gmane.org/gmane.linux.kernel/1572459

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 drivers/acpi/blacklist.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/acpi/blacklist.c b/drivers/acpi/blacklist.c
index 9515f18..42cccbe 100644
--- a/drivers/acpi/blacklist.c
+++ b/drivers/acpi/blacklist.c
@@ -273,6 +273,11 @@ static struct dmi_system_id acpi_osi_dmi_table[] __initdata = {
 		     DMI_MATCH(DMI_PRODUCT_NAME, "Satellite P305D"),
 		},
 	},
+
+	/*
+	 * The following machines have broken backlight support when reporting
+	 * the Windows 2012 OSI, so disable it until their support is fixed.
+	 */
 	{
 	.callback = dmi_disable_osi_win8,
 	.ident = "ASUS Zenbook Prime UX31A",
-- 
1.8.4-fc

