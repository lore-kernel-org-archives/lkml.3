Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294Ab3HSJTI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 05:19:08 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:53986 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab3HSJTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 05:19:05 -0400
From: navin patidar <navinp@cdac.in>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navinp@cdac.in>
Subject: [PATCH] staging: dgrp: add __init/__exit macros
Date: Mon, 19 Aug 2013 14:46:25 +0530
Message-Id: <1376903785-23789-1-git-send-email-navinp@cdac.in>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add __init/__exit macros to related init/cleanup functions.

Signed-off-by: navin patidar <navinp@cdac.in>
---
 drivers/staging/dgrp/dgrp_driver.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/dgrp/dgrp_driver.c b/drivers/staging/dgrp/dgrp_driver.c
index e456dc6c..08eedf0 100644
--- a/drivers/staging/dgrp/dgrp_driver.c
+++ b/drivers/staging/dgrp/dgrp_driver.c
@@ -52,19 +52,12 @@ MODULE_PARM_DESC(register_prdevices, "Turn on/off registering transparent print
 module_param_named(pollrate, dgrp_poll_tick, int, 0644);
 MODULE_PARM_DESC(pollrate, "Poll interval in ms");
 
-/* Driver load/unload functions */
-static int dgrp_init_module(void);
-static void dgrp_cleanup_module(void);
-
-module_init(dgrp_init_module);
-module_exit(dgrp_cleanup_module);
-
 /*
  * init_module()
  *
  * Module load.  This is where it all starts.
  */
-static int dgrp_init_module(void)
+static int __init dgrp_init_module(void)
 {
 	int ret;
 
@@ -89,7 +82,7 @@ static int dgrp_init_module(void)
 /*
  *	Module unload.  This is where it all ends.
  */
-static void dgrp_cleanup_module(void)
+static void __exit dgrp_cleanup_module(void)
 {
 	struct nd_struct *nd, *next;
 
@@ -108,3 +101,6 @@ static void dgrp_cleanup_module(void)
 		kfree(nd);
 	}
 }
+
+module_init(dgrp_init_module);
+module_exit(dgrp_cleanup_module);
-- 
1.7.10.4

