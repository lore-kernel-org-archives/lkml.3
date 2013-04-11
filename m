Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937636Ab3DKAHD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 20:07:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55410 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937472Ab3DKAG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 20:06:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        alsa-devel@alsa-project.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Subject: [PATCH 22/30] ASoC: samsung/idma: export idma_reg_addr_init
Date: Thu, 11 Apr 2013 02:05:04 +0200
Message-Id: <1365638712-1028578-23-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:vuSM/WaVxJd1hgSSqXAQ8sue8YOa4bKEccfukAH+0Fp
 LjWmjOFtoZLkdWtdRXTsQP4sZkQQBr6hlKt7KbUPkGADcWqfaF
 KkOHUQESt4gQiCQCRcQWgbxeGQs5IUS1GGzJKkJaEjeYD4NE9R
 BltfMy2RKZGmg3aK3+dJLzaDqdrlh8WE/8e5u1KlHz0Grv5xs1
 mAEjFhagqNvoXsbOclO3HWXH1eMAZV2jmbXK/hn5Y+OWwXqchg
 03qew8giNZcjtRH3AK/pHOVokyp0xkTbeipqsZGOAp8HIf+SgV
 WCgJnMoXE5BBrByzFds+QKSRJMj5X2nE5PcAOKl8Wu7n5iJXSH
 tpbDqaIr0D09FdApt/Vw2QuR6ueq9uJm9+BRox1COk7EO/gxZ/
 PoDU9ogrAaYlQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idma_reg_addr_init function is used by the samsung i2s driver,
which can be a loadable module, so we have to export this function.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: alsa-devel@alsa-project.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>
---
 sound/soc/samsung/idma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/samsung/idma.c b/sound/soc/samsung/idma.c
index f36a541..6e5fed3 100644
--- a/sound/soc/samsung/idma.c
+++ b/sound/soc/samsung/idma.c
@@ -411,6 +411,7 @@ void idma_reg_addr_init(void __iomem *regs, dma_addr_t addr)
 	idma.regs = regs;
 	idma.lp_tx_addr = addr;
 }
+EXPORT_SYMBOL_GPL(idma_reg_addr_init);
 
 static struct snd_soc_platform_driver asoc_idma_platform = {
 	.ops = &idma_ops,
-- 
1.8.1.2

