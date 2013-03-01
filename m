Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab3CAAvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:51:09 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:62598 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab3CAAns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:43:48 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Erik Gilling <konkers@android.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Rob Clark <robclark@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>, dri-devel@lists.freedesktop.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 05/30] staging: sw_sync: Add debug support
Date: Thu, 28 Feb 2013 16:43:01 -0800
Message-Id: <1362098606-26469-6-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
References: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erik Gilling <konkers@android.com>

Add debugfs support hooks.

Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Erik Gilling <konkers@android.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Rob Clark <robclark@gmail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: dri-devel@lists.freedesktop.org
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Erik Gilling <konkers@android.com>
[jstultz: Add commit message]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/sw_sync.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/staging/android/sw_sync.c b/drivers/staging/android/sw_sync.c
index c27004c..64c5ebb 100644
--- a/drivers/staging/android/sw_sync.c
+++ b/drivers/staging/android/sw_sync.c
@@ -70,11 +70,30 @@ static int sw_sync_pt_compare(struct sync_pt *a, struct sync_pt *b)
 	return sw_sync_cmp(pt_a->value, pt_b->value);
 }
 
+static void sw_sync_print_obj(struct seq_file *s,
+			      struct sync_timeline *sync_timeline)
+{
+	struct sw_sync_timeline *obj = (struct sw_sync_timeline *)sync_timeline;
+
+	seq_printf(s, "%d", obj->value);
+}
+
+static void sw_sync_print_pt(struct seq_file *s, struct sync_pt *sync_pt)
+{
+	struct sw_sync_pt *pt = (struct sw_sync_pt *)sync_pt;
+	struct sw_sync_timeline *obj =
+		(struct sw_sync_timeline *)sync_pt->parent;
+
+	seq_printf(s, "%d / %d", pt->value, obj->value);
+}
+
 struct sync_timeline_ops sw_sync_timeline_ops = {
 	.driver_name = "sw_sync",
 	.dup = sw_sync_pt_dup,
 	.has_signaled = sw_sync_pt_has_signaled,
 	.compare = sw_sync_pt_compare,
+	.print_obj = sw_sync_print_obj,
+	.print_pt = sw_sync_print_pt,
 };
 
 
-- 
1.7.10.4

