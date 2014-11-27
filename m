Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbaK0I4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:56:05 -0500
Received: from mail.kernel.org ([198.145.19.201]:42521 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932104AbaK0Itc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:49:32 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Xiubo Li <Li.Xiubo@freescale.com>,
        Mark Brown <broonie@kernel.org>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 70/91] ASoC: core: fix possible ZERO_SIZE_PTR pointer dereferencing error.
Date: Thu, 27 Nov 2014 16:42:53 +0800
Message-Id: <1417077794-9299-70-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiubo Li <Li.Xiubo@freescale.com>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 6596aa047b624aeec2ea321962cfdecf9953a383 upstream.

Since we cannot make sure the 'params->num_regs' will always be none
zero here, and then if it equals to zero, the kmemdup() will return
ZERO_SIZE_PTR, which equals to ((void *)16).

So this patch fix this with just doing the zero check before calling
kmemdup().

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 sound/soc/soc-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index c88d974..34c1fbb 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -2799,7 +2799,7 @@ int snd_soc_bytes_put(struct snd_kcontrol *kcontrol,
 	unsigned int val;
 	void *data;
 
-	if (!codec->using_regmap)
+	if (!codec->using_regmap || !params->num_regs)
 		return -EINVAL;
 
 	data = ucontrol->value.bytes.data;
-- 
1.9.1

