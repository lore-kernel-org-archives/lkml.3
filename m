Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041AbaIZJqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:46:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754879AbaIZJqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:15 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Mark Brown <broonie@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 079/142] ASoC: max98090: Fix missing free_irq
Date: Fri, 26 Sep 2014 11:44:50 +0200
Message-Id: <48e7ba73bbee8c13668389bc26b96a3bff6c9e28.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 4adeb0ccf86a5af1825bbfe290dee9e60a5ab870 upstream.

max98090.c doesn't free the threaded interrupt it requests. This causes
an oops when doing "cat /proc/interrupts" after snd-soc-max98090.ko is
unloaded.

Fix this by requesting the interrupt by using devm_request_threaded_irq().

Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/soc/codecs/max98090.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
index 9ad8f019adcd..764d0ea42e7c 100644
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
2.1.0

