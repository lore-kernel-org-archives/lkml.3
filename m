Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179AbaHZODs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 10:03:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:23606 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758078AbaHZODp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 10:03:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,404,1406617200"; 
   d="scan'208";a="581860821"
From: Jarkko Nikula <jarkko.nikula@linux.intel.com>
To: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Bard Liao <bardliao@realtek.com>, Oder Chiou <oder_chiou@realtek.com>
Subject: [PATCH 2/2] ASoC: rt5640: Do not allow regmap to use bulk read-write operations
Date: Tue, 26 Aug 2014 17:03:13 +0300
Message-Id: <1409061793-10495-3-git-send-email-jarkko.nikula@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409061793-10495-1-git-send-email-jarkko.nikula@linux.intel.com>
References: <1409061793-10495-1-git-send-email-jarkko.nikula@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Debugging showed Realtek RT5642 doesn't support autoincrementing writes so
driver should set the use_single_rw flag for regmap.

Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Cc: Bard Liao <bardliao@realtek.com>
Cc: Oder Chiou <oder_chiou@realtek.com>
---
I'm not sure is this specific only to RT5642? I was thinking that because
commit 4c9185be5e8e ("ASoC: rt5640: Move cache sync() to resume()") is way
after 75a5f89f635c ("regmap: cache: Write consecutive registers in a single
block write") which started to use block writes during rbtree sync.
Or maybe 4c9185be5e8e was done on top of older kernel?
---
 sound/soc/codecs/rt5640.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/rt5640.c b/sound/soc/codecs/rt5640.c
index 6bc6efdec550..f1ec6e6bd08a 100644
--- a/sound/soc/codecs/rt5640.c
+++ b/sound/soc/codecs/rt5640.c
@@ -2059,6 +2059,7 @@ static struct snd_soc_codec_driver soc_codec_dev_rt5640 = {
 static const struct regmap_config rt5640_regmap = {
 	.reg_bits = 8,
 	.val_bits = 16,
+	.use_single_rw = true,
 
 	.max_register = RT5640_VENDOR_ID2 + 1 + (ARRAY_SIZE(rt5640_ranges) *
 					       RT5640_PR_SPACING),
-- 
2.1.0

