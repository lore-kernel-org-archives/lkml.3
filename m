Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350Ab3D3OKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 10:10:31 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:60719 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932273Ab3D3OK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 10:10:26 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 1/3] ASoC: dapm: use clk_prepare_enable and clk_disable_unprepare
Date: Tue, 30 Apr 2013 16:09:52 +0200
Message-Id: <1367330994-7259-2-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1367330994-7259-1-git-send-email-fabio.baltieri@linaro.org>
References: <1367330994-7259-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update dapm_clock_event to use clk_prepare_enable and
clk_disable_unprepare.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 sound/soc/soc-dapm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index 21779a6..a80c883 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -1095,9 +1095,9 @@ int dapm_clock_event(struct snd_soc_dapm_widget *w,
 
 #ifdef CONFIG_HAVE_CLK
 	if (SND_SOC_DAPM_EVENT_ON(event)) {
-		return clk_enable(w->clk);
+		return clk_prepare_enable(w->clk);
 	} else {
-		clk_disable(w->clk);
+		clk_disable_unprepare(w->clk);
 		return 0;
 	}
 #endif
-- 
1.8.2

