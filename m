Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490Ab3GBJT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 05:19:28 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:45822 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268Ab3GBJT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 05:19:27 -0400
MIME-Version: 1.0
Date: Tue, 2 Jul 2013 17:19:25 +0800
Message-ID: <CAPgLHd9kdRD1fJZZWLN+=0ddsb3ZxjovA3OU4Ctrbvj_b3Jw3A@mail.gmail.com>
Subject: [PATCH] ASoC: db1200: add .owner to struct snd_soc_card
From: Wei Yongjun <weiyj.lk@gmail.com>
To: lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        wfp5p@virginia.edu
Cc: yongjun_wei@trendmicro.com.cn, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add missing .owner of struct snd_soc_card. This prevents the
module from being removed from underneath its users.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 sound/soc/au1x/db1200.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/au1x/db1200.c b/sound/soc/au1x/db1200.c
index a497a0c..2d2407d 100644
--- a/sound/soc/au1x/db1200.c
+++ b/sound/soc/au1x/db1200.c
@@ -73,12 +73,14 @@ static struct snd_soc_dai_link db1300_ac97_dai = {
 
 static struct snd_soc_card db1300_ac97_machine = {
 	.name		= "DB1300_AC97",
+	.owner		= THIS_MODULE,
 	.dai_link	= &db1300_ac97_dai,
 	.num_links	= 1,
 };
 
 static struct snd_soc_card db1550_ac97_machine = {
 	.name		= "DB1550_AC97",
+	.owner		= THIS_MODULE,
 	.dai_link	= &db1200_ac97_dai,
 	.num_links	= 1,
 };
@@ -145,6 +147,7 @@ static struct snd_soc_dai_link db1300_i2s_dai = {
 
 static struct snd_soc_card db1300_i2s_machine = {
 	.name		= "DB1300_I2S",
+	.owner		= THIS_MODULE,
 	.dai_link	= &db1300_i2s_dai,
 	.num_links	= 1,
 };
@@ -161,6 +164,7 @@ static struct snd_soc_dai_link db1550_i2s_dai = {
 
 static struct snd_soc_card db1550_i2s_machine = {
 	.name		= "DB1550_I2S",
+	.owner		= THIS_MODULE,
 	.dai_link	= &db1550_i2s_dai,
 	.num_links	= 1,
 };

