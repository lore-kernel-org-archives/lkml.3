Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbaLNUfu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:35:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53442 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaLNUdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:33:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ilia Mirkin <imirkin@alum.mit.edu>, Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 3.17 09/47] drm/nouveau/gf116: remove copy1 engine
Date: Sun, 14 Dec 2014 12:20:44 -0800
Message-Id: <20141214201818.883450486@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141214201818.552715149@linuxfoundation.org>
References: <20141214201818.552715149@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilia Mirkin <imirkin@alum.mit.edu>

commit 226d63a1addea8cbe8fc671978e62dc84927b046 upstream.

Indications are that no GF116's actually have a copy engine there, but
actually have the decompression engine. This engine can be made to do
copies, but that should be done separately.

Unclear why this didn't turn up on all GF116's, but perhaps the
non-mobile ones came with enough VRAM to not trigger ttm migrations in
test scenarios.

Fixes: https://bugs.freedesktop.org/show_bug.cgi?id=85465
Fixes: https://bugs.freedesktop.org/show_bug.cgi?id=59168
Signed-off-by: Ilia Mirkin <imirkin@alum.mit.edu>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/core/engine/device/nvc0.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/core/engine/device/nvc0.c
+++ b/drivers/gpu/drm/nouveau/core/engine/device/nvc0.c
@@ -212,7 +212,6 @@ nvc0_identify(struct nouveau_device *dev
 		device->oclass[NVDEV_ENGINE_BSP    ] = &nvc0_bsp_oclass;
 		device->oclass[NVDEV_ENGINE_PPP    ] = &nvc0_ppp_oclass;
 		device->oclass[NVDEV_ENGINE_COPY0  ] = &nvc0_copy0_oclass;
-		device->oclass[NVDEV_ENGINE_COPY1  ] = &nvc0_copy1_oclass;
 		device->oclass[NVDEV_ENGINE_DISP   ] =  nva3_disp_oclass;
 		device->oclass[NVDEV_ENGINE_PERFMON] = &nvc0_perfmon_oclass;
 		break;


