Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbaFWMkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 08:40:19 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:37213 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbaFWMkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 08:40:17 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: andreas.dilger@intel.com, oleg.drokin@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, hpdd-discuss@ml01.01.org,
        Anil Belur <askb23@gmail.com>
Subject: [PATCH 1/1] staging: lustre: lustre: libcfs: fail.c - fix sparse warnings EXPORT_SYMBOL
Date: Mon, 23 Jun 2014 22:40:00 +1000
Message-Id: <1403527200-3663-1-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anil Belur <askb23@gmail.com>

- this fixes "WARNING: EXPORT_SYMBOL(foo); should immediately follow its
  function/variable"

Signed-off-by: Anil Belur <askb23@gmail.com>
---
 drivers/staging/lustre/lustre/libcfs/fail.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/fail.c b/drivers/staging/lustre/lustre/libcfs/fail.c
index ba43ff7..f63eac9 100644
--- a/drivers/staging/lustre/lustre/libcfs/fail.c
+++ b/drivers/staging/lustre/lustre/libcfs/fail.c
@@ -36,13 +36,15 @@
 #include <linux/libcfs/libcfs.h>
 
 unsigned long cfs_fail_loc = 0;
-unsigned int cfs_fail_val = 0;
-wait_queue_head_t cfs_race_waitq;
-int cfs_race_state;
-
 EXPORT_SYMBOL(cfs_fail_loc);
+
+unsigned int cfs_fail_val = 0;
 EXPORT_SYMBOL(cfs_fail_val);
+
+wait_queue_head_t cfs_race_waitq;
 EXPORT_SYMBOL(cfs_race_waitq);
+
+int cfs_race_state;
 EXPORT_SYMBOL(cfs_race_state);
 
 int __cfs_fail_check_set(__u32 id, __u32 value, int set)
-- 
1.9.0

