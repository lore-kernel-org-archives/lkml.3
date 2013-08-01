Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461Ab3HAXhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 19:37:38 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:53125 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab3HAXhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 19:37:36 -0400
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Aaron Lu <aaron.lwe@gmail.com>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH] acpi: video: fix reversed indexed BQC
Date: Thu,  1 Aug 2013 18:34:02 -0500
Message-Id: <1375400042-989-1-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.8.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1a7c618 (ACPI video: support _BQC/_BCL/_BCM methods that use
index values) assumed that bl->levels were not reverted, but at this
point they already are, so there's no need to revert them yet again.

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 drivers/acpi/video.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 0ec434d..b27c049 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -499,19 +499,10 @@ acpi_video_bqc_value_to_level(struct acpi_video_device *device,
 {
 	unsigned long long level;
 
-	if (device->brightness->flags._BQC_use_index) {
-		/*
-		 * _BQC returns an index that doesn't account for
-		 * the first 2 items with special meaning, so we need
-		 * to compensate for that by offsetting ourselves
-		 */
-		if (device->brightness->flags._BCL_reversed)
-			bqc_value = device->brightness->count - 3 - bqc_value;
-
+	if (device->brightness->flags._BQC_use_index)
 		level = device->brightness->levels[bqc_value + 2];
-	} else {
+	else
 		level = bqc_value;
-	}
 
 	level += bqc_offset_aml_bug_workaround;
 
-- 
1.8.3.4

