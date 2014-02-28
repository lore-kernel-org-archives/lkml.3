Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbaB1GiO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 01:38:14 -0500
Received: from mga11.intel.com ([192.55.52.93]:1336 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184AbaB1GiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 01:38:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,560,1389772800"; 
   d="scan'208";a="489716930"
From: shuox.liu@intel.com
To: linux-kernel@vger.kernel.org
Cc: tony.luck@intel.com, keescook@chromium.org, ccross@android.com,
        anton@enomsg.org, yanmin_zhang@linux.intel.com
Subject: [PATCH] pstore: reset ftrace_read_cnt at ramoops_pstore_open
Date: Fri, 28 Feb 2014 14:37:44 +0800
Message-Id: <1393569464-14904-1-git-send-email-shuox.liu@intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu ShuoX <shuox.liu@intel.com>

ftrace_read_cnt need to be reset in open to support mutli times
getting the records.

Signed-off-by: Liu ShuoX <shuox.liu@intel.com>
---
 fs/pstore/ram.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index fa8cef2..a5d0cab 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -101,6 +101,7 @@ static int ramoops_pstore_open(struct pstore_info *psi)
 
 	cxt->dump_read_cnt = 0;
 	cxt->console_read_cnt = 0;
+	cxt->ftrace_read_cnt = 0;
 	return 0;
 }
 
-- 
1.8.3.2

