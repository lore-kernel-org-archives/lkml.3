Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbaDKHCk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 03:02:40 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.220]:62925 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158AbaDKHCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 03:02:39 -0400
X-Greylist: delayed 367 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Apr 2014 03:02:39 EDT
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWi/zfN1cLnBYfssBY5SQsSl9CXp8arK9v39HhxlZ/qveXkfVo4YvQ==
X-RZG-CLASS-ID: mo00
From: Olaf Hering <olaf@aepfle.de>
To: airlied@linux.ie
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Olaf Hering <olaf@aepfle.de>
Subject: [PATCH] drm/cirrus: bind also to qemu-xen-traditional
Date: Fri, 11 Apr 2014 08:56:23 +0200
Message-Id: <1397199383-30186-1-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

qemu as used by xend/xm toolstack uses a different subvendor id.
Bind the drm driver also to this emulated card.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
---
 drivers/gpu/drm/cirrus/cirrus_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/cirrus/cirrus_drv.c b/drivers/gpu/drm/cirrus/cirrus_drv.c
index 953fc8a..8555548 100644
--- a/drivers/gpu/drm/cirrus/cirrus_drv.c
+++ b/drivers/gpu/drm/cirrus/cirrus_drv.c
@@ -31,6 +31,8 @@ static struct drm_driver driver;
 static DEFINE_PCI_DEVICE_TABLE(pciidlist) = {
 	{ PCI_VENDOR_ID_CIRRUS, PCI_DEVICE_ID_CIRRUS_5446, 0x1af4, 0x1100, 0,
 	  0, 0 },
+	{ PCI_VENDOR_ID_CIRRUS, PCI_DEVICE_ID_CIRRUS_5446, PCI_VENDOR_ID_XEN,
+	  0x0001, 0, 0, 0 },
 	{0,}
 };
 
