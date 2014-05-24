Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327AbaEXVGN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 17:06:13 -0400
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:37293 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbaEXVGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 17:06:10 -0400
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org
Cc: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        David Airlie <airlied@linux.ie>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH linux-next] DRM: Armada: update dma_buf_export use
Date: Sat, 24 May 2014 23:05:44 +0200
Message-Id: <1400965544-20092-1-git-send-email-vincent.stehle@laposte.net>
X-Mailer: git-send-email 2.0.0.rc2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dma_buf_export function was updated in commit 4bcec44ffaf9 'dma-buf: use
reservation objects' to take a reservation object parameter; update Armada
export method accordingly.

This fixes the following compilation error:

  drivers/gpu/drm/armada/armada_gem.c: In function ‘armada_gem_prime_export’:
  drivers/gpu/drm/armada/armada_gem.c:544:16: error: macro "dma_buf_export" requires 5 arguments, but only 4 given

Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: David Airlie <airlied@linux.ie>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
---

Hi,

This can be seen with e.g. linux next-20140523 and arm allmodconfig.

Best regards,

V.

 drivers/gpu/drm/armada/armada_gem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/armada/armada_gem.c b/drivers/gpu/drm/armada/armada_gem.c
index 887816f..7adb0c3 100644
--- a/drivers/gpu/drm/armada/armada_gem.c
+++ b/drivers/gpu/drm/armada/armada_gem.c
@@ -541,7 +541,7 @@ armada_gem_prime_export(struct drm_device *dev, struct drm_gem_object *obj,
 	int flags)
 {
 	return dma_buf_export(obj, &armada_gem_prime_dmabuf_ops, obj->size,
-			      O_RDWR);
+			      O_RDWR, NULL);
 }
 
 struct drm_gem_object *
-- 
2.0.0.rc2

