Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbaIEQCP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 12:02:15 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:64035 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbaIEQCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 12:02:14 -0400
From: Dmitry Voytik <voytikd@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Dmitry Voytik <voytikd@gmail.com>
Subject: [PATCH] staging: binder: cmd_name must be initialised
Date: Fri,  5 Sep 2014 20:02:24 +0400
Message-Id: <1409932944-19528-1-git-send-email-voytikd@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable cmd_name must be initialised as variable name is.

Signed-off-by: Dmitry Voytik <voytikd@gmail.com>
---
 drivers/staging/android/binder.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 4f34dc0..93b067f 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -2233,7 +2233,7 @@ retry:
 		case BINDER_WORK_NODE: {
 			struct binder_node *node = container_of(w, struct binder_node, work);
 			uint32_t cmd = BR_NOOP;
-			const char *cmd_name;
+			const char *cmd_name = "BR_NOOP";
 			int strong = node->internal_strong_refs || node->local_strong_refs;
 			int weak = !hlist_empty(&node->refs) || node->local_weak_refs || strong;
 
-- 
1.9.1

