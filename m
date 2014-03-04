Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952AbaCDUWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:22:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41680 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757216AbaCDUFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:05:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>, Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.10 48/97] ASoC: sta32x: Fix cache sync
Date: Tue,  4 Mar 2014 12:04:01 -0800
Message-Id: <20140304200347.618508896@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200345.895517495@linuxfoundation.org>
References: <20140304200345.895517495@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit 70ff00f82a6af0ff68f8f7b411738634ce2f20d0 upstream.

codec->control_data contains a pointer to the regmap struct of the device, not
to the device private data. Use snd_soc_codec_get_drvdata() instead.

The issue was introduced in commit 29fdf4fbbe ("ASoC: sta32x: Convert to
regmap").

Fixes: 29fdf4fbbe (ASoC: sta32x: Convert to regmap)
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/sta32x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/sta32x.c
+++ b/sound/soc/codecs/sta32x.c
@@ -331,7 +331,7 @@ static int sta32x_sync_coef_shadow(struc
 
 static int sta32x_cache_sync(struct snd_soc_codec *codec)
 {
-	struct sta32x_priv *sta32x = codec->control_data;
+	struct sta32x_priv *sta32x = snd_soc_codec_get_drvdata(codec);
 	unsigned int mute;
 	int rc;
 


