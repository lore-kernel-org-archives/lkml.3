Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab3L0Oi7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 09:38:59 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:60470 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab3L0Oi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 09:38:57 -0500
From: Ethan Zhao <ethan.kernel@gmail.com>
To: ying.huang@intel.com, tony.luck@intel.com
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ethan Zhao <ethan.kernel@gmail.com>
Subject: [PATCH] ghes: don't return 0 even when failed to read estatus in ghes_proc()
Date: Fri, 27 Dec 2013 22:38:40 +0800
Message-Id: <1388155120-419-1-git-send-email-ethan.kernel@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ghes_proc() always return 0 even failed to read estatus, so when it is
called in interrupt handler ghes_irq_func(), we don't know the interrupt
was handled well or not, because the ghes_irq_func() will return only
IRQ_HANDLED.

Signed-off-by: Ethan Zhao <ethan.kernel@gmail.com>
---
 drivers/acpi/apei/ghes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 8ec37bb..9368b73 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -665,7 +665,7 @@ static void ghes_estatus_cache_add(
 
 static int ghes_proc(struct ghes *ghes)
 {
-	int rc;
+	int rc = 0;
 
 	rc = ghes_read_estatus(ghes, 0);
 	if (rc)
@@ -677,7 +677,7 @@ static int ghes_proc(struct ghes *ghes)
 	ghes_do_proc(ghes, ghes->estatus);
 out:
 	ghes_clear_estatus(ghes);
-	return 0;
+	return rc;
 }
 
 static void ghes_add_timer(struct ghes *ghes)
-- 
1.8.3.4 (Apple Git-47)

