Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab3LSJfE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 04:35:04 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:44285 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab3LSJe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 04:34:59 -0500
Date: Thu, 19 Dec 2013 15:04:47 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com,
        josh@joshtriplett.org
Subject: [PATCH 03/13] drivers: block: Mark function
 seq_printf_with_thousands_grouping() as static in drbd_proc.c
Message-ID: <1c21b4a9a0d6c82e201d6e1ee8336414caa56c60.1387445396.git.rashika.kheria@gmail.com>
References: <f460591345e87defe53122cf056991c7f2eefa10.1387445396.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f460591345e87defe53122cf056991c7f2eefa10.1387445396.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function seq_printf_with_thousands_grouping() as static in
drbd/drbd_proc.c because it is not used outside this file.

This eliminates the following warning in drbd/drbd_proc.c:
drivers/block/drbd/drbd_proc.c:49:6: warning: no previous prototype for ‘seq_printf_with_thousands_grouping’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/block/drbd/drbd_proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_proc.c b/drivers/block/drbd/drbd_proc.c
index bf31d41..84fbe33 100644
--- a/drivers/block/drbd/drbd_proc.c
+++ b/drivers/block/drbd/drbd_proc.c
@@ -46,7 +46,7 @@ const struct file_operations drbd_proc_fops = {
 	.release	= drbd_proc_release,
 };
 
-void seq_printf_with_thousands_grouping(struct seq_file *seq, long v)
+static void seq_printf_with_thousands_grouping(struct seq_file *seq, long v)
 {
 	/* v is in kB/sec. We don't expect TiByte/sec yet. */
 	if (unlikely(v >= 1000000)) {
-- 
1.7.9.5

