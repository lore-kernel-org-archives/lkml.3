Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444AbaJOIaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 04:30:14 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:51214 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbaJOIaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 04:30:11 -0400
From: Michele Curti <michele.curti@gmail.com>
To: davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, Michele Curti <michele.curti@gmail.com>
Subject: [PATCH] kernel/jump_label.c: declare jump_label_module_nb as static
Date: Wed, 15 Oct 2014 10:30:01 +0200
Message-Id: <1413361801-17003-1-git-send-email-michele.curti@gmail.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The structure jump_label_module_nb is used in jump_label.c only,
so declare it as static

Signed-off-by: Michele Curti <michele.curti@gmail.com>
---
 kernel/jump_label.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 9019f15..d7ac148 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -399,7 +399,7 @@ jump_label_module_notify(struct notifier_block *self, unsigned long val,
 	return notifier_from_errno(ret);
 }
 
-struct notifier_block jump_label_module_nb = {
+static struct notifier_block jump_label_module_nb = {
 	.notifier_call = jump_label_module_notify,
 	.priority = 1, /* higher than tracepoints */
 };
-- 
2.1.2

Regards,
Michele

