Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757745Ab3CDDrl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:47:41 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33170 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757176Ab3CDDov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:44:51 -0500
Message-Id: <20130304033710.534793219@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:37:37 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 030/153] ACPI: Add DMI entry for Sony VGN-FW41E_H
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Salisbury <joseph.salisbury@canonical.com>

commit 66f2fda93b67fa744d406e6dcf443f67bac204b6 upstream.

This patch adds a quirk to allow the Sony VGN-FW41E_H to suspend/resume
properly.

References: http://bugs.launchpad.net/bugs/1113547
Signed-off-by: Joseph Salisbury <joseph.salisbury@canonical.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/acpi/sleep.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -156,6 +156,14 @@ static struct dmi_system_id __initdata a
 	},
 	{
 	.callback = init_nvs_nosave,
+	.ident = "Sony Vaio VGN-FW41E_H",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "VGN-FW41E_H"),
+		},
+	},
+	{
+	.callback = init_nvs_nosave,
 	.ident = "Sony Vaio VGN-FW21E",
 	.matches = {
 		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),


