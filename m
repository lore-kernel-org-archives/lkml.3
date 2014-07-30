Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbaG3Bvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 21:51:39 -0400
Received: from regular1.263xmail.com ([211.150.99.131]:36042 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255AbaG3Bvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:51:37 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: xjq@rock-chips.com
X-FST-TO: broonie@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: xjq@rock-chips.com
X-UNIQUE-TAG: <24ec7e3f7a7a89170724cef151eb7aef>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: jianqun <xjq@rock-chips.com>
To: broonie@kernel.org, lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        tbleung@chromium.org, dgreid@chromium.org, kevin.strasser@intel.com,
        jarkko.nikula@linux.intel.com, swarren@nvidia.com,
        ralph.birt@maximintegrated.com
Cc: heiko@sntech.de, alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        xujianqun <xjq@rock-chips.com>
Subject: [PATCH] ASoC: max98090 not need to return fail if fail to request hpdet irq.
Date: Wed, 30 Jul 2014 09:50:10 +0800
Message-Id: <1406685010-25108-1-git-send-email-xjq@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: xujianqun <xjq@rock-chips.com>

Since hardware may not MUST to use IRQ pin of max98090 as jack detect, the
driver can work well without it, can report jack trigger to CPU by a GPIO.

But here driver will register fail caused by failed to request irq.

Signed-off-by: xujianqun <xjq@rock-chips.com>
---
 sound/soc/codecs/max98090.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
index 566919c..bc124ff 100644
--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -2515,6 +2515,8 @@ static int max98090_probe(struct snd_soc_codec *codec)
 
 	max98090_add_widgets(codec);
 
+	return 0;
+
 err_access:
 	return ret;
 }
-- 
1.7.9.5


