Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbaFPOf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 10:35:29 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:39191 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbaFPOfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 10:35:25 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61b-b7fbb6d000001be3-a0-539f007a89cb
Content-transfer-encoding: 8BIT
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: broonie@kernel.org
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC] ASoC: Drop const from struct snd_soc_dai_link *of_node
 members
Date: Mon, 16 Jun 2014 16:33:46 +0200
Message-id: <1402929226-5547-1-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsVy+t9jQd0qhvnBBnd6eC2uXDzEZDH14RM2
	i8u75rBZHH7TzurA4rHhcxObx6ZVnWwefVtWMXp83iQXwBLFZZOSmpNZllqkb5fAlTH3WQ9b
	wWPeihUblzI3ME7i7mLk5JAQMJGYsHc9G4QtJnHhHojNxSEkMJ1RYtWPq6wgCV4BQYkfk++x
	dDFycDALyEscuZQNEmYWUJeYNG8RM0R9B5PE9s5OJpAEm4ChRO/RPkYQWwRo6O05ncwQDTkS
	s7t7wZYJC4RKrL2+lwXEZhFQlWjcfIMZZD6vgKvE/0VZIKaEgILEnEk2Exj5ZiE5YhbCEbOQ
	HLGAkXkVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnAYPpPewbiqweIQowAHoxIP7wTHecFC
	rIllxZW5hxglOJiVRHj17gCFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5stQ4UEkhPLEnNTk0t
	SC2CyTJxcEo1MLK2zlQNNeJimdtVfu/YOu+HEcLL9ANOPl3bN73H0+9bi8hVNQ6lN3s3MK/e
	tEq5qvrpaj1+gxnBTpvWJ28XEdrNp9TlVv4oS6hXzVZ4gtQLF/8MtVehfbcWCvmxfm8MVLAJ
	ju8P4WdcGu3Yd1a6c2H6xpzaKkmfm43H5dPnSgnxswg+VIpWYinOSDTUYi4qTgQAH4mXkD8C	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dropping the const qualifiers prevents "passing argument 1 of ‘of_node_put’
discards ‘const’ qualifier from pointer target type" type warnings when
compiling the code dropping reference to cpu_of_node, codec_of_node or
platform_of_node with with an of_node_put() function call.

This lets us to avoid casting to struct device_node * or caching variables
internally in drivers just to be able to properly drop a reference to the
OF node on clean up paths.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 include/sound/soc.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index ed9e2d7..a8d4b79 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -881,7 +881,7 @@ struct snd_soc_dai_link {
 	 * only for codec to codec links, or systems using device tree.
 	 */
 	const char *cpu_name;
-	const struct device_node *cpu_of_node;
+	struct device_node *cpu_of_node;
 	/*
 	 * You MAY specify the DAI name of the CPU DAI. If this information is
 	 * omitted, the CPU-side DAI is matched using .cpu_name/.cpu_of_node
@@ -893,7 +893,7 @@ struct snd_soc_dai_link {
 	 * DT/OF node, but not both.
 	 */
 	const char *codec_name;
-	const struct device_node *codec_of_node;
+	struct device_node *codec_of_node;
 	/* You MUST specify the DAI name within the codec */
 	const char *codec_dai_name;
 	/*
@@ -902,7 +902,7 @@ struct snd_soc_dai_link {
 	 * do not need a platform.
 	 */
 	const char *platform_name;
-	const struct device_node *platform_of_node;
+	struct device_node *platform_of_node;
 	int be_id;	/* optional ID for machine driver BE identification */

 	const struct snd_soc_pcm_stream *params;
--
1.7.9.5

