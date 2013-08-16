Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab3HPM6J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 08:58:09 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:34415 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab3HPM6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 08:58:03 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Ben Skeggs <bskeggs@redhat.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Martin Peres <martin.peres@labri.fr>
Subject: [PATCH] nouveau: fix reclocking on nv40
Date: Fri, 16 Aug 2013 14:57:07 +0200
Message-Id: <1376657827-8105-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <520DFD9F.1070006@labri.fr>
References: <520DFD9F.1070006@labri.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 77145f1cbdf8d28b46ff8070ca749bad821e0774 was introduced
error which cause that reclocking on nv40 not working anymore.
There is missing assigment of return value from pll_calc to ret.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Martin Peres <martin.peres@labri.fr>
---
 drivers/gpu/drm/nouveau/nv40_pm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nv40_pm.c b/drivers/gpu/drm/nouveau/nv40_pm.c
index 3af5bcd..625f80d 100644
--- a/drivers/gpu/drm/nouveau/nv40_pm.c
+++ b/drivers/gpu/drm/nouveau/nv40_pm.c
@@ -131,7 +131,7 @@ nv40_calc_pll(struct drm_device *dev, u32 reg, struct nvbios_pll *pll,
 	if (clk < pll->vco1.max_freq)
 		pll->vco2.max_freq = 0;
 
-	pclk->pll_calc(pclk, pll, clk, &coef);
+	ret = pclk->pll_calc(pclk, pll, clk, &coef);
 	if (ret == 0)
 		return -ERANGE;
 
-- 
1.7.10.4

