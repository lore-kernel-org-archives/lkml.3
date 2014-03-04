Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744AbaCDUk7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:40:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41452 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756998AbaCDUEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:04:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Janecek <janjanjanx@gmail.com>, Ilia Mirkin <imirkin@alum.mit.edu>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 3.10 01/97] drm/nouveau: set irq_enabled manually
Date: Tue,  4 Mar 2014 12:03:14 -0800
Message-Id: <20140304200346.040895437@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200345.895517495@linuxfoundation.org>
References: <20140304200345.895517495@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nouveau_drm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -339,6 +339,8 @@ nouveau_drm_load(struct drm_device *dev,
 	if (ret)
 		goto fail_device;
 
+	dev->irq_enabled = true;
+
 	/* workaround an odd issue on nvc1 by disabling the device's
 	 * nosnoop capability.  hopefully won't cause issues until a
 	 * better fix is found - assuming there is one...
@@ -426,6 +428,7 @@ nouveau_drm_remove(struct pci_dev *pdev)
 	struct nouveau_drm *drm = nouveau_drm(dev);
 	struct nouveau_object *device;
 
+	dev->irq_enabled = false;
 	device = drm->client.base.device;
 	drm_put_dev(dev);
 


