Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab3AaMeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:34:18 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:56244 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab3AaMeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:34:16 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/1] ASoC: Ux500: Fix build error pertaining to missing include file
Date: Thu, 31 Jan 2013 12:34:00 +0000
Message-Id: <1359635640-1932-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some compilers complain when building sound for MOP500:

sound/soc/ux500/mop500.c:27:27:
        fatal error: mop500_ab8500.h: No such file or directory

That file is actually in the local directory rather than include.

Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 sound/soc/ux500/mop500.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/ux500/mop500.c b/sound/soc/ux500/mop500.c
index ae69907..204b899 100644
--- a/sound/soc/ux500/mop500.c
+++ b/sound/soc/ux500/mop500.c
@@ -24,7 +24,7 @@
 #include "ux500_pcm.h"
 #include "ux500_msp_dai.h"
 
-#include <mop500_ab8500.h>
+#include "mop500_ab8500.h"
 
 /* Define the whole MOP500 soundcard, linking platform to the codec-drivers  */
 struct snd_soc_dai_link mop500_dai_links[] = {
-- 
1.7.9.5

