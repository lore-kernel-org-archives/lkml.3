Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbaF0L3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 07:29:17 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:13434 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbaF0L3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 07:29:16 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 27 Jun 2014 04:19:17 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: David Airlie <airlied@linux.ie>, Lucas Stach <dev@lynxeye.de>,
        David Herrmann <dh.herrmann@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>
CC: <dri-devel@lists.freedesktop.org>, <nouveau@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] drm/ttm: recognize ARM arch in ioprot handler
Date: Fri, 27 Jun 2014 20:29:09 +0900
Message-ID: <1403868549-2232-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.0
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lucas Stach <dev@lynxeye.de>

Nouveau can now be used on ARM, so add an ioprot handler for this
architecture.

Signed-off-by: Lucas Stach <dev@lynxeye.de>
Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/ttm/ttm_bo_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
index 1df856f78568..30e5d90cb7bc 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -500,7 +500,7 @@ pgprot_t ttm_io_prot(uint32_t caching_flags, pgprot_t tmp)
 			pgprot_val(tmp) |= _PAGE_GUARDED;
 	}
 #endif
-#if defined(__ia64__)
+#if defined(__ia64__) || defined(__arm__)
 	if (caching_flags & TTM_PL_FLAG_WC)
 		tmp = pgprot_writecombine(tmp);
 	else
-- 
2.0.0

