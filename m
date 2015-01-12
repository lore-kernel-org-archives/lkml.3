Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbbALSMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:12:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57744 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825AbbALSGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:39 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Zhang Rui <rui.zhang@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 096/216] thermal: Fix error path in thermal_init()
Date: Mon, 12 Jan 2015 18:03:33 +0000
Message-Id: <1421085933-32536-97-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luis Henriques <luis.henriques@canonical.com>

commit 9d367e5e7b05c71a8c1ac4e9b6e00ba45a79f2fc upstream.

thermal_unregister_governors() and class_unregister() were being called in
the wrong order.

Fixes: 80a26a5c22b9 ("Thermal: build thermal governors into thermal_sys module")
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/thermal/thermal_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 71b0ec0c370d..284733e1fb6f 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1824,10 +1824,10 @@ static int __init thermal_init(void)
 
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
-- 
2.1.4

