Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbaJIVPU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:15:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59711 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757965AbaJIVL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:11:59 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Xiubo Li <Li.Xiubo@freescale.com>, Mark Brown <broonie@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 149/163] ASoC: core: fix possible ZERO_SIZE_PTR pointer dereferencing error.
Date: Thu,  9 Oct 2014 14:02:54 -0700
Message-Id: <1412888588-26755-150-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiubo Li <Li.Xiubo@freescale.com>

commit 6596aa047b624aeec2ea321962cfdecf9953a383 upstream.

Since we cannot make sure the 'params->num_regs' will always be none
zero here, and then if it equals to zero, the kmemdup() will return
ZERO_SIZE_PTR, which equals to ((void *)16).

So this patch fix this with just doing the zero check before calling
kmemdup().

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
[ kamal: backport to 3.13-stable: context ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/soc-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index a66783e..a3830d1 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -3236,7 +3236,7 @@ int snd_soc_bytes_put(struct snd_kcontrol *kcontrol,
 	unsigned int val;
 	void *data;
 
-	if (!codec->using_regmap)
+	if (!codec->using_regmap || !params->num_regs)
 		return -EINVAL;
 
 	len = params->num_regs * codec->val_bytes;
-- 
1.9.1

