Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759760Ab3LBVWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:22:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38411 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab3LBTMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:12:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicolin Chen <b42378@freescale.com>, Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.10 016/173] ASoC: wm8962: Turn on regcache_cache_only before disabling regulator
Date: Mon,  2 Dec 2013 11:09:59 -0800
Message-Id: <20131202191144.729714806@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <b42378@freescale.com>

commit 50bfcf2df2fadf77e143d6099150e6fa7ef4d78c upstream.

It's safer to turn on regcache_cache_only before disabling regulator since
the driver will turn off the regcache_cache_only after enabling regulator.

If we remain cache_only false, some command like 'amixer cset' would get
failure if being run before wm8962_resume().

Signed-off-by: Nicolin Chen <b42378@freescale.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm8962.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -3686,6 +3686,8 @@ static int wm8962_i2c_probe(struct i2c_c
 	if (ret < 0)
 		goto err_enable;
 
+	regcache_cache_only(wm8962->regmap, true);
+
 	/* The drivers should power up as needed */
 	regulator_bulk_disable(ARRAY_SIZE(wm8962->supplies), wm8962->supplies);
 


