Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbaHRKIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 06:08:41 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:41257 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbaHRJdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:33:39 -0400
From: Arjun Sreedharan <arjun024@gmail.com>
To: rui.zhang@intel.com
Cc: jacob.jun.pan@linux.intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH] tools/thermal: fix calloc argument ordering
Date: Mon, 18 Aug 2014 15:03:20 +0530
Message-Id: <1408354400-1656-1-git-send-email-arjun024@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

@number first, @size second argument

Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
---
 tools/thermal/tmon/sysfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/thermal/tmon/sysfs.c b/tools/thermal/tmon/sysfs.c
index dfe4548..1c12536 100644
--- a/tools/thermal/tmon/sysfs.c
+++ b/tools/thermal/tmon/sysfs.c
@@ -446,7 +446,7 @@ int probe_thermal_sysfs(void)
 		return -1;
 	}
 
-	ptdata.tzi = calloc(sizeof(struct tz_info), ptdata.max_tz_instance+1);
+	ptdata.tzi = calloc(ptdata.max_tz_instance+1, sizeof(struct tz_info));
 	if (!ptdata.tzi) {
 		fprintf(stderr, "Err: allocate tz_info\n");
 		return -1;
@@ -454,8 +454,8 @@ int probe_thermal_sysfs(void)
 
 	/* we still show thermal zone information if there is no cdev */
 	if (ptdata.nr_cooling_dev) {
-		ptdata.cdi = calloc(sizeof(struct cdev_info),
-				ptdata.max_cdev_instance + 1);
+		ptdata.cdi = calloc(ptdata.max_cdev_instance + 1,
+				sizeof(struct cdev_info));
 		if (!ptdata.cdi) {
 			free(ptdata.tzi);
 			fprintf(stderr, "Err: allocate cdev_info\n");
-- 
1.8.1.msysgit.1

