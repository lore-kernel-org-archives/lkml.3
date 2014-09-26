Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbaIZJqa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:46:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32892 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754883AbaIZJqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:15 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Mark Brown <broonie@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 082/142] ASoC: rt5640: Do not allow regmap to use bulk read-write operations
Date: Fri, 26 Sep 2014 11:44:53 +0200
Message-Id: <0d9b25fe9f64cb802d6178516c5564ca89302f2c.1411724724.git.jslaby@suse.cz>
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

commit f4821e8e8e957fe4c601a49b9a97b7399d5f7ab1 upstream.

Debugging showed Realtek RT5642 doesn't support autoincrementing writes so
driver should set the use_single_rw flag for regmap.

Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/soc/codecs/rt5640.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/rt5640.c b/sound/soc/codecs/rt5640.c
index c26a8f814b18..aa5253a3548e 100644
--- a/sound/soc/codecs/rt5640.c
+++ b/sound/soc/codecs/rt5640.c
@@ -2061,6 +2061,7 @@ static struct snd_soc_codec_driver soc_codec_dev_rt5640 = {
 static const struct regmap_config rt5640_regmap = {
 	.reg_bits = 8,
 	.val_bits = 16,
+	.use_single_rw = true,
 
 	.max_register = RT5640_VENDOR_ID2 + 1 + (ARRAY_SIZE(rt5640_ranges) *
 					       RT5640_PR_SPACING),
-- 
2.1.0

