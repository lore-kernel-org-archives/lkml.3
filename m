Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbaAFPTk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:19:40 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:50761 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbaAFPTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:19:39 -0500
Date: Mon, 6 Jan 2014 20:49:34 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Dave Airlie <airlied@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Alon Levy <alevy@redhat.com>, dri-devel@lists.freedesktop.org,
        josh@joshtriplett.org
Subject: [PATCH 20/85] drivers: gpu: Mark function as static in qxl_kms.c
Message-ID: <14c6291e2f7d77bed4fc26dd6a46e197ce2f30f9.1389018324.git.rashika.kheria@gmail.com>
References: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function qxl_device_init() as static in drm/qxl/qxl_kms.c because
it is not used outside this file.

This eliminates the following warning in drm/qxl/qxl_kms.c:
drivers/gpu/drm/qxl/qxl_kms.c:118:5: warning: no previous prototype for ‘qxl_device_init’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/qxl/qxl_kms.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/qxl/qxl_kms.c b/drivers/gpu/drm/qxl/qxl_kms.c
index e5ca498..fd88eb4 100644
--- a/drivers/gpu/drm/qxl/qxl_kms.c
+++ b/drivers/gpu/drm/qxl/qxl_kms.c
@@ -115,7 +115,7 @@ static void qxl_gc_work(struct work_struct *work)
 	qxl_garbage_collect(qdev);
 }
 
-int qxl_device_init(struct qxl_device *qdev,
+static int qxl_device_init(struct qxl_device *qdev,
 		    struct drm_device *ddev,
 		    struct pci_dev *pdev,
 		    unsigned long flags)
-- 
1.7.9.5

