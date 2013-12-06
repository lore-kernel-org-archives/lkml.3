Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485Ab3LFOBb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:01:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43913 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161460Ab3LFNBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:01:19 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicolin Chen <b42378@freescale.com>, Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 081/272] ASoC: wm8962: Turn on regcache_cache_only before disabling regulator
Date: Fri,  6 Dec 2013 12:56:10 +0000
Message-Id: <1386334761-25517-82-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

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
index e2de9ec..ca3ef5a 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -3723,6 +3723,8 @@ static int wm8962_i2c_probe(struct i2c_client *i2c,
 	if (ret < 0)
 		goto err_enable;
 
+	regcache_cache_only(wm8962->regmap, true);
+
 	/* The drivers should power up as needed */
 	regulator_bulk_disable(ARRAY_SIZE(wm8962->supplies), wm8962->supplies);
 
-- 
1.8.3.2

