Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbaLVRZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 12:25:55 -0500
Received: from senator.holtmann.net ([87.106.208.187]:34943 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223AbaLVRZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 12:25:54 -0500
From: Marcel Holtmann <marcel@holtmann.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] module: Remove double spaces in module verification taint message
Date: Mon, 22 Dec 2014 18:25:44 +0100
Message-Id: <1419269144-91285-1-git-send-email-marcel@holtmann.org>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The warning message when loading modules with a wrong signature has
two spaces in it:

"module verification failed: signature and/or  required key missing"

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
---
 kernel/module.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/module.c b/kernel/module.c
index e52a8739361a..57f786bae64d 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3242,7 +3242,7 @@ static int load_module(struct load_info *info, const char __user *uargs,
 	mod->sig_ok = info->sig_ok;
 	if (!mod->sig_ok) {
 		pr_notice_once("%s: module verification failed: signature "
-			       "and/or  required key missing - tainting "
+			       "and/or required key missing - tainting "
 			       "kernel\n", mod->name);
 		add_taint_module(mod, TAINT_UNSIGNED_MODULE, LOCKDEP_STILL_OK);
 	}
-- 
2.1.0

