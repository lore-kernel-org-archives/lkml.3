Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587AbaIOWUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:20:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51360 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758538AbaIOWUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:20:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Mark Brown <broonie@linaro.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 052/187] ASoC: max98090: Fix missing free_irq
Date: Mon, 15 Sep 2014 15:07:42 -0700
Message-Id: <1410818997-9432-53-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

commit 4adeb0ccf86a5af1825bbfe290dee9e60a5ab870 upstream.

max98090.c doesn't free the threaded interrupt it requests. This causes
an oops when doing "cat /proc/interrupts" after snd-soc-max98090.ko is
unloaded.

Fix this by requesting the interrupt by using devm_request_threaded_irq().

Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/codecs/max98090.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
index 9ad8f01..764d0ea 100644
--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -2250,7 +2250,7 @@ static int max98090_probe(struct snd_soc_codec *codec)
 	/* Register for interrupts */
 	dev_dbg(codec->dev, "irq = %d\n", max98090->irq);
 
-	ret = request_threaded_irq(max98090->irq, NULL,
+	ret = devm_request_threaded_irq(codec->dev, max98090->irq, NULL,
 		max98090_interrupt, IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 		"max98090_interrupt", codec);
 	if (ret < 0) {
-- 
1.9.1

