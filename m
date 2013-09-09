Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab3IISrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:47:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57138 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab3IISro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:47:44 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Martin Peres <martin.peres@labri.fr>, Ben Skeggs <bskeggs@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 24/24] drm/nouveau: fix reclocking on nv40
Date: Mon,  9 Sep 2013 11:45:14 -0700
Message-Id: <1378752314-2416-25-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378752314-2416-1-git-send-email-kamal@canonical.com>
References: <1378752314-2416-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>

commit 0ff42c5af6031c776d6079d67cd2615121e62fb8 upstream.

In commit 77145f1cbdf8d28b46ff8070ca749bad821e0774 was introduced
error which cause that reclocking on nv40 not working anymore.
There is missing assigment of return value from pll_calc to ret.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Martin Peres <martin.peres@labri.fr>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/nouveau/nv40_pm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nv40_pm.c b/drivers/gpu/drm/nouveau/nv40_pm.c
index 3382064..5ee23fb 100644
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
1.8.1.2

