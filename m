Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbaLOOhj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:37:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38889 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbaLOO27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:28:59 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bjorn Helgaas <bhelgaas@google.com>, Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 134/168] nouveau: move the hotplug ignore to correct place.
Date: Mon, 15 Dec 2014 14:26:28 +0000
Message-Id: <1418653622-21105-135-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 8b62c8c6df08ca567c78afa51aa7bbc554cede06 upstream.

Introduced in b440bde74f, however it was added to
the wrong function in nouveau.

https://bugzilla.kernel.org/show_bug.cgi?id=86011
Cc: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/nouveau/nouveau_drm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
index 0f7addae60d7..84a8b9fb20c8 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -595,7 +595,6 @@ int nouveau_pmops_suspend(struct device *dev)
 
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
-	pci_ignore_hotplug(pdev);
 	pci_set_power_state(pdev, PCI_D3hot);
 	return 0;
 }
@@ -887,6 +886,7 @@ static int nouveau_pmops_runtime_suspend(struct device *dev)
 	ret = nouveau_do_suspend(drm_dev, true);
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
+	pci_ignore_hotplug(pdev);
 	pci_set_power_state(pdev, PCI_D3cold);
 	drm_dev->switch_power_state = DRM_SWITCH_POWER_DYNAMIC_OFF;
 	return ret;
-- 
2.1.3

