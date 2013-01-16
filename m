Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304Ab3APQFT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:05:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36254 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932274Ab3APQFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:05:16 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 122/222] ASoC: sigmadsp: Fix endianness conversion issue
Date: Wed, 16 Jan 2013 13:55:22 -0200
Message-Id: <1358351822-7675-123-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit a3adb1432d7a3ad86bb17a1638e44414537e4118 upstream.

The 'addr' field of the sigma_action struct is stored as big endian in the
firmware file.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/soc/codecs/sigmadsp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/sigmadsp.c b/sound/soc/codecs/sigmadsp.c
index 5be42bf..4068f24 100644
--- a/sound/soc/codecs/sigmadsp.c
+++ b/sound/soc/codecs/sigmadsp.c
@@ -225,7 +225,7 @@ EXPORT_SYMBOL(process_sigma_firmware);
 static int sigma_action_write_regmap(void *control_data,
 	const struct sigma_action *sa, size_t len)
 {
-	return regmap_raw_write(control_data, le16_to_cpu(sa->addr),
+	return regmap_raw_write(control_data, be16_to_cpu(sa->addr),
 		sa->payload, len - 2);
 }
 
-- 
1.7.9.5

