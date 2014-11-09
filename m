Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbaKIMqN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 07:46:13 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:39586 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbaKIMqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 07:46:12 -0500
From: Anil Kumar <anilk4.v@gmail.com>
To: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        lgirdwood@gmail.com, broonie@kernel.org
Cc: perex@perex.cz, tiwai@suse.de, peter.ujfalusi@ti.com,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org, anilk4.v@gmail.com
Subject: [PATCH] ASoC: davinvi-mcasp: Balance pm_runtime_enable() on probe failure
Date: Sun,  9 Nov 2014 18:15:14 +0530
Message-Id: <1415537114-9642-1-git-send-email-anilk4.v@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If probe fails then we need to call pm_runtime_disable() to balance
out the previous pm_runtime_enable() call.

Signed-off-by: Anil Kumar <anilk4.v@gmail.com>
---
:100644 100644 0eed9b1... 99c747d... M	sound/soc/davinci/davinci-mcasp.c
 sound/soc/davinci/davinci-mcasp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/davinci/davinci-mcasp.c b/sound/soc/davinci/davinci-mcasp.c
index 0eed9b1..99c747d 100644
--- a/sound/soc/davinci/davinci-mcasp.c
+++ b/sound/soc/davinci/davinci-mcasp.c
@@ -1235,6 +1235,7 @@ static int davinci_mcasp_probe(struct platform_device *pdev)
 	ret = pm_runtime_get_sync(&pdev->dev);
 	if (IS_ERR_VALUE(ret)) {
 		dev_err(&pdev->dev, "pm_runtime_get_sync() failed\n");
+		pm_runtime_disable(&pdev->dev);
 		return ret;
 	}
 
-- 
1.9.2

