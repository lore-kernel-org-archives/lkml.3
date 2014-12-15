Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbaLOO10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:27:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38265 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298AbaLOO1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:27:22 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mark Brown <broonie@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 024/168] ASoC: cs42l51: re-hook of_match_table pointer
Date: Mon, 15 Dec 2014 14:24:38 +0000
Message-Id: <1418653622-21105-25-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

commit 2cb1e0259f50c7be88eb277c7442fa74a3ce7c57 upstream.

In commit a1253ef6d3fa ("ASoC: cs42l51: split i2c from codec driver"),
the I2C part of the CS42L51 was moved to a separate file, but the
definition of the of_device_id array was left in the driver file
itself, no longer connected to the platform_driver structure using the
.of_match_table pointer.

This commit exports the of_device_id array in cs42l51, and uses it as
.of_match_able in cs42l51-i2c.c. This solution was suggested by Brian
Austin.

Fixes: a1253ef6d3fa ("ASoC: cs42l51: split i2c from codec driver")
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Acked-by: Brian Austin <brian.austin@cirrus.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/codecs/cs42l51-i2c.c | 1 +
 sound/soc/codecs/cs42l51.c     | 4 +++-
 sound/soc/codecs/cs42l51.h     | 1 +
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs42l51-i2c.c b/sound/soc/codecs/cs42l51-i2c.c
index cee51ae177c1..c40428f25ba5 100644
--- a/sound/soc/codecs/cs42l51-i2c.c
+++ b/sound/soc/codecs/cs42l51-i2c.c
@@ -46,6 +46,7 @@ static struct i2c_driver cs42l51_i2c_driver = {
 	.driver = {
 		.name = "cs42l51",
 		.owner = THIS_MODULE,
+		.of_match_table = cs42l51_of_match,
 	},
 	.probe = cs42l51_i2c_probe,
 	.remove = cs42l51_i2c_remove,
diff --git a/sound/soc/codecs/cs42l51.c b/sound/soc/codecs/cs42l51.c
index 09488d97de60..669c38fc3034 100644
--- a/sound/soc/codecs/cs42l51.c
+++ b/sound/soc/codecs/cs42l51.c
@@ -558,11 +558,13 @@ error:
 }
 EXPORT_SYMBOL_GPL(cs42l51_probe);
 
-static const struct of_device_id cs42l51_of_match[] = {
+const struct of_device_id cs42l51_of_match[] = {
 	{ .compatible = "cirrus,cs42l51", },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, cs42l51_of_match);
+EXPORT_SYMBOL_GPL(cs42l51_of_match);
+
 MODULE_AUTHOR("Arnaud Patard <arnaud.patard@rtp-net.org>");
 MODULE_DESCRIPTION("Cirrus Logic CS42L51 ALSA SoC Codec Driver");
 MODULE_LICENSE("GPL");
diff --git a/sound/soc/codecs/cs42l51.h b/sound/soc/codecs/cs42l51.h
index 8c55bf384bc6..0ca805492ac4 100644
--- a/sound/soc/codecs/cs42l51.h
+++ b/sound/soc/codecs/cs42l51.h
@@ -22,6 +22,7 @@ struct device;
 
 extern const struct regmap_config cs42l51_regmap;
 int cs42l51_probe(struct device *dev, struct regmap *regmap);
+extern const struct of_device_id cs42l51_of_match[];
 
 #define CS42L51_CHIP_ID			0x1B
 #define CS42L51_CHIP_REV_A		0x00
-- 
2.1.3

