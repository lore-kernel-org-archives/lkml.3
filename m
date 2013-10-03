Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab3JCEPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:15:34 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:53953 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562Ab3JCEPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:15:30 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: alsa-devel@alsa-project.org
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Timur Tabi <timur@tabi.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Guenter Roeck <linux@roeck-us.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Grant Likely <grant.likely@linaro.org>
Subject: [PATCH] ASoC: fsl_ssi: Fix irq_of_parse_and_map() return value check
Date: Wed,  2 Oct 2013 21:15:22 -0700
Message-Id: <1380773722-1295-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_of_parse_and_map() returns 0 on error, not NO_IRQ.

Fix the following xtensa:allmodconfig build error.

sound/soc/fsl/fsl_ssi.c:705:26: error: 'NO_IRQ' undeclared (first use in this function)
make[4]: *** [sound/soc/fsl/fsl_ssi.o] Error 1

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Grant Likely <grant.likely@linaro.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
Previously submitted by Grant Likely as part of a different patch set.
See https://lkml.org/lkml/2012/1/11/342.
Also see https://lkml.org/lkml/2013/7/25/642.

 sound/soc/fsl/fsl_ssi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/fsl/fsl_ssi.c b/sound/soc/fsl/fsl_ssi.c
index c6b7439..6b81d0c 100644
--- a/sound/soc/fsl/fsl_ssi.c
+++ b/sound/soc/fsl/fsl_ssi.c
@@ -936,7 +936,7 @@ static int fsl_ssi_probe(struct platform_device *pdev)
 	ssi_private->ssi_phys = res.start;
 
 	ssi_private->irq = irq_of_parse_and_map(np, 0);
-	if (ssi_private->irq == NO_IRQ) {
+	if (ssi_private->irq == 0) {
 		dev_err(&pdev->dev, "no irq for node %s\n", np->full_name);
 		return -ENXIO;
 	}
-- 
1.7.9.7

