Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341Ab3DWQcI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:32:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58535 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757234Ab3DWQby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:31:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>, alsa-devel@alsa-project.org
Subject: [PATCH 08/21] ASoC: ux500: forward declare msp_i2s_platform_data
Date: Tue, 23 Apr 2013 18:30:40 +0200
Message-Id: <1366734653-488286-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366734653-488286-1-git-send-email-arnd@arndb.de>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:sAINulNVjpX6DNsZj2YOrYA0Hpjke2eHoIVZeuz6wAM
 WigMg191bHo/qGRrYdiV2FRtqEQ/0vFUdqzZm8+1r7D+BBh7vW
 vMMBPTbZxD4NM/ieYkyvSusb4tqV3/jtpNXgBUsREz/x0LFyVo
 oxRZGyyeCSk/vn5pk5sgmBk6GFN9qvzHrc9GO24t2lRmd+pioC
 bQGRdKG7+2ET1bRICmMJ1NpmosH0eQvggDWwum4IbVQVpOPWW3
 qY3UjZZXNJ6jRmn6WhSCrAuQM1fDBzePXo7OUiQ3KLfSN9fqwd
 qP42y1//Fxs+Yuq6JcxzSISNcuSv+3EHCol1BUseFgDOlTnRFP
 8NvMusi0HA3YdeD/N+bFBn9yon0YyumdlT3R2trmV
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We get a lot of build warnings from the msp driver like:

In file included from sound/soc/ux500/ux500_msp_dai.h:21:0,
                 from sound/soc/ux500/mop500.c:25:
sound/soc/ux500/ux500_msp_i2s.h:546:11: warning: 'struct msp_i2s_platform_data' declared inside parameter list [enabled by default]
    struct msp_i2s_platform_data *platform_data);
           ^
sound/soc/ux500/ux500_msp_i2s.h:546:11: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]

The easiest solution is to add a declaration of the struct name.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Ola Lilja <ola.o.lilja@stericsson.com>
Cc: alsa-devel@alsa-project.org
---
 sound/soc/ux500/ux500_msp_i2s.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/ux500/ux500_msp_i2s.h b/sound/soc/ux500/ux500_msp_i2s.h
index 1311c0d..6f3e3dc 100644
--- a/sound/soc/ux500/ux500_msp_i2s.h
+++ b/sound/soc/ux500/ux500_msp_i2s.h
@@ -543,6 +543,7 @@ struct ux500_msp_dma_params {
 	struct stedma40_chan_cfg *dma_cfg;
 };
 
+struct msp_i2s_platform_data;
 int ux500_msp_i2s_init_msp(struct platform_device *pdev,
 			struct ux500_msp **msp_p,
 			struct msp_i2s_platform_data *platform_data);
-- 
1.8.1.2

