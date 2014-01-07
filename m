Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbaAGJ6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 04:58:43 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:34122 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042AbaAGJ6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 04:58:40 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andreas Heider <andreas@meetr.de>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 1/4] drm/i915: add support for vga_switcheroo reprobe
Date: Tue,  7 Jan 2014 15:28:40 +0530
Message-Id: <1389088723-30959-2-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.2.229.g4448466
In-Reply-To: <1389088723-30959-1-git-send-email-artagnon@gmail.com>
References: <1389088723-30959-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Andreas Heider <andreas@meetr.de>
Cc: Seth Forshee <seth.forshee@canonical.com>
Original-patch-by: Andreas Heider <andreas@meetr.de>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 drivers/gpu/drm/i915/i915_dma.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 5c64842..336a835b 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1265,6 +1265,12 @@ static void i915_switcheroo_set_state(struct pci_dev *pdev, enum vga_switcheroo_
 	}
 }
 
+static void i915_switcheroo_reprobe(struct pci_dev *pdev)
+{
+	struct drm_device *dev = pci_get_drvdata(pdev);
+	intel_fbdev_output_poll_changed(dev);
+}
+
 static bool i915_switcheroo_can_switch(struct pci_dev *pdev)
 {
 	struct drm_device *dev = pci_get_drvdata(pdev);
@@ -1278,7 +1284,7 @@ static bool i915_switcheroo_can_switch(struct pci_dev *pdev)
 
 static const struct vga_switcheroo_client_ops i915_switcheroo_ops = {
 	.set_gpu_state = i915_switcheroo_set_state,
-	.reprobe = NULL,
+	.reprobe = i915_switcheroo_reprobe,
 	.can_switch = i915_switcheroo_can_switch,
 };
 
-- 
1.8.5.2.229.g4448466

