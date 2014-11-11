Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbaKKMBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:01:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57278 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414AbaKKLJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:38 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Olaf Hering <olaf@aepfle.de>, Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 040/170] drm/cirrus: bind also to qemu-xen-traditional
Date: Tue, 11 Nov 2014 11:06:39 +0000
Message-Id: <1415704129-12709-41-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olaf Hering <olaf@aepfle.de>

commit c0c3e735fa7bae29c6623511127fd021b2d6d849 upstream.

qemu as used by xend/xm toolstack uses a different subvendor id.
Bind the drm driver also to this emulated card.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/cirrus/cirrus_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/cirrus/cirrus_drv.c b/drivers/gpu/drm/cirrus/cirrus_drv.c
index 08ce520f61a5..faa1f421f1b8 100644
--- a/drivers/gpu/drm/cirrus/cirrus_drv.c
+++ b/drivers/gpu/drm/cirrus/cirrus_drv.c
@@ -32,6 +32,8 @@ static struct drm_driver driver;
 static DEFINE_PCI_DEVICE_TABLE(pciidlist) = {
 	{ PCI_VENDOR_ID_CIRRUS, PCI_DEVICE_ID_CIRRUS_5446, 0x1af4, 0x1100, 0,
 	  0, 0 },
+	{ PCI_VENDOR_ID_CIRRUS, PCI_DEVICE_ID_CIRRUS_5446, PCI_VENDOR_ID_XEN,
+	  0x0001, 0, 0, 0 },
 	{0,}
 };
 
-- 
2.1.0

