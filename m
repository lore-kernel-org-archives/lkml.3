Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab3BEAST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 19:18:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42226 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab3BEASR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 19:18:17 -0500
From: joseph.salisbury@canonical.com
To: linux-kernel@vger.kernel.org
Cc: lenb@kernel.org, rjw@sisk.pl, linux-acpi@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 1/1] ACPI: Add DMI entry for Sony VGN-FW41E_H
Date: Mon,  4 Feb 2013 19:16:29 -0500
Message-Id: <d13ef85181ffd5166cd3cc51fe0b1d2247068dbc.1360010329.git.joseph.salisbury@canonical.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <cover.1360010329.git.joseph.salisbury@canonical.com>
References: <cover.1360010329.git.joseph.salisbury@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joseph Salisbury <joseph.salisbury@canonical.com>

BugLink: http://bugs.launchpad.net/bugs/1113547

This patch adds a quirk to allow the Sony VGN-FW41E_H suspend/resume properly.

Signed-off-by: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: lenb@kernel.org
Cc: rjw@sisk.pl
Cc: linux-acpi@vger.kernel.org
Cc: stable@vger.kernel.org

---
 drivers/acpi/sleep.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 2fcc67d..df85051 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -177,6 +177,14 @@ static struct dmi_system_id __initdata acpisleep_dmi_table[] = {
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
-- 
1.7.9.5

