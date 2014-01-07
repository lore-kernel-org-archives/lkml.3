Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728AbaAGA4C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:56:02 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:48007 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757607AbaAGAz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 19:55:58 -0500
Subject: [PATCH v7 06/15] drm/i915: Rename gtt_bus_addr to gtt_phys_addr
To: linux-pci@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: David Airlie <airlied@linux.ie>, Yinghai Lu <yinghai@kernel.org>,
        Guo Chao <yan@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Date: Mon, 06 Jan 2014 17:55:55 -0700
Message-ID: <20140107005555.10786.46881.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140107005003.10786.85164.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140107005003.10786.85164.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're dealing with CPU physical addresses here, which may be different from
bus addresses, so rename gtt_bus_addr to gtt_phys_addr to avoid confusion.

No functional change.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/gpu/drm/i915/i915_gem_gtt.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_gtt.c b/drivers/gpu/drm/i915/i915_gem_gtt.c
index 3620a1b0a73c..15604b3dda3e 100644
--- a/drivers/gpu/drm/i915/i915_gem_gtt.c
+++ b/drivers/gpu/drm/i915/i915_gem_gtt.c
@@ -1260,14 +1260,14 @@ static int ggtt_probe_common(struct drm_device *dev,
 			     size_t gtt_size)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
-	phys_addr_t gtt_bus_addr;
+	phys_addr_t gtt_phys_addr;
 	int ret;
 
 	/* For Modern GENs the PTEs and register space are split in the BAR */
-	gtt_bus_addr = pci_resource_start(dev->pdev, 0) +
+	gtt_phys_addr = pci_resource_start(dev->pdev, 0) +
 		(pci_resource_len(dev->pdev, 0) / 2);
 
-	dev_priv->gtt.gsm = ioremap_wc(gtt_bus_addr, gtt_size);
+	dev_priv->gtt.gsm = ioremap_wc(gtt_phys_addr, gtt_size);
 	if (!dev_priv->gtt.gsm) {
 		DRM_ERROR("Failed to map the gtt page table\n");
 		return -ENOMEM;

