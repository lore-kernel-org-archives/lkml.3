Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbaLaQVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 11:21:24 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:36062 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750760AbaLaQVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 11:21:21 -0500
From: Andrew Jackson <andrew.jackson@arm.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Andrew Jackson <Andrew.Jackson@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] ASoC: dwc: Remove unnecessary conditional compilation
Date: Wed, 31 Dec 2014 16:20:43 +0000
Message-Id: <1420042843-3371-1-git-send-email-andrew.jackson@arm.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Jackson <Andrew.Jackson@arm.com>

of_match_ptr is already conditionally compiled based on
CONFIG_OF so further conditional compilation is not
required.  Remove conditional compilation surrounding
of_match_ptr.

Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
---
 sound/soc/dwc/designware_i2s.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/sound/soc/dwc/designware_i2s.c b/sound/soc/dwc/designware_i2s.c
index 99cf64b..a3e97b4 100644
--- a/sound/soc/dwc/designware_i2s.c
+++ b/sound/soc/dwc/designware_i2s.c
@@ -624,9 +624,7 @@ static struct platform_driver dw_i2s_driver = {
 	.remove		= dw_i2s_remove,
 	.driver		= {
 		.name	= "designware-i2s",
-#ifdef CONFIG_OF
 		.of_match_table = of_match_ptr(dw_i2s_of_match),
-#endif
 	},
 };
 
-- 
1.7.1

