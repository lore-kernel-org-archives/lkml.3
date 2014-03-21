Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965446AbaCUAEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:04:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36784 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965350AbaCUAE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:04:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>, Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.13 111/149] ASoC: 88pm860: Fix IO setup
Date: Thu, 20 Mar 2014 17:04:34 -0700
Message-Id: <20140321000440.813087833@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit 8eeb5c15131d7b5061c10423eda3ae4c68db4eaf upstream.

The 88pm860 is a MFD device and the CODEC driver is using the regmap struct of
the parent device, hence automatic IO setup will not work and we need to
manually call snd_soc_codec_set_cache_io(). The issue was introduced in commit
f9ded3b2e7 ("ASoC: 88pm860x: Use regmap for I/O").

Fixes: f9ded3b2e7 ("ASoC: 88pm860x: Use regmap for I/O").
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/88pm860x-codec.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/soc/codecs/88pm860x-codec.c
+++ b/sound/soc/codecs/88pm860x-codec.c
@@ -1328,6 +1328,9 @@ static int pm860x_probe(struct snd_soc_c
 	pm860x->codec = codec;
 
 	codec->control_data = pm860x->regmap;
+	ret = snd_soc_codec_set_cache_io(codec, 0, 0, SND_SOC_REGMAP);
+	if (ret)
+		return ret;
 
 	for (i = 0; i < 4; i++) {
 		ret = request_threaded_irq(pm860x->irq[i], NULL,


