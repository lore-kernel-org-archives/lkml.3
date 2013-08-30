Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab3H3PiF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 11:38:05 -0400
Received: from smtp-out-137.synserver.de ([212.40.185.137]:1378 "EHLO
	smtp-out-137.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756692Ab3H3PiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 11:38:03 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 6029
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@kernel.org>
Cc: Bard Liao <bardliao@realtek.com>, Stephen Warren <swarren@wwwdotorg.org>,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] ASoC: dapm: Fix auto-disable for inverted controls
Date: Fri, 30 Aug 2013 17:39:33 +0200
Message-Id: <1377877173-16987-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to make sure that the control's cached value is initialized to the same
value as the control's widget->on_val. Otherwise updates might be lost.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/soc/soc-dapm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index 548b1c9..c17c14c 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -229,6 +229,8 @@ static int dapm_kcontrol_data_alloc(struct snd_soc_dapm_widget *widget,
 			template.id = snd_soc_dapm_kcontrol;
 			template.name = kcontrol->id.name;
 
+			data->value = template.on_val;
+
 			data->widget = snd_soc_dapm_new_control(widget->dapm,
 				&template);
 			if (!data->widget) {
-- 
1.8.0

