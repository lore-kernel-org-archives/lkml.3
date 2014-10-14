Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115AbaJNI7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 04:59:00 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34531 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073AbaJNI66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 04:58:58 -0400
From: WANG Chao <wangchao19890207@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Romer <benjamin.romer@unisys.com>,
        David Kershner <david.kershner@unisys.com>, Ken Cox <jkc@redhat.com>,
        sparmaintainer@unisys.com (open list:UNISYS S-PAR DRIVERS),
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] staging, unisys: remove leftover function kmalloc_kernel()
Date: Tue, 14 Oct 2014 16:58:37 +0800
Message-Id: <1413277121-8285-1-git-send-email-wangchao19890207@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmalloc_kernel() previously declared in timskmodutils.h which recently got
removed. Now also remove kmalloc_kernel(), because it's not used anywhere.

Signed-off-by: WANG Chao <wangchao19890207@gmail.com>
---
 drivers/staging/unisys/visorutil/visorkmodutils.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/staging/unisys/visorutil/visorkmodutils.c b/drivers/staging/unisys/visorutil/visorkmodutils.c
index d6815f9..64b135d 100644
--- a/drivers/staging/unisys/visorutil/visorkmodutils.c
+++ b/drivers/staging/unisys/visorutil/visorkmodutils.c
@@ -36,16 +36,6 @@
 int unisys_spar_platform;
 EXPORT_SYMBOL_GPL(unisys_spar_platform);
 
-/** Callers to interfaces that set __GFP_NORETRY flag below
- *  must check for a NULL (error) result as we are telling the
- *  kernel interface that it is okay to fail.
- */
-
-void *kmalloc_kernel(size_t siz)
-{
-	return kmalloc(siz, GFP_KERNEL | __GFP_NORETRY);
-}
-
 static __init uint32_t
 visorutil_spar_detect(void)
 {
-- 
1.9.3

