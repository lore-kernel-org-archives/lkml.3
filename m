Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233AbaLEXrM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:47:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53755 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbaLEWp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:45:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Brian Austin <brian.austin@cirrus.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.17 042/122] ASoC: cs42l51: re-hook of_match_table pointer
Date: Fri,  5 Dec 2014 14:43:36 -0800
Message-Id: <20141205223311.824869395@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/cs42l51-i2c.c |    1 +
 sound/soc/codecs/cs42l51.c     |    4 +++-
 sound/soc/codecs/cs42l51.h     |    1 +
 3 files changed, 5 insertions(+), 1 deletion(-)

--- a/sound/soc/codecs/cs42l51-i2c.c
+++ b/sound/soc/codecs/cs42l51-i2c.c
@@ -46,6 +46,7 @@ static struct i2c_driver cs42l51_i2c_dri
 	.driver = {
 		.name = "cs42l51",
 		.owner = THIS_MODULE,
+		.of_match_table = cs42l51_of_match,
 	},
 	.probe = cs42l51_i2c_probe,
 	.remove = cs42l51_i2c_remove,
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
--- a/sound/soc/codecs/cs42l51.h
+++ b/sound/soc/codecs/cs42l51.h
@@ -22,6 +22,7 @@ struct device;
 
 extern const struct regmap_config cs42l51_regmap;
 int cs42l51_probe(struct device *dev, struct regmap *regmap);
+extern const struct of_device_id cs42l51_of_match[];
 
 #define CS42L51_CHIP_ID			0x1B
 #define CS42L51_CHIP_REV_A		0x00


