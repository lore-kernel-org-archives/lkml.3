Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484AbbAIKkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:40:24 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44587 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757482AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Luis Henriques <luis.henriques@canonical.com>,
        Zhang Rui <rui.zhang@intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 53/78] thermal: Fix error path in thermal_init()
Date: Fri,  9 Jan 2015 11:32:02 +0100
Message-Id: <f7c68a1aa5d3bf2e94c548c8d77de50640a11209.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luis Henriques <luis.henriques@canonical.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 9d367e5e7b05c71a8c1ac4e9b6e00ba45a79f2fc upstream.

thermal_unregister_governors() and class_unregister() were being called in
the wrong order.

Fixes: 80a26a5c22b9 ("Thermal: build thermal governors into thermal_sys module")
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/thermal/thermal_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 4962a6aaf295..4f35f1ca3ce3 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1747,10 +1747,10 @@ static int __init thermal_init(void)
 
 	return 0;
 
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
2.2.1

