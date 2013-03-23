Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423040Ab3CWDmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 23:42:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:13897 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422841Ab3CWDlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 23:41:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,896,1355126400"; 
   d="scan'208";a="310768193"
From: Aaron Lu <aaron.lu@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Tejun Heo <tj@kernel.org>
Cc: linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@intel.com>,
        Shane Huang <shane.huang@amd.com>, Oliver Neukum <oneukum@suse.de>
Subject: [PATCH v12 1/5] block: add a flag to identify PM request
Date: Sat, 23 Mar 2013 11:42:24 +0800
Message-Id: <1364010148-8584-2-git-send-email-aaron.lu@intel.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1364010148-8584-1-git-send-email-aaron.lu@intel.com>
References: <1364010148-8584-1-git-send-email-aaron.lu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lin Ming <ming.m.lin@intel.com>

Add a flag REQ_PM to identify the request is PM related, such requests
will not change the device request queue's runtime status. It is
intended to be used in driver's runtime PM callback, so that driver can
perform some IO to the device there with the queue's runtime status
unaffected. e.g. in SCSI disk's runtime suspend callback, the disk will
be put into stopped power state, and this require sending a command to
the device. Such command processing should not change the disk's runtime
status.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 include/linux/blk_types.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index cdf1119..fcc1ce2 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -175,6 +175,7 @@ enum rq_flag_bits {
 	__REQ_IO_STAT,		/* account I/O stat */
 	__REQ_MIXED_MERGE,	/* merge of different types, fail separately */
 	__REQ_KERNEL, 		/* direct IO to kernel pages */
+	__REQ_PM,		/* runtime pm request */
 	__REQ_NR_BITS,		/* stops here */
 };
 
@@ -223,5 +224,6 @@ enum rq_flag_bits {
 #define REQ_MIXED_MERGE		(1 << __REQ_MIXED_MERGE)
 #define REQ_SECURE		(1 << __REQ_SECURE)
 #define REQ_KERNEL		(1 << __REQ_KERNEL)
+#define REQ_PM			(1 << __REQ_PM)
 
 #endif /* __LINUX_BLK_TYPES_H */
-- 
1.8.1.4

