Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab3LMGmo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 01:42:44 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:58608 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab3LMGmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 01:42:43 -0500
Date: Fri, 13 Dec 2013 12:12:34 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dimitri Sivanich <sivanich@sgi.com>, josh@joshtriplett.org
Subject: [PATCH 1/5] drivers: misc: Mark functions as static in grukservices.c
Message-ID: <40521f78bafae3cc4e796c540d3c497d79eeb63e.1386915618.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch marks the function gru_get_cb_exception_detail_str() and
gru_abort() as static in sgi-gru/grukservices.c because they are not
used outside this file.

Thus, it also eliminates the following warnings in
sgi-gru/grukservices.c:
drivers/misc/sgi-gru/grukservices.c:432:7: warning: no previous prototype for ‘gru_get_cb_exception_detail_str’ [-Wmissing-prototypes]
drivers/misc/sgi-gru/grukservices.c:508:6: warning: no previous prototype for ‘gru_abort’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/misc/sgi-gru/grukservices.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/sgi-gru/grukservices.c b/drivers/misc/sgi-gru/grukservices.c
index 913de07..29d1582 100644
--- a/drivers/misc/sgi-gru/grukservices.c
+++ b/drivers/misc/sgi-gru/grukservices.c
@@ -429,7 +429,7 @@ int gru_get_cb_exception_detail(void *cb,
 	return 0;
 }
 
-char *gru_get_cb_exception_detail_str(int ret, void *cb,
+static char *gru_get_cb_exception_detail_str(int ret, void *cb,
 				      char *buf, int size)
 {
 	struct gru_control_block_status *gen = (void *)cb;
@@ -505,7 +505,7 @@ int gru_wait_proc(void *cb)
 	return ret;
 }
 
-void gru_abort(int ret, void *cb, char *str)
+static void gru_abort(int ret, void *cb, char *str)
 {
 	char buf[GRU_EXC_STR_SIZE];
 
-- 
1.7.9.5

