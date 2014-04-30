Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758427AbaD3JGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 05:06:36 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:57922 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbaD3JGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 05:06:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ASoC: cq93vc: fix cq93vc_get_regmap build error
Date: Wed, 30 Apr 2014 11:06:29 +0200
Message-ID: <4308079.So6q7GrfYB@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:QbdPDx2/FGl+k52//pjIhhrWVuAgfiDNe1fhm95fiP3
 9F+/oK6XBQk5LwW760dQ+kRSTZ+G/bGYJRfcQ5M98/Z2Wuihq5
 lxgmtUOYFC0V3KO9ct8OF/qDHe4GDI3UEyBwJV93HrkQNp2maN
 3TqfbOAfn8pys1E1urJCbyzrkfjVgpxLymMEXWmH1p+Zk4PUrr
 OICyTqujmD8NHhOrDOET/YZ3Y7ADbZEV/MoaTVtd/Pj+zgDSx4
 oZXrSv1BvYimb+2/WEYRs9iHGW1Avyo0bXt5x80hRX7q1WXHgA
 mKoyUL6hvOpwHGKnDqlJQp7XcPBscHiU+Yf2sTVpc/jot6/U1A
 s3zYPA1SvXhLQ65db78Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

49101a25acd69c "ASoC: cq93vc: Remove the set_cache_io() entirely from
ASoC probe" introduced the cq93vc_get_regmap function that has an
obvious build error referring to the 'codec' variable that is not
declared anywhere"

sound/soc/codecs/cq93vc.c: In function 'cq93vc_get_regmap':
sound/soc/codecs/cq93vc.c:157:34: error: 'codec' undeclared (first use in this function)
  struct davinci_vc *davinci_vc = codec->dev->platform_data;
                                  ^

This changes the code to compile again, presumably in the way it was
intended. Not tested.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Xiubo Li <Li.Xiubo@freescale.com>

diff --git a/sound/soc/codecs/cq93vc.c b/sound/soc/codecs/cq93vc.c
index 5ee48c8..537327c 100644
--- a/sound/soc/codecs/cq93vc.c
+++ b/sound/soc/codecs/cq93vc.c
@@ -154,7 +154,7 @@ static int cq93vc_remove(struct snd_soc_codec *codec)
 
 static struct regmap *cq93vc_get_regmap(struct device *dev)
 {
-	struct davinci_vc *davinci_vc = codec->dev->platform_data;
+	struct davinci_vc *davinci_vc = dev->platform_data;
 
 	return davinci_vc->regmap;
 }

