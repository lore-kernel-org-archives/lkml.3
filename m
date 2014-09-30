Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbaI3Vrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:47:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32862 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbaI3Vip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:38:45 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Mark Brown <broonie@linaro.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 082/103] ASoC: rt5640: Do not allow regmap to use bulk read-write operations
Date: Tue, 30 Sep 2014 14:31:27 -0700
Message-Id: <1412112708-27356-83-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

commit f4821e8e8e957fe4c601a49b9a97b7399d5f7ab1 upstream.

Debugging showed Realtek RT5642 doesn't support autoincrementing writes so
driver should set the use_single_rw flag for regmap.

Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/codecs/rt5640.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/rt5640.c b/sound/soc/codecs/rt5640.c
index 8869249..5cb515b 100644
--- a/sound/soc/codecs/rt5640.c
+++ b/sound/soc/codecs/rt5640.c
@@ -2071,6 +2071,7 @@ static struct snd_soc_codec_driver soc_codec_dev_rt5640 = {
 static const struct regmap_config rt5640_regmap = {
 	.reg_bits = 8,
 	.val_bits = 16,
+	.use_single_rw = true,
 
 	.max_register = RT5640_VENDOR_ID2 + 1 + (ARRAY_SIZE(rt5640_ranges) *
 					       RT5640_PR_SPACING),
-- 
1.9.1

