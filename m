Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931Ab3CLSWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:22:33 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:64259 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559Ab3CLSWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:22:30 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] drivers: acpi: Replaced kmalloc and memcpy with kmemdup
Date: Tue, 12 Mar 2013 10:22:21 +0200
Message-Id: <1363076541-30013-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced calls to kmalloc followed by memcpy with a single call to kmemdup.
Patch found using coccinelle.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 drivers/acpi/bus.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 01708a1..6c8380e 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -288,13 +288,12 @@ acpi_status acpi_run_osc(acpi_handle handle, struct acpi_osc_context *context)
 	}
 out_success:
 	context->ret.length = out_obj->buffer.length;
-	context->ret.pointer = kmalloc(context->ret.length, GFP_KERNEL);
+	context->ret.pointer = kmemdup(out_obj->buffer.pointer,
+				context->ret.length, GFP_KERNEL);
 	if (!context->ret.pointer) {
 		status =  AE_NO_MEMORY;
 		goto out_kfree;
 	}
-	memcpy(context->ret.pointer, out_obj->buffer.pointer,
-		context->ret.length);
 	status =  AE_OK;
 
 out_kfree:
-- 
1.7.9.5

