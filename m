Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746AbaL3AO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 19:14:29 -0500
Received: from mail-yh0-f50.google.com ([209.85.213.50]:55540 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaL3AO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 19:14:27 -0500
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: broonie@kernel.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        alsa-devel@alsa-project.org, lgirdwood@gmail.com, a_bouin@yahoo.fr,
        timur@tabi.org, Xiubo.Lee@gmail.com, festevam@gmail.com
Subject: [PATCH] ASoC: fsl_esai: Fix incorrect xDC field width of xCCR registers
Date: Mon, 29 Dec 2014 16:13:51 -0800
Message-Id: <1419898431-11336-1-git-send-email-nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The xDC field should have 5 bit width according to Reference Manual.
Thus this patch fixes it.

Signed-off-by: Aurelien BOUIN <a_bouin@yahoo.fr>
Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
---

The patch was originally submitted by Aurelien BOUIN while in an
informal way. And he hasn't finished any re-submitting during the
past two weeks. Thus I create a new patch with his signed-off
included so as to fix the probelm as soon as possible, not sure
whether it's decent or not though.

--Nicolin

 sound/soc/fsl/fsl_esai.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/fsl/fsl_esai.h b/sound/soc/fsl/fsl_esai.h
index 91a550f..5e793bb 100644
--- a/sound/soc/fsl/fsl_esai.h
+++ b/sound/soc/fsl/fsl_esai.h
@@ -302,7 +302,7 @@
 #define ESAI_xCCR_xFP_MASK	(((1 << ESAI_xCCR_xFP_WIDTH) - 1) << ESAI_xCCR_xFP_SHIFT)
 #define ESAI_xCCR_xFP(v)	((((v) - 1) << ESAI_xCCR_xFP_SHIFT) & ESAI_xCCR_xFP_MASK)
 #define ESAI_xCCR_xDC_SHIFT     9
-#define ESAI_xCCR_xDC_WIDTH	4
+#define ESAI_xCCR_xDC_WIDTH	5
 #define ESAI_xCCR_xDC_MASK	(((1 << ESAI_xCCR_xDC_WIDTH) - 1) << ESAI_xCCR_xDC_SHIFT)
 #define ESAI_xCCR_xDC(v)	((((v) - 1) << ESAI_xCCR_xDC_SHIFT) & ESAI_xCCR_xDC_MASK)
 #define ESAI_xCCR_xPSR_SHIFT	8
-- 
1.9.1

