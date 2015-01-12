Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbbALSF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:05:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57459 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbbALSFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:05:50 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lars-Peter Clausen <lars@metafoo.de>, Mark Brown <broonie@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 038/216] ASoC: sigmadsp: Refuse to load firmware files with a non-supported version
Date: Mon, 12 Jan 2015 18:02:35 +0000
Message-Id: <1421085933-32536-39-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit 50c0f21b42dd4cd02b51f82274f66912d9a7fa32 upstream.

Make sure to check the version field of the firmware header to make sure to
not accidentally try to parse a firmware file with a different layout.
Trying to do so can result in loading invalid firmware code to the device.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/codecs/sigmadsp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/codecs/sigmadsp.c b/sound/soc/codecs/sigmadsp.c
index f2de7e049bc6..81a38dd9af1f 100644
--- a/sound/soc/codecs/sigmadsp.c
+++ b/sound/soc/codecs/sigmadsp.c
@@ -159,6 +159,13 @@ int _process_sigma_firmware(struct device *dev,
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
2.1.4

