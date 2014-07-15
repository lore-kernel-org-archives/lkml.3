Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497AbaGORTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:19:23 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33236 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196AbaGORTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:19:18 -0400
Date: Tue, 15 Jul 2014 22:49:11 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Matthew Garrett <matthew.garrett@nebula.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] WMI: Remove unnecessary null test
Message-ID: <20140715171911.GA3038@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the null test on block. block is initialized at the
beginning of the function to &wblock->gblock. Since wblock is
dereferenced prior to the null test, wblock must be a valid pointer,
and &wblock->gblock cannot be null.

The following Coccinelle script is used for detecting the change:

@r@
expression e,f;
identifier g,y;
statement S1,S2;
@@

*e = &f->g
<+...
 f->y
 ...+>
*if (e != NULL || ...)
 S1 else S2

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
---
To send to: Matthew Garrett <matthew.garrett@nebula.com>,platform-driver-x86@vger.kernel.org,linux-kernel@vger.kernel.org
 drivers/platform/x86/wmi.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index 43d1329..737e56d 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -256,10 +256,6 @@ static acpi_status wmi_method_enable(struct wmi_block *wblock, int enable)
 	block = &wblock->gblock;
 	handle = wblock->handle;
 
-	if (!block)
-		return AE_NOT_EXIST;
-
-
 	snprintf(method, 5, "WE%02X", block->notify_id);
 	status = acpi_execute_simple_method(handle, method, enable);
 
-- 
1.9.1

