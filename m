Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866Ab3LERzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:55:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38200 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933182Ab3LERhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:37:09 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicolin Chen <b42378@freescale.com>, Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 35/90] ASoC: wm8962: Turn on regcache_cache_only before disabling regulator
Date: Thu,  5 Dec 2013 17:35:17 +0000
Message-Id: <1386264972-5399-36-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <b42378@freescale.com>

commit 50bfcf2df2fadf77e143d6099150e6fa7ef4d78c upstream.

It's safer to turn on regcache_cache_only before disabling regulator since
the driver will turn off the regcache_cache_only after enabling regulator.

If we remain cache_only false, some command like 'amixer cset' would get
failure if being run before wm8962_resume().

Signed-off-by: Nicolin Chen <b42378@freescale.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/codecs/wm8962.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index bff98fb..c4afa36 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -3687,6 +3687,8 @@ static __devinit int wm8962_i2c_probe(struct i2c_client *i2c,
 	if (ret < 0)
 		goto err_regmap;
 
+	regcache_cache_only(wm8962->regmap, true);
+
 	/* The drivers should power up as needed */
 	regulator_bulk_disable(ARRAY_SIZE(wm8962->supplies), wm8962->supplies);
 
-- 
1.8.3.2

