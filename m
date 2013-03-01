Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab3CAUNY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:13:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51557 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab3CATpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:45:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 67/77] ACPI: Add DMI entry for Sony VGN-FW41E_H
Date: Fri,  1 Mar 2013 11:44:52 -0800
Message-Id: <20130301194359.045763244@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194351.913471337@linuxfoundation.org>
References: <20130301194351.913471337@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Salisbury <joseph.salisbury@canonical.com>

commit 66f2fda93b67fa744d406e6dcf443f67bac204b6 upstream.

This patch adds a quirk to allow the Sony VGN-FW41E_H to suspend/resume
properly.

References: http://bugs.launchpad.net/bugs/1113547
Signed-off-by: Joseph Salisbury <joseph.salisbury@canonical.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/sleep.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -177,6 +177,14 @@ static struct dmi_system_id __initdata a
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


