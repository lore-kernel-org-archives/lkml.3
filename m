Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbaHOQsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:48:39 -0400
Received: from linuxhacker.ru ([217.76.32.60]:41225 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbaHOQsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:48:37 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: "John L. Hammond" <john.hammond@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 02/10] staging/lustre/mdc: cleanup intent if mdc_finish_enqueue() fails
Date: Fri, 15 Aug 2014 12:48:07 -0400
Message-Id: <1408121295-29115-3-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408121295-29115-1-git-send-email-green@linuxhacker.ru>
References: <1408121295-29115-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

In mdc_enqueue() clear the lock handle, lock mode, and request stored
in the lookup intent if mdc_finish_enqueue() fails.

Signed-off-by: John L. Hammond <john.hammond@intel.com>
Reviewed-on: http://review.whamcloud.com/10963
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-5289
Reviewed-by: Lai Siyao <lai.siyao@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/mdc/mdc_locks.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/staging/lustre/lustre/mdc/mdc_locks.c b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
index c64a38e..d02bf31 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_locks.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
@@ -944,7 +944,12 @@ resend:
 			memset(lockh, 0, sizeof(*lockh));
 		}
 		ptlrpc_req_finished(req);
+
+		it->d.lustre.it_lock_handle = 0;
+		it->d.lustre.it_lock_mode = 0;
+		it->d.lustre.it_data = NULL;
 	}
+
 	return rc;
 }
 
-- 
1.9.3

