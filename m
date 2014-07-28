Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569AbaG1GOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 02:14:52 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:53578 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbaG1GOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 02:14:50 -0400
From: Kiran Padwal <kiran.padwal21@gmail.com>
To: lgirdwood@gmail.com, broonie@kernel.org
Cc: perex@perex.cz, tiwai@suse.de, s.hauer@pengutronix.de,
        fabio.estevam@freescale.com, kuninori.morimoto.gx@renesas.com,
        Li.Xiubo@freescale.com, kiran.padwal21@gmail.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ASoC: ak4642: Make of_device_id array const
Date: Mon, 28 Jul 2014 11:41:04 +0530
Message-Id: <1406527864-22092-1-git-send-email-kiran.padwal21@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make of_device_id array const, because all OF functions handle it as const

Signed-off-by: Kiran Padwal <kiran.padwal21@gmail.com>
---
 sound/soc/codecs/ak4642.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/ak4642.c b/sound/soc/codecs/ak4642.c
index 3ba4c0f..0417125 100644
--- a/sound/soc/codecs/ak4642.c
+++ b/sound/soc/codecs/ak4642.c
@@ -547,7 +547,7 @@ static const struct ak4642_drvdata ak4648_drvdata = {
 	.extended_frequencies = 1,
 };
 
-static struct of_device_id ak4642_of_match[];
+static const struct of_device_id ak4642_of_match[];
 static int ak4642_i2c_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
 {
@@ -593,7 +593,7 @@ static int ak4642_i2c_remove(struct i2c_client *client)
 	return 0;
 }
 
-static struct of_device_id ak4642_of_match[] = {
+static const struct of_device_id ak4642_of_match[] = {
 	{ .compatible = "asahi-kasei,ak4642",	.data = &ak4642_drvdata},
 	{ .compatible = "asahi-kasei,ak4643",	.data = &ak4643_drvdata},
 	{ .compatible = "asahi-kasei,ak4648",	.data = &ak4648_drvdata},
-- 
1.7.9.5

