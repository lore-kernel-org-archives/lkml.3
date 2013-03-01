Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab3CAAn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:43:56 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:48393 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab3CAAnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:43:51 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Erik Gilling <konkers@android.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Rob Clark <robclark@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>, dri-devel@lists.freedesktop.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 07/30] staging: sw_sync: Add fill_driver_data support
Date: Thu, 28 Feb 2013 16:43:03 -0800
Message-Id: <1362098606-26469-8-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
References: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erik Gilling <konkers@android.com>

Add fill_driver_data support to export fence data to ioctl

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
 drivers/staging/android/sw_sync.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/staging/android/sw_sync.c b/drivers/staging/android/sw_sync.c
index 64c5ebb..081e4d1 100644
--- a/drivers/staging/android/sw_sync.c
+++ b/drivers/staging/android/sw_sync.c
@@ -87,6 +87,19 @@ static void sw_sync_print_pt(struct seq_file *s, struct sync_pt *sync_pt)
 	seq_printf(s, "%d / %d", pt->value, obj->value);
 }
 
+static int sw_sync_fill_driver_data(struct sync_pt *sync_pt,
+				    void *data, int size)
+{
+	struct sw_sync_pt *pt = (struct sw_sync_pt *)sync_pt;
+
+	if (size < sizeof(pt->value))
+		return -ENOMEM;
+
+	memcpy(data, &pt->value, sizeof(pt->value));
+
+	return sizeof(pt->value);
+}
+
 struct sync_timeline_ops sw_sync_timeline_ops = {
 	.driver_name = "sw_sync",
 	.dup = sw_sync_pt_dup,
@@ -94,6 +107,7 @@ struct sync_timeline_ops sw_sync_timeline_ops = {
 	.compare = sw_sync_pt_compare,
 	.print_obj = sw_sync_print_obj,
 	.print_pt = sw_sync_print_pt,
+	.fill_driver_data = sw_sync_fill_driver_data,
 };
 
 
-- 
1.7.10.4

