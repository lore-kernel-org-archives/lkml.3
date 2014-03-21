Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966757AbaCUBEH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:04:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36786 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965352AbaCUAE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:04:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>, Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.13 112/149] ASoC: si476x: Fix IO setup
Date: Thu, 20 Mar 2014 17:04:35 -0700
Message-Id: <20140321000440.844630921@linuxfoundation.org>
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

commit 58d4d3c976b33784a1443c446a3d7203bf2153f0 upstream.

The si476x is a MFD device and the CODEC driver is using the regmap struct of
the parent device, hence automatic IO setup will not work and we need to
manually call snd_soc_codec_set_cache_io(). The issue was introduced commit
d6173df35f ("ASoC: si476x: Remove custom register I/O implementation")

Fixes: d6173df35f ("ASoC: si476x: Remove custom register I/O implementation")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/si476x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/si476x.c
+++ b/sound/soc/codecs/si476x.c
@@ -210,7 +210,7 @@ out:
 static int si476x_codec_probe(struct snd_soc_codec *codec)
 {
 	codec->control_data = dev_get_regmap(codec->dev->parent, NULL);
-	return 0;
+	return snd_soc_codec_set_cache_io(codec, 0, 0, SND_SOC_REGMAP);
 }
 
 static struct snd_soc_dai_ops si476x_dai_ops = {


