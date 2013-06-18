Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933482Ab3FRXxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 19:53:35 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:47846 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932499Ab3FRXxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 19:53:00 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
        Andrew Shewmaker <agshew@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Namjae Jeon <linkinjeon@gmail.com>, Jan Kara <jack@suse.cz>,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v4 3/6] mm/writeback: commit reason of WB_REASON_FORKER_THREAD mismatch name
Date: Wed, 19 Jun 2013 07:52:40 +0800
Message-Id: <1371599563-6424-3-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1371599563-6424-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1371599563-6424-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061823-0260-0000-0000-0000032E3792
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog:
 v3 - > v4:
    * add Tejun's Reviewed-by
	* explicitly point to the TPs rather than saying "somewhat" visible 

After commit 839a8e86("writeback: replace custom worker pool implementation
with unbound workqueue"), there is no bdi forker thread any more. However,
WB_REASON_FORKER_THREAD is still used due to it is TPs userland visible
and we won't be exposing exactly the same information with just a different
name.

Reviewed-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 include/linux/writeback.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 8b5cec4..ac73a9d 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -47,6 +47,11 @@ enum wb_reason {
 	WB_REASON_LAPTOP_TIMER,
 	WB_REASON_FREE_MORE_MEM,
 	WB_REASON_FS_FREE_SPACE,
+/*
+ * There is no bdi forker thread any more and works are done by emergency
+ * worker, however, this is TPs userland visible and we'll be exposing
+ * exactly the same information, so it has a mismatch name.
+ */
 	WB_REASON_FORKER_THREAD,
 
 	WB_REASON_MAX,
-- 
1.7.5.4

