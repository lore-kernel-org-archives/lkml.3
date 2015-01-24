Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710AbbAXOEJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 09:04:09 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:56143 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbbAXODy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 09:03:54 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/32] bitmap: use %*pb[l] to print bitmaps including cpumasks and nodemasks
Date: Sat, 24 Jan 2015 09:03:10 -0500
Message-Id: <1422108218-25398-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422108218-25398-1-git-send-email-tj@kernel.org>
References: <1422108218-25398-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Please wait till the forementioned patches are merged to mainline
before applying to subsystem trees.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 lib/bitmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/bitmap.c b/lib/bitmap.c
index 1e482a6..1c8607d0 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -548,8 +548,8 @@ int bitmap_print_to_pagebuf(bool list, char *buf, const unsigned long *maskp,
 	int n = 0;
 
 	if (len > 1) {
-		n = list ? bitmap_scnlistprintf(buf, len, maskp, nmaskbits) :
-			   bitmap_scnprintf(buf, len, maskp, nmaskbits);
+		n = list ? scnprintf(buf, len, "%*pbl", nmaskbits, maskp) :
+			   scnprintf(buf, len, "%*pb", nmaskbits, maskp);
 		buf[n++] = '\n';
 		buf[n] = '\0';
 	}
-- 
2.1.0

