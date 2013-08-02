Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab3HBE4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 00:56:33 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:57274 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab3HBE4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 00:56:31 -0400
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Aaron Lu <aaron.lwe@gmail.com>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH] acpi: video: remove unused code
Date: Thu,  1 Aug 2013 23:52:57 -0500
Message-Id: <1375419177-10431-1-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.8.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_BCM_use_index is never used and probably never will.

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 drivers/acpi/video.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 0ec434d..54e2d4d 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -186,7 +186,6 @@ struct acpi_video_brightness_flags {
 	u8 _BCL_no_ac_battery_levels:1;	/* no AC/Battery levels in _BCL */
 	u8 _BCL_reversed:1;		/* _BCL package is in a reversed order*/
 	u8 _BCL_use_index:1;		/* levels in _BCL are index values */
-	u8 _BCM_use_index:1;		/* input of _BCM is an index value */
 	u8 _BQC_use_index:1;		/* _BQC returns an index value */
 };
 
@@ -810,12 +809,6 @@ acpi_video_init_brightness(struct acpi_video_device *device)
 	if ((max_level < 100) && (max_level <= (count - 2)))
 		br->flags._BCL_use_index = 1;
 
-	/*
-	 * _BCM is always consistent with _BCL,
-	 * at least for all the laptops we have ever seen.
-	 */
-	br->flags._BCM_use_index = br->flags._BCL_use_index;
-
 	/* _BQC uses INDEX while _BCL uses VALUE in some laptops */
 	br->curr = level = max_level;
 
-- 
1.8.3.4

