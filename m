Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932993Ab3DYReM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 13:34:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61407 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932475Ab3DYR3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 13:29:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 08/21] drm/nouveau: use mdelay instead of large udelay constants
Date: Thu, 25 Apr 2013 19:28:51 +0200
Message-Id: <1366910944-3033663-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:ckOpK7pL/psXn0RUH2LoulPPDJ2uthw9/uDDZ6lRq5l
 Y/z/7vPSMTIEXTUksbDOAxn47LEHMX3FXGO/hj7RbTv7a8cw3l
 H31lvkq6G4nXbrmj3UPRuok7WuEAU9MlYtW17oXSXJznBGTlVl
 Oxo1rc0b3HYFyomko4Ji1lvQSiK8jhcIilLt6af9w6xpaTcveh
 i0oMA1G/i5DYR+EtuAUkdBGi1iRAuS4UDjq6ncTZ7XD96BUqIy
 cGEPmQu7tJgTkqXC9qOpOxTofDvLk4KKpF0rXiiMekffxLKNYh
 5F7aRoVHuGb96XyqwLymbVx7XEtZzTBvW5LeoXGshwYhs/f0Sl
 aWh9K/cMa09A3aMqsd+Kihns9VDNiH7t+kzxqCDut
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

