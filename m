Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189Ab3I3UcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 16:32:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:45245 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756500Ab3I3U3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 16:29:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1010,1371106800"; 
   d="scan'208";a="367903924"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, viro@zeniv.linux.org.uk
Subject: [PATCH 05/11] seq_file: Handle ->next error in seq_read
Date: Mon, 30 Sep 2013 13:29:06 -0700
Message-Id: <1380572952-30729-6-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
References: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

When ->next fails the error would not be returned to user space.
Add the missing check.

Cc: viro@zeniv.linux.org.uk
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/seq_file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index 3135c25..e16b4a8 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -262,6 +262,8 @@ Fill:
 		pos = next;
 	}
 	m->op->stop(m, p);
+	if (err)
+		goto Done;
 	n = min(m->count, size);
 	err = copy_to_user(buf, m->buf, n);
 	if (err)
-- 
1.8.3.1

