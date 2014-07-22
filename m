Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbaGVPhk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 11:37:40 -0400
Received: from smtprelay06.ispgateway.de ([80.67.31.95]:57870 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020AbaGVPhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 11:37:22 -0400
From: Peter Feuerer <peter@piie.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Feuerer <peter@piie.net>, Andrew Morton <akpm@linux-foundation.org>,
        Andreas Mohr <andi@lisas.de>, Borislav Petkov <bp@suse.de>,
        Javi Merino <javi.merino@arm.com>
Subject: [PATCH v5 5/6] acerhdf: added critical trip point
Date: Tue, 22 Jul 2014 17:37:15 +0200
Message-Id: <1406043436-17068-6-git-send-email-peter@piie.net>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <1406043436-17068-1-git-send-email-peter@piie.net>
References: <1398561815-22033-1-git-send-email-peter@piie.net>
 <1406043436-17068-1-git-send-email-peter@piie.net>
X-Df-Sender: cGV0ZXJAcGlpZS5uZXQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

added critical trip point which represents the temperature limit.
Added return -EINVAL in case wrong trip point is provided.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Mohr <andi@lisas.de>
Cc: Borislav Petkov <bp@suse.de>
Cc: Javi Merino <javi.merino@arm.com>
Signed-off-by: Peter Feuerer <peter@piie.net>
---
 drivers/platform/x86/acerhdf.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index 7fe7dbf..91b16c8 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -443,6 +443,10 @@ static int acerhdf_get_trip_type(struct thermal_zone_device *thermal, int trip,
 {
 	if (trip == 0)
 		*type = THERMAL_TRIP_ACTIVE;
+	else if (trip == 1)
+		*type = THERMAL_TRIP_CRITICAL;
+	else
+		return -EINVAL;
 
 	return 0;
 }
@@ -463,6 +467,10 @@ static int acerhdf_get_trip_temp(struct thermal_zone_device *thermal, int trip,
 {
 	if (trip == 0)
 		*temp = fanon;
+	else if (trip == 1)
+		*temp = ACERHDF_TEMP_CRIT;
+	else
+		return -EINVAL;
 
 	return 0;
 }
@@ -713,7 +721,7 @@ static int acerhdf_register_thermal(void)
 	if (IS_ERR(cl_dev))
 		return -EINVAL;
 
-	thz_dev = thermal_zone_device_register("acerhdf", 1, 0, NULL,
+	thz_dev = thermal_zone_device_register("acerhdf", 2, 0, NULL,
 					      &acerhdf_dev_ops,
 					      &acerhdf_zone_params, 0,
 					      (kernelmode) ? interval*1000 : 0);
-- 
2.0.2

