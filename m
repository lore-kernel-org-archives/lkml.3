Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933498Ab3BLTka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 14:40:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933274Ab3BLTk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 14:40:28 -0500
From: Richard Guy Briggs <rbriggs@redhat.com>
To: Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rbriggs@redhat.com>
Subject: [PATCH] thermal: return an error on failure to register thermal class
Date: Tue, 12 Feb 2013 14:39:44 -0500
Message-Id: <1360697984-19960-1-git-send-email-rbriggs@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return code from the registration of the thermal class is used to
unallocate resources, but this failure isn't passed back to the caller of
thermal_init.  Return this failure back to the caller.

This bug was introduced in changeset 4cb18728 which overwrote the return code
when the variable was re-used to catch the return code of the registration of
the genetlink thermal socket family.

Signed-off-by: Richard Guy Briggs <rbriggs@redhat.com>
---
 drivers/thermal/thermal_sys.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 8c8ce80..bfbf9fb 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -1807,6 +1807,7 @@ static int __init thermal_init(void)
 		idr_destroy(&thermal_cdev_idr);
 		mutex_destroy(&thermal_idr_lock);
 		mutex_destroy(&thermal_list_lock);
+		return result;
 	}
 	result = genetlink_init();
 	return result;
-- 
1.8.0.2

