Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab3ETKyH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:54:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56423 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756632Ab3ETKyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:54:04 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kees Cook <keescook@chromium.org>, Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 103/115] drm/radeon: check incoming cliprects pointer
Date: Mon, 20 May 2013 11:51:43 +0100
Message-Id: <1369047116-9378-104-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit fefaedcfb82d2e57c2320acf60604ab03b750cc0 upstream.

The "boxes" parameter points into userspace memory. It should be verified
like any other operation against user memory.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/r300_cmdbuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/r300_cmdbuf.c b/drivers/gpu/drm/radeon/r300_cmdbuf.c
index 1fe98b4..9aa02be 100644
--- a/drivers/gpu/drm/radeon/r300_cmdbuf.c
+++ b/drivers/gpu/drm/radeon/r300_cmdbuf.c
@@ -74,7 +74,7 @@ static int r300_emit_cliprects(drm_radeon_private_t *dev_priv,
 		OUT_RING(CP_PACKET0(R300_RE_CLIPRECT_TL_0, nr * 2 - 1));
 
 		for (i = 0; i < nr; ++i) {
-			if (DRM_COPY_FROM_USER_UNCHECKED
+			if (DRM_COPY_FROM_USER
 			    (&box, &cmdbuf->boxes[n + i], sizeof(box))) {
 				DRM_ERROR("copy cliprect faulted\n");
 				return -EFAULT;
-- 
1.8.1.2

