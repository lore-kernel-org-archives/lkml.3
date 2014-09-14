Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbaINPWJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 11:22:09 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:58198 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbaINPWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 11:22:07 -0400
From: Spencer Baugh <sbaugh@andrew.cmu.edu>
To: gregkh@linuxfoundation.org
Cc: Spencer Baugh <sbaugh@andrew.cmu.edu>, Oleg Drokin <oleg.drokin@intel.com>,
        Hongchao Zhang <hongchao.zhang@intel.com>,
        Niu Yawei <yawei.niu@intel.com>,
        Alex Zhuravlev <alexey.zhuravlev@intel.com>,
        Masanari Iida <standby24x7@gmail.com>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/2] staging: lustre: fix function definition style
Date: Sun, 14 Sep 2014 11:21:10 -0400
Message-Id: <1410708073-23713-1-git-send-email-sbaugh@andrew.cmu.edu>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix errors reported by checkpatch of this kind:
ERROR: open brace '{' following function declarations go on the next line

Signed-off-by: Spencer Baugh <sbaugh@andrew.cmu.edu>
---
 drivers/staging/lustre/lustre/include/lustre_import.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre_import.h b/drivers/staging/lustre/lustre/include/lustre_import.h
index 8304a55..7bf82e0 100644
--- a/drivers/staging/lustre/lustre/include/lustre_import.h
+++ b/drivers/staging/lustre/lustre/include/lustre_import.h
@@ -346,21 +346,24 @@ static inline unsigned int at_timeout2est(unsigned int val)
 	return (max((val << 2) / 5, 5U) - 4);
 }
 
-static inline void at_reset(struct adaptive_timeout *at, int val) {
+static inline void at_reset(struct adaptive_timeout *at, int val)
+{
 	spin_lock(&at->at_lock);
 	at->at_current = val;
 	at->at_worst_ever = val;
 	at->at_worst_time = get_seconds();
 	spin_unlock(&at->at_lock);
 }
-static inline void at_init(struct adaptive_timeout *at, int val, int flags) {
+static inline void at_init(struct adaptive_timeout *at, int val, int flags)
+{
 	memset(at, 0, sizeof(*at));
 	spin_lock_init(&at->at_lock);
 	at->at_flags = flags;
 	at_reset(at, val);
 }
 extern unsigned int at_min;
-static inline int at_get(struct adaptive_timeout *at) {
+static inline int at_get(struct adaptive_timeout *at)
+{
 	return (at->at_current > at_min) ? at->at_current : at_min;
 }
 int at_measured(struct adaptive_timeout *at, unsigned int val);
-- 
2.1.0

