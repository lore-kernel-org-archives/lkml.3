Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab3CUVCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:02:46 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:34256
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753297Ab3CUVCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:02:43 -0400
x-originating-ip: 72.167.245.219
From: Haiyang Zhang <haiyangz@microsoft.com>
To: FlorianSchandinat@gmx.de, akpm@linux-foundation.org,
        linux-fbdev@vger.kernel.org
Cc: haiyangz@microsoft.com, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: [PATCH] video: fix a type warning in hyperv_fb.c
Date: Thu, 21 Mar 2013 14:32:57 -0700
Message-Id: <1363901577-16064-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>

---
 drivers/video/hyperv_fb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/hyperv_fb.c b/drivers/video/hyperv_fb.c
index ceb33b0..d4d2c5f 100644
--- a/drivers/video/hyperv_fb.c
+++ b/drivers/video/hyperv_fb.c
@@ -624,7 +624,7 @@ static int hvfb_getmem(struct fb_info *info)
 {
 	struct pci_dev *pdev;
 	ulong fb_phys;
-	void *fb_virt;
+	void __iomem *fb_virt;
 
 	pdev = pci_get_device(PCI_VENDOR_ID_MICROSOFT,
 			      PCI_DEVICE_ID_HYPERV_VIDEO, NULL);
-- 
1.7.4.1

