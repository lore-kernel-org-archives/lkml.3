Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab3HVSfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 14:35:41 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:52879 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766Ab3HVSfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 14:35:39 -0400
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <lenb@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [RESEND/PATCH] acpi: video: remove unused code
Date: Thu, 22 Aug 2013 13:31:11 -0500
Message-Id: <1377196271-20427-1-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.8.3.269.g65753d8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_BCM_use_index and _BCL_use_index are never used and probably never will.

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 drivers/acpi/video.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index e1284b8..e6be27e 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -185,8 +185,6 @@ struct acpi_video_device_cap {
 struct acpi_video_brightness_flags {
 	u8 _BCL_no_ac_battery_levels:1;	/* no AC/Battery levels in _BCL */
 	u8 _BCL_reversed:1;		/* _BCL package is in a reversed order*/
-	u8 _BCL_use_index:1;		/* levels in _BCL are index values */
-	u8 _BCM_use_index:1;		/* input of _BCM is an index value */
 	u8 _BQC_use_index:1;		/* _BQC returns an index value */
 };
 
@@ -806,16 +804,6 @@ acpi_video_init_brightness(struct acpi_video_device *device)
 	br->count = count;
 	device->brightness = br;
 
-	/* Check the input/output of _BQC/_BCL/_BCM */
-	if ((max_level < 100) && (max_level <= (count - 2)))
-		br->flags._BCL_use_index = 1;
-
-	/*
-	 * _BCM is always consistent with _BCL,
-	 * at least for all the laptops we have ever seen.
-	 */
-	br->flags._BCM_use_index = br->flags._BCL_use_index;
-
 	/* _BQC uses INDEX while _BCL uses VALUE in some laptops */
 	br->curr = level = max_level;
 
-- 
1.8.3.269.g65753d8

