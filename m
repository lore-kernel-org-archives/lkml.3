Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409AbaCEPSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:18:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40924 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756968AbaCEOZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:25:30 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ilia Mirkin <imirkin@alum.mit.edu>, Ben Skeggs <bskeggs@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 044/131] drm/nouveau: set irq_enabled manually
Date: Wed,  5 Mar 2014 14:22:48 +0000
Message-Id: <1394029455-23128-45-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilia Mirkin <imirkin@alum.mit.edu>

commit 7d3428cd4b2ad51af86fdbdf8284ca38fa95e601 upstream.

Since commit 0fa9061ae8c ("drm/nouveau/mc: handle irq-related setup
ourselves"), drm_device->irq_enabled remained unset. This is needed in
order to properly wait for a vblank event in the generic drm code.

See https://bugs.freedesktop.org/show_bug.cgi?id=74195

Reported-by: Jan Janecek <janjanjanx@gmail.com>
Signed-off-by: Ilia Mirkin <imirkin@alum.mit.edu>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/nouveau/nouveau_drm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
index 6197266..576009c 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -348,6 +348,8 @@ nouveau_drm_load(struct drm_device *dev, unsigned long flags)
 	if (ret)
 		goto fail_device;
 
+	dev->irq_enabled = true;
+
 	/* workaround an odd issue on nvc1 by disabling the device's
 	 * nosnoop capability.  hopefully won't cause issues until a
 	 * better fix is found - assuming there is one...
@@ -435,6 +437,7 @@ nouveau_drm_remove(struct pci_dev *pdev)
 	struct nouveau_drm *drm = nouveau_drm(dev);
 	struct nouveau_object *device;
 
+	dev->irq_enabled = false;
 	device = drm->client.base.device;
 	drm_put_dev(dev);
 
-- 
1.9.0

