Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbaIBNGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 09:06:06 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:43880 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaIBNGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 09:06:04 -0400
From: Zheng Di <zhengdi05@gmail.com>
To: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org, andreas.dilger@intel.com, tao.peng@emc.com
Subject: [PATCH] staging: lustre: declare some functions as static
Date: Tue,  2 Sep 2014 01:51:28 +0800
Message-Id: <1409593888-45756-1-git-send-email-zhengdi05@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declare these functions as static:
llog_alloc_handle() is used in llog_open() only.
llog_free_handle() is used in llog_close() only.

Signed-off-by: Zheng Di <zhengdi05@gmail.com>
---
 drivers/staging/lustre/lustre/obdclass/llog.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/llog.c b/drivers/staging/lustre/lustre/obdclass/llog.c
index cce8689..ebdc42f 100644
--- a/drivers/staging/lustre/lustre/obdclass/llog.c
+++ b/drivers/staging/lustre/lustre/obdclass/llog.c
@@ -56,7 +56,7 @@
  * Allocate a new log or catalog handle
  * Used inside llog_open().
  */
-struct llog_handle *llog_alloc_handle(void)
+static struct llog_handle *llog_alloc_handle(void)
 {
 	struct llog_handle *loghandle;
 
@@ -75,7 +75,7 @@ struct llog_handle *llog_alloc_handle(void)
 /*
  * Free llog handle and header data if exists. Used in llog_close() only
  */
-void llog_free_handle(struct llog_handle *loghandle)
+static void llog_free_handle(struct llog_handle *loghandle)
 {
 	LASSERT(loghandle != NULL);
 
-- 
1.7.9.5

