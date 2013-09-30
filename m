Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab3I3U3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 16:29:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:8648 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756376Ab3I3U3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 16:29:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1010,1371106800"; 
   d="scan'208";a="412029768"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 06/11] sysctl: remove unnecessary variable initialization
Date: Mon, 30 Sep 2013 13:29:07 -0700
Message-Id: <1380572952-30729-7-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
References: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

In this if () branch first is not needed, so no need to set it.

Fixes a set-but-not-used warning.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/sysctl.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index b2f06f3..7f82d6d 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2549,7 +2549,6 @@ int proc_do_large_bitmap(struct ctl_table *table, int write,
 			}
 
 			bitmap_set(tmp_bitmap, val_a, val_b - val_a + 1);
-			first = 0;
 			proc_skip_char(&kbuf, &left, '\n');
 		}
 		free_page(page);
-- 
1.8.3.1

