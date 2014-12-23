Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294AbaLWN6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 08:58:25 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:38047 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755861AbaLWN50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 08:57:26 -0500
From: Andrew Jackson <andrew.jackson@arm.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Andrew Jackson <Andrew.Jackson@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/5] ASoC: dwc: Prepare clock before use
Date: Tue, 23 Dec 2014 13:56:23 +0000
Message-Id: <63becb5f356c25b226b9dbc5825357e894d0f08b.1419342218.git.Andrew.Jackson@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1419342218.git.Andrew.Jackson@arm.com>
References: <cover.1419342218.git.Andrew.Jackson@arm.com>
In-Reply-To: <cover.1419342218.git.Andrew.Jackson@arm.com>
References: <cover.1419342218.git.Andrew.Jackson@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Jackson <Andrew.Jackson@arm.com>

Some I2S clocks may require some time to get the clock ready
for operation and so need to be prepared before they are enabled.
So, prepare the clock as well as enabling it, but combine the
two through clk_prepare_enable.

Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
---
 sound/soc/dwc/designware_i2s.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/dwc/designware_i2s.c b/sound/soc/dwc/designware_i2s.c
index 06d3a34..9573ec7 100644
--- a/sound/soc/dwc/designware_i2s.c
+++ b/sound/soc/dwc/designware_i2s.c
@@ -411,7 +411,7 @@ static int dw_i2s_probe(struct platform_device *pdev)
 	if (IS_ERR(dev->clk))
 		return  PTR_ERR(dev->clk);
 
-	ret = clk_enable(dev->clk);
+	ret = clk_prepare_enable(dev->clk);
 	if (ret < 0)
 		goto err_clk_put;
 
-- 
1.7.1

