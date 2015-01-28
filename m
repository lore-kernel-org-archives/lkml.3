Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764141AbbA2DW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:22:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46941 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964915AbbA2Cfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:35:48 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lars-Peter Clausen <lars@metafoo.de>, Mark Brown <broonie@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 040/139] ASoC: sigmadsp: Refuse to load firmware files with a non-supported version
Date: Wed, 28 Jan 2015 14:19:43 -0800
Message-Id: <1422483682-15393-41-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit 50c0f21b42dd4cd02b51f82274f66912d9a7fa32 upstream.

Make sure to check the version field of the firmware header to make sure to
not accidentally try to parse a firmware file with a different layout.
Trying to do so can result in loading invalid firmware code to the device.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/codecs/sigmadsp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/codecs/sigmadsp.c b/sound/soc/codecs/sigmadsp.c
index 4068f24..bb3878c 100644
--- a/sound/soc/codecs/sigmadsp.c
+++ b/sound/soc/codecs/sigmadsp.c
@@ -176,6 +176,13 @@ static int _process_sigma_firmware(struct device *dev,
 		goto done;
 	}
 
+	if (ssfw_head->version != 1) {
+		dev_err(dev,
+			"Failed to load firmware: Invalid version %d. Supported firmware versions: 1\n",
+			ssfw_head->version);
+		goto done;
+	}
+
 	crc = crc32(0, fw->data + sizeof(*ssfw_head),
 			fw->size - sizeof(*ssfw_head));
 	pr_debug("%s: crc=%x\n", __func__, crc);
-- 
1.9.1

