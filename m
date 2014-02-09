Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770AbaBIMtX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 07:49:23 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:46866 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbaBIMtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 07:49:22 -0500
Date: Sun, 9 Feb 2014 18:19:17 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>, cluster-devel@redhat.com,
        josh@joshtriplett.org
Subject: [PATCH 02/21] fs: Include appropriate header file in dlm/ast.c
Message-ID: <00380d95bfae6200d6120f050540236dbd1fc99b.1391949868.git.rashika.kheria@gmail.com>
References: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include appropriate header file fs/dlm/ast.h in fs/dlm/ast.c because it
contains function prototypes of some functions defined in fs/dlm/ast.c.

This also eliminates the following warning in fs/dlm/ast:
fs/dlm/ast.c:52:5: warning: no previous prototype for ‘dlm_add_lkb_callback’ [-Wmissing-prototypes]
fs/dlm/ast.c:113:5: warning: no previous prototype for ‘dlm_rem_lkb_callback’ [-Wmissing-prototypes]
fs/dlm/ast.c:174:6: warning: no previous prototype for ‘dlm_add_cb’ [-Wmissing-prototypes]
fs/dlm/ast.c:212:6: warning: no previous prototype for ‘dlm_callback_work’ [-Wmissing-prototypes]
fs/dlm/ast.c:267:5: warning: no previous prototype for ‘dlm_callback_start’ [-Wmissing-prototypes]
fs/dlm/ast.c:278:6: warning: no previous prototype for ‘dlm_callback_stop’ [-Wmissing-prototypes]
fs/dlm/ast.c:284:6: warning: no previous prototype for ‘dlm_callback_suspend’ [-Wmissing-prototypes]
fs/dlm/ast.c:292:6: warning: no previous prototype for ‘dlm_callback_resume’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 fs/dlm/ast.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/dlm/ast.c b/fs/dlm/ast.c
index 0e90f0c..42794c0 100644
--- a/fs/dlm/ast.c
+++ b/fs/dlm/ast.c
@@ -14,6 +14,7 @@
 #include "dlm_internal.h"
 #include "lock.h"
 #include "user.h"
+#include "ast.h"
 
 static uint64_t dlm_cb_seq;
 static DEFINE_SPINLOCK(dlm_cb_seq_spin);
-- 
1.7.9.5

