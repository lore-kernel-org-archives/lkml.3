Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751169AbaLBI1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:27:11 -0500
Received: from mga01.intel.com ([192.55.52.88]:52142 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbaLBI1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:27:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="423905757"
From: Todor Minchev <todor.minchev@intel.com>
To: linux-kernel@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        Todor Minchev <todor.minchev@intel.com>
Subject: [PATCH] i8042: prevent the loading of the i8042 driver on Intel NUC D54250WYK
Date: Tue,  2 Dec 2014 08:27:02 +0000
Message-Id: <1417508822-8243-1-git-send-email-todor.minchev@intel.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Intel NUC D54250WYK has no PS/2 controller, however the DSDT declares
PS/2 devices which trigger the loading of the i8042 driver.

Signed-off-by: Todor Minchev <todor.minchev@intel.com>
---
 drivers/input/serio/i8042-x86ia64io.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index faeeb13..5182008 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -579,6 +579,13 @@ static const struct dmi_system_id __initconst i8042_dmi_nopnp_table[] = {
 		},
 	},
 	{
+		/* Intel NUC D54250WYK */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "D54250WYK"),
+			DMI_MATCH(DMI_BOARD_VENDOR, "Intel Corporation"),
+		},
+	},
+	{
 		/* MSI Wind U-100 */
 		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "U-100"),
-- 
2.1.3

