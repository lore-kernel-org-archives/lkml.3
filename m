Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663Ab3EaWXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 18:23:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57892 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757503Ab3EaWXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 18:23:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: patches@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, David Airlie <airlied@linux.ie>,
        Ben Skeggs <bskeggs@redhat.com>, dri-devel@lists.freedesktop.org
Subject: [PATCH 03/15] drm/nouveau: use mdelay instead of large udelay constants
Date: Sat,  1 Jun 2013 00:22:40 +0200
Message-Id: <1370038972-2318779-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370038972-2318779-1-git-send-email-arnd@arndb.de>
References: <1370038972-2318779-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:yJphtz+4os12D9F2c1Ng/yaZ9l9ZLhG6YIkTXx3RO8u
 tR3dQpvRBTQ/08H5Ci7gZTmXAkRyYVZ+mYKdk+sJML6uLP+Ywh
 IKry6fw9riF/8B/ckZkq4XAIWH6OnRdjVcI3QIv7+v8bmTSX3J
 bwWti0bxkzFGdC9J2HH6ibxsdfyAl92dpociNfWHaLG+nmfbke
 GSisju0U10WRkWlsK+BcAVZ5wpxDXsE90uSThoWdHQLHkJGu9c
 9uY1zq9rWky0NipgOXA5hmqluX77x0fkeLHyXxbFv0PlBHGOP6
 To+X58/19aY9kB1G7c4BV1xFsw84g8J6FprlI/KcGDU/BTe+dc
 7yDr931rKt4u83CYksn5rIWVFMNLA/UBNfRtsZdcy
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM cannot handle udelay for more than 2 miliseconds, so we
should use mdelay instead for those.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: dri-devel@lists.freedesktop.org
---
 drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c b/drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c
index d0817d9..ed7415e 100644
--- a/drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c
+++ b/drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c
@@ -51,7 +51,8 @@ nv50_dac_sense(struct nv50_disp_priv *priv, int or, u32 loadval)
 	const u32 doff = (or * 0x800);
 	int load = -EINVAL;
 	nv_wr32(priv, 0x61a00c + doff, 0x00100000 | loadval);
-	udelay(9500);
+	mdelay(9);
+	udelay(500);
 	nv_wr32(priv, 0x61a00c + doff, 0x80000000);
 	load = (nv_rd32(priv, 0x61a00c + doff) & 0x38000000) >> 27;
 	nv_wr32(priv, 0x61a00c + doff, 0x00000000);
-- 
1.8.1.2

