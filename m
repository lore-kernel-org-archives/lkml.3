Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbaLCVU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 16:20:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53861 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbaLCVU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 16:20:26 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: Zhang Rui <rui.zhang@intel.com>, Eduardo Valentin <edubezval@gmail.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Henriques <luis.henriques@canonical.com>, stable@vger.kernel.org
Subject: [PATCH] thermal: Fix error path in thermal_init()
Date: Wed,  3 Dec 2014 21:20:21 +0000
Message-Id: <1417641621-5674-1-git-send-email-luis.henriques@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thermal_unregister_governors() and class_unregister() were being called in
the wrong order.

Fixes: 80a26a5c22b9 ("Thermal: build thermal governors into thermal_sys module")
Cc: stable@vger.kernel.org
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/thermal/thermal_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 43b90709585f..488e9bfd996b 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1835,10 +1835,10 @@ static int __init thermal_init(void)
 
 exit_netlink:
 	genetlink_exit();
-unregister_governors:
-	thermal_unregister_governors();
 unregister_class:
 	class_unregister(&thermal_class);
+unregister_governors:
+	thermal_unregister_governors();
 error:
 	idr_destroy(&thermal_tz_idr);
 	idr_destroy(&thermal_cdev_idr);
