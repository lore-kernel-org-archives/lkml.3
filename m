Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926AbaLBFzP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 00:55:15 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:34336 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285AbaLBFzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 00:55:13 -0500
From: Jiada Wang <jiada_wang@mentor.com>
To: <timur@tabi.org>, <festevam@gmail.com>, <lars@metafoo.de>, <arnd@arndb.de>,
        <broonie@kernel.org>, <mpa@pengutronix.de>
CC: <alsa-devel@alsa-project.org>, <Li.Xiubo@freescale.com>,
        <linux-kernel@vger.kernel.org>, <lgirdwood@gmail.com>,
        <nicoleotsuka@gmail.com>, <tiwai@suse.de>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: [PATCH v2 1/2] ASoC: fsl_ssi: fix error path in probe
Date: Tue, 2 Dec 2014 14:55:06 +0900
Message-ID: <1417499707-3125-2-git-send-email-jiada_wang@mentor.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1417499707-3125-1-git-send-email-jiada_wang@mentor.com>
References: <1417499707-3125-1-git-send-email-jiada_wang@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SSI component isn't unregistered if fsl_ssi_debugfs_create() fails
in probe phase.

To fix it, this commit replaces label error_asoc_register with
error_irq.

Signed-off-by: Jiada Wang <jiada_wang@mentor.com>
---
 sound/soc/fsl/fsl_ssi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/fsl/fsl_ssi.c b/sound/soc/fsl/fsl_ssi.c
index e695517..e19ed39 100644
--- a/sound/soc/fsl/fsl_ssi.c
+++ b/sound/soc/fsl/fsl_ssi.c
@@ -1412,7 +1412,7 @@ static int fsl_ssi_probe(struct platform_device *pdev)
 
 	ret = fsl_ssi_debugfs_create(&ssi_private->dbg_stats, &pdev->dev);
 	if (ret)
-		goto error_asoc_register;
+		goto error_irq;
 
 	/*
 	 * If codec-handle property is missing from SSI node, we assume
-- 
1.9.3

