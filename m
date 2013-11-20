Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab3KTNRN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 08:17:13 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45793 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752877Ab3KTNRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 08:17:10 -0500
Date: Wed, 20 Nov 2013 13:17:07 +0000
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        ckeepax@opensource.wolfsonmicro.com,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] ASoC: wm5110: Add extra AIF2 channels
Message-ID: <20131120131707.GB7357@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: D.J. Barrow <dbarrow@wolfsonmicro.com>
Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
---
 include/linux/mfd/arizona/registers.h |  121 +++++++++++++++++++++++++++++++++
 sound/soc/codecs/arizona.c            |    8 ++
 sound/soc/codecs/arizona.h            |    2 +-
 sound/soc/codecs/wm5110.c             |   48 +++++++++++++-
 4 files changed, 176 insertions(+), 3 deletions(-)

diff --git a/include/linux/mfd/arizona/registers.h b/include/linux/mfd/arizona/registers.h
index 4706d3d..8f4c9d7 100644
--- a/include/linux/mfd/arizona/registers.h
+++ b/include/linux/mfd/arizona/registers.h
@@ -511,6 +511,38 @@
 #define ARIZONA_AIF2TX2MIX_INPUT_3_VOLUME        0x74D
 #define ARIZONA_AIF2TX2MIX_INPUT_4_SOURCE        0x74E
 #define ARIZONA_AIF2TX2MIX_INPUT_4_VOLUME        0x74F
+#define ARIZONA_AIF2TX3MIX_INPUT_1_SOURCE        0x750
+#define ARIZONA_AIF2TX3MIX_INPUT_1_VOLUME        0x751
+#define ARIZONA_AIF2TX3MIX_INPUT_2_SOURCE        0x752
+#define ARIZONA_AIF2TX3MIX_INPUT_2_VOLUME        0x753
+#define ARIZONA_AIF2TX3MIX_INPUT_3_SOURCE        0x754
+#define ARIZONA_AIF2TX3MIX_INPUT_3_VOLUME        0x755
+#define ARIZONA_AIF2TX3MIX_INPUT_4_SOURCE        0x756
+#define ARIZONA_AIF2TX3MIX_INPUT_4_VOLUME        0x757
+#define ARIZONA_AIF2TX4MIX_INPUT_1_SOURCE        0x758
+#define ARIZONA_AIF2TX4MIX_INPUT_1_VOLUME        0x759
+#define ARIZONA_AIF2TX4MIX_INPUT_2_SOURCE        0x75A
+#define ARIZONA_AIF2TX4MIX_INPUT_2_VOLUME        0x75B
+#define ARIZONA_AIF2TX4MIX_INPUT_3_SOURCE        0x75C
+#define ARIZONA_AIF2TX4MIX_INPUT_3_VOLUME        0x75D
+#define ARIZONA_AIF2TX4MIX_INPUT_4_SOURCE        0x75E
+#define ARIZONA_AIF2TX4MIX_INPUT_4_VOLUME        0x75F
+#define ARIZONA_AIF2TX5MIX_INPUT_1_SOURCE        0x760
+#define ARIZONA_AIF2TX5MIX_INPUT_1_VOLUME        0x761
+#define ARIZONA_AIF2TX5MIX_INPUT_2_SOURCE        0x762
+#define ARIZONA_AIF2TX5MIX_INPUT_2_VOLUME        0x763
+#define ARIZONA_AIF2TX5MIX_INPUT_3_SOURCE        0x764
+#define ARIZONA_AIF2TX5MIX_INPUT_3_VOLUME        0x765
+#define ARIZONA_AIF2TX5MIX_INPUT_4_SOURCE        0x766
+#define ARIZONA_AIF2TX5MIX_INPUT_4_VOLUME        0x767
+#define ARIZONA_AIF2TX6MIX_INPUT_1_SOURCE        0x768
+#define ARIZONA_AIF2TX6MIX_INPUT_1_VOLUME        0x769
+#define ARIZONA_AIF2TX6MIX_INPUT_2_SOURCE        0x76A
+#define ARIZONA_AIF2TX6MIX_INPUT_2_VOLUME        0x76B
+#define ARIZONA_AIF2TX6MIX_INPUT_3_SOURCE        0x76C
+#define ARIZONA_AIF2TX6MIX_INPUT_3_VOLUME        0x76D
+#define ARIZONA_AIF2TX6MIX_INPUT_4_SOURCE        0x76E
+#define ARIZONA_AIF2TX6MIX_INPUT_4_VOLUME        0x76F
 #define ARIZONA_AIF3TX1MIX_INPUT_1_SOURCE        0x780
 #define ARIZONA_AIF3TX1MIX_INPUT_1_VOLUME        0x781
 #define ARIZONA_AIF3TX1MIX_INPUT_2_SOURCE        0x782
@@ -3726,6 +3758,35 @@
 #define ARIZONA_AIF2TX2_SLOT_WIDTH                    6  /* AIF2TX2_SLOT - [5:0] */
 
 /*
+ * R1355 (0x54B) - AIF2 Frame Ctrl 5
+ */
+#define ARIZONA_AIF2TX3_SLOT_MASK                0x003F  /* AIF2TX3_SLOT - [5:0] */
+#define ARIZONA_AIF2TX3_SLOT_SHIFT                    0  /* AIF2TX3_SLOT - [5:0] */
+#define ARIZONA_AIF2TX3_SLOT_WIDTH                    6  /* AIF2TX3_SLOT - [5:0] */
+
+/*
+ * R1356 (0x54C) - AIF2 Frame Ctrl 6
+ */
+#define ARIZONA_AIF2TX4_SLOT_MASK                0x003F  /* AIF2TX4_SLOT - [5:0] */
+#define ARIZONA_AIF2TX4_SLOT_SHIFT                    0  /* AIF2TX4_SLOT - [5:0] */
+#define ARIZONA_AIF2TX4_SLOT_WIDTH                    6  /* AIF2TX4_SLOT - [5:0] */
+
+
+/*
+ * R1357 (0x54D) - AIF2 Frame Ctrl 7
+ */
+#define ARIZONA_AIF2TX5_SLOT_MASK                0x003F  /* AIF2TX5_SLOT - [5:0] */
+#define ARIZONA_AIF2TX5_SLOT_SHIFT                    0  /* AIF2TX5_SLOT - [5:0] */
+#define ARIZONA_AIF2TX5_SLOT_WIDTH                    6  /* AIF2TX5_SLOT - [5:0] */
+
+/*
+ * R1358 (0x54E) - AIF2 Frame Ctrl 8
+ */
+#define ARIZONA_AIF2TX6_SLOT_MASK                0x003F  /* AIF2TX6_SLOT - [5:0] */
+#define ARIZONA_AIF2TX6_SLOT_SHIFT                    0  /* AIF2TX6_SLOT - [5:0] */
+#define ARIZONA_AIF2TX6_SLOT_WIDTH                    6  /* AIF2TX6_SLOT - [5:0] */
+
+/*
  * R1361 (0x551) - AIF2 Frame Ctrl 11
  */
 #define ARIZONA_AIF2RX1_SLOT_MASK                0x003F  /* AIF2RX1_SLOT - [5:0] */
@@ -3740,8 +3801,52 @@
 #define ARIZONA_AIF2RX2_SLOT_WIDTH                    6  /* AIF2RX2_SLOT - [5:0] */
 
 /*
+ * R1363 (0x553) - AIF2 Frame Ctrl 13
+ */
+#define ARIZONA_AIF2RX3_SLOT_MASK                0x003F  /* AIF2RX3_SLOT - [5:0] */
+#define ARIZONA_AIF2RX3_SLOT_SHIFT                    0  /* AIF2RX3_SLOT - [5:0] */
+#define ARIZONA_AIF2RX3_SLOT_WIDTH                    6  /* AIF2RX3_SLOT - [5:0] */
+
+/*
+ * R1364 (0x554) - AIF2 Frame Ctrl 14
+ */
+#define ARIZONA_AIF2RX4_SLOT_MASK                0x003F  /* AIF2RX4_SLOT - [5:0] */
+#define ARIZONA_AIF2RX4_SLOT_SHIFT                    0  /* AIF2RX4_SLOT - [5:0] */
+#define ARIZONA_AIF2RX4_SLOT_WIDTH                    6  /* AIF2RX4_SLOT - [5:0] */
+
+/*
+ * R1365 (0x555) - AIF2 Frame Ctrl 15
+ */
+#define ARIZONA_AIF2RX5_SLOT_MASK                0x003F  /* AIF2RX5_SLOT - [5:0] */
+#define ARIZONA_AIF2RX5_SLOT_SHIFT                    0  /* AIF2RX5_SLOT - [5:0] */
+#define ARIZONA_AIF2RX5_SLOT_WIDTH                    6  /* AIF2RX5_SLOT - [5:0] */
+
+/*
+ * R1366 (0x556) - AIF2 Frame Ctrl 16
+ */
+#define ARIZONA_AIF2RX6_SLOT_MASK                0x003F  /* AIF2RX6_SLOT - [5:0] */
+#define ARIZONA_AIF2RX6_SLOT_SHIFT                    0  /* AIF2RX6_SLOT - [5:0] */
+#define ARIZONA_AIF2RX6_SLOT_WIDTH                    6  /* AIF2RX6_SLOT - [5:0] */
+
+/*
  * R1369 (0x559) - AIF2 Tx Enables
  */
+#define ARIZONA_AIF2TX6_ENA                      0x0020  /* AIF2TX6_ENA */
+#define ARIZONA_AIF2TX6_ENA_MASK                 0x0020  /* AIF2TX6_ENA */
+#define ARIZONA_AIF2TX6_ENA_SHIFT                     5  /* AIF2TX6_ENA */
+#define ARIZONA_AIF2TX6_ENA_WIDTH                     1  /* AIF2TX6_ENA */
+#define ARIZONA_AIF2TX5_ENA                      0x0010  /* AIF2TX5_ENA */
+#define ARIZONA_AIF2TX5_ENA_MASK                 0x0010  /* AIF2TX5_ENA */
+#define ARIZONA_AIF2TX5_ENA_SHIFT                     4  /* AIF2TX5_ENA */
+#define ARIZONA_AIF2TX5_ENA_WIDTH                     1  /* AIF2TX5_ENA */
+#define ARIZONA_AIF2TX4_ENA                      0x0008  /* AIF2TX4_ENA */
+#define ARIZONA_AIF2TX4_ENA_MASK                 0x0008  /* AIF2TX4_ENA */
+#define ARIZONA_AIF2TX4_ENA_SHIFT                     3  /* AIF2TX4_ENA */
+#define ARIZONA_AIF2TX4_ENA_WIDTH                     1  /* AIF2TX4_ENA */
+#define ARIZONA_AIF2TX3_ENA                      0x0004  /* AIF2TX3_ENA */
+#define ARIZONA_AIF2TX3_ENA_MASK                 0x0004  /* AIF2TX3_ENA */
+#define ARIZONA_AIF2TX3_ENA_SHIFT                     2  /* AIF2TX3_ENA */
+#define ARIZONA_AIF2TX3_ENA_WIDTH                     1  /* AIF2TX3_ENA */
 #define ARIZONA_AIF2TX2_ENA                      0x0002  /* AIF2TX2_ENA */
 #define ARIZONA_AIF2TX2_ENA_MASK                 0x0002  /* AIF2TX2_ENA */
 #define ARIZONA_AIF2TX2_ENA_SHIFT                     1  /* AIF2TX2_ENA */
@@ -3754,6 +3859,22 @@
 /*
  * R1370 (0x55A) - AIF2 Rx Enables
  */
+#define ARIZONA_AIF2RX6_ENA                      0x0020  /* AIF2RX6_ENA */
+#define ARIZONA_AIF2RX6_ENA_MASK                 0x0020  /* AIF2RX6_ENA */
+#define ARIZONA_AIF2RX6_ENA_SHIFT                     5  /* AIF2RX6_ENA */
+#define ARIZONA_AIF2RX6_ENA_WIDTH                     1  /* AIF2RX6_ENA */
+#define ARIZONA_AIF2RX5_ENA                      0x0010  /* AIF2RX5_ENA */
+#define ARIZONA_AIF2RX5_ENA_MASK                 0x0010  /* AIF2RX5_ENA */
+#define ARIZONA_AIF2RX5_ENA_SHIFT                     4  /* AIF2RX5_ENA */
+#define ARIZONA_AIF2RX5_ENA_WIDTH                     1  /* AIF2RX5_ENA */
+#define ARIZONA_AIF2RX4_ENA                      0x0008  /* AIF2RX4_ENA */
+#define ARIZONA_AIF2RX4_ENA_MASK                 0x0008  /* AIF2RX4_ENA */
+#define ARIZONA_AIF2RX4_ENA_SHIFT                     3  /* AIF2RX4_ENA */
+#define ARIZONA_AIF2RX4_ENA_WIDTH                     1  /* AIF2RX4_ENA */
+#define ARIZONA_AIF2RX3_ENA                      0x0004  /* AIF2RX3_ENA */
+#define ARIZONA_AIF2RX3_ENA_MASK                 0x0004  /* AIF2RX3_ENA */
+#define ARIZONA_AIF2RX3_ENA_SHIFT                     2  /* AIF2RX3_ENA */
+#define ARIZONA_AIF2RX3_ENA_WIDTH                     1  /* AIF2RX3_ENA */
 #define ARIZONA_AIF2RX2_ENA                      0x0002  /* AIF2RX2_ENA */
 #define ARIZONA_AIF2RX2_ENA_MASK                 0x0002  /* AIF2RX2_ENA */
 #define ARIZONA_AIF2RX2_ENA_SHIFT                     1  /* AIF2RX2_ENA */
diff --git a/sound/soc/codecs/arizona.c b/sound/soc/codecs/arizona.c
index fea9910..6188b05 100644
--- a/sound/soc/codecs/arizona.c
+++ b/sound/soc/codecs/arizona.c
@@ -292,6 +292,10 @@ const char *arizona_mixer_texts[ARIZONA_NUM_MIXER_INPUTS] = {
 	"AIF1RX8",
 	"AIF2RX1",
 	"AIF2RX2",
+	"AIF2RX3",
+	"AIF2RX4",
+	"AIF2RX5",
+	"AIF2RX6",
 	"AIF3RX1",
 	"AIF3RX2",
 	"SLIMRX1",
@@ -395,6 +399,10 @@ int arizona_mixer_values[ARIZONA_NUM_MIXER_INPUTS] = {
 	0x27,
 	0x28,  /* AIF2RX1 */
 	0x29,
+	0x2a,
+	0x2b,
+	0x2c,
+	0x2d,
 	0x30,  /* AIF3RX1 */
 	0x31,
 	0x38,  /* SLIMRX1 */
diff --git a/sound/soc/codecs/arizona.h b/sound/soc/codecs/arizona.h
index 9e81b63..1f96672 100644
--- a/sound/soc/codecs/arizona.h
+++ b/sound/soc/codecs/arizona.h
@@ -81,7 +81,7 @@ struct arizona_priv {
 	unsigned int spk_ena_pending:1;
 };
 
-#define ARIZONA_NUM_MIXER_INPUTS 99
+#define ARIZONA_NUM_MIXER_INPUTS 103
 
 extern const unsigned int arizona_mixer_tlv[];
 extern const char *arizona_mixer_texts[ARIZONA_NUM_MIXER_INPUTS];
diff --git a/sound/soc/codecs/wm5110.c b/sound/soc/codecs/wm5110.c
index f2d1094..1a73a02 100644
--- a/sound/soc/codecs/wm5110.c
+++ b/sound/soc/codecs/wm5110.c
@@ -302,6 +302,10 @@ ARIZONA_MIXER_CONTROLS("AIF1TX8", ARIZONA_AIF1TX8MIX_INPUT_1_SOURCE),
 
 ARIZONA_MIXER_CONTROLS("AIF2TX1", ARIZONA_AIF2TX1MIX_INPUT_1_SOURCE),
 ARIZONA_MIXER_CONTROLS("AIF2TX2", ARIZONA_AIF2TX2MIX_INPUT_1_SOURCE),
+ARIZONA_MIXER_CONTROLS("AIF2TX3", ARIZONA_AIF2TX3MIX_INPUT_1_SOURCE),
+ARIZONA_MIXER_CONTROLS("AIF2TX4", ARIZONA_AIF2TX4MIX_INPUT_1_SOURCE),
+ARIZONA_MIXER_CONTROLS("AIF2TX5", ARIZONA_AIF2TX5MIX_INPUT_1_SOURCE),
+ARIZONA_MIXER_CONTROLS("AIF2TX6", ARIZONA_AIF2TX6MIX_INPUT_1_SOURCE),
 
 ARIZONA_MIXER_CONTROLS("AIF3TX1", ARIZONA_AIF3TX1MIX_INPUT_1_SOURCE),
 ARIZONA_MIXER_CONTROLS("AIF3TX2", ARIZONA_AIF3TX2MIX_INPUT_1_SOURCE),
@@ -361,6 +365,10 @@ ARIZONA_MIXER_ENUMS(AIF1TX8, ARIZONA_AIF1TX8MIX_INPUT_1_SOURCE);
 
 ARIZONA_MIXER_ENUMS(AIF2TX1, ARIZONA_AIF2TX1MIX_INPUT_1_SOURCE);
 ARIZONA_MIXER_ENUMS(AIF2TX2, ARIZONA_AIF2TX2MIX_INPUT_1_SOURCE);
+ARIZONA_MIXER_ENUMS(AIF2TX3, ARIZONA_AIF2TX3MIX_INPUT_1_SOURCE);
+ARIZONA_MIXER_ENUMS(AIF2TX4, ARIZONA_AIF2TX4MIX_INPUT_1_SOURCE);
+ARIZONA_MIXER_ENUMS(AIF2TX5, ARIZONA_AIF2TX5MIX_INPUT_1_SOURCE);
+ARIZONA_MIXER_ENUMS(AIF2TX6, ARIZONA_AIF2TX6MIX_INPUT_1_SOURCE);
 
 ARIZONA_MIXER_ENUMS(AIF3TX1, ARIZONA_AIF3TX1MIX_INPUT_1_SOURCE);
 ARIZONA_MIXER_ENUMS(AIF3TX2, ARIZONA_AIF3TX2MIX_INPUT_1_SOURCE);
@@ -561,11 +569,27 @@ SND_SOC_DAPM_AIF_OUT("AIF2TX1", NULL, 0,
 		     ARIZONA_AIF2_TX_ENABLES, ARIZONA_AIF2TX1_ENA_SHIFT, 0),
 SND_SOC_DAPM_AIF_OUT("AIF2TX2", NULL, 0,
 		     ARIZONA_AIF2_TX_ENABLES, ARIZONA_AIF2TX2_ENA_SHIFT, 0),
+SND_SOC_DAPM_AIF_OUT("AIF2TX3", NULL, 0,
+		     ARIZONA_AIF2_TX_ENABLES, ARIZONA_AIF2TX3_ENA_SHIFT, 0),
+SND_SOC_DAPM_AIF_OUT("AIF2TX4", NULL, 0,
+		     ARIZONA_AIF2_TX_ENABLES, ARIZONA_AIF2TX4_ENA_SHIFT, 0),
+SND_SOC_DAPM_AIF_OUT("AIF2TX5", NULL, 0,
+		     ARIZONA_AIF2_TX_ENABLES, ARIZONA_AIF2TX5_ENA_SHIFT, 0),
+SND_SOC_DAPM_AIF_OUT("AIF2TX6", NULL, 0,
+		     ARIZONA_AIF2_TX_ENABLES, ARIZONA_AIF2TX6_ENA_SHIFT, 0),
 
 SND_SOC_DAPM_AIF_IN("AIF2RX1", NULL, 0,
 		    ARIZONA_AIF2_RX_ENABLES, ARIZONA_AIF2RX1_ENA_SHIFT, 0),
 SND_SOC_DAPM_AIF_IN("AIF2RX2", NULL, 0,
 		    ARIZONA_AIF2_RX_ENABLES, ARIZONA_AIF2RX2_ENA_SHIFT, 0),
+SND_SOC_DAPM_AIF_IN("AIF2RX3", NULL, 0,
+		    ARIZONA_AIF2_RX_ENABLES, ARIZONA_AIF2RX3_ENA_SHIFT, 0),
+SND_SOC_DAPM_AIF_IN("AIF2RX4", NULL, 0,
+		    ARIZONA_AIF2_RX_ENABLES, ARIZONA_AIF2RX4_ENA_SHIFT, 0),
+SND_SOC_DAPM_AIF_IN("AIF2RX5", NULL, 0,
+		    ARIZONA_AIF2_RX_ENABLES, ARIZONA_AIF2RX5_ENA_SHIFT, 0),
+SND_SOC_DAPM_AIF_IN("AIF2RX6", NULL, 0,
+		    ARIZONA_AIF2_RX_ENABLES, ARIZONA_AIF2RX6_ENA_SHIFT, 0),
 
 SND_SOC_DAPM_AIF_IN("SLIMRX1", NULL, 0,
 		    ARIZONA_SLIMBUS_RX_CHANNEL_ENABLE,
@@ -703,6 +727,10 @@ ARIZONA_MIXER_WIDGETS(AIF1TX8, "AIF1TX8"),
 
 ARIZONA_MIXER_WIDGETS(AIF2TX1, "AIF2TX1"),
 ARIZONA_MIXER_WIDGETS(AIF2TX2, "AIF2TX2"),
+ARIZONA_MIXER_WIDGETS(AIF2TX3, "AIF2TX3"),
+ARIZONA_MIXER_WIDGETS(AIF2TX4, "AIF2TX4"),
+ARIZONA_MIXER_WIDGETS(AIF2TX5, "AIF2TX5"),
+ARIZONA_MIXER_WIDGETS(AIF2TX6, "AIF2TX6"),
 
 ARIZONA_MIXER_WIDGETS(AIF3TX1, "AIF3TX1"),
 ARIZONA_MIXER_WIDGETS(AIF3TX2, "AIF3TX2"),
@@ -764,6 +792,10 @@ SND_SOC_DAPM_OUTPUT("MICSUPP"),
 	{ name, "AIF1RX8", "AIF1RX8" }, \
 	{ name, "AIF2RX1", "AIF2RX1" }, \
 	{ name, "AIF2RX2", "AIF2RX2" }, \
+	{ name, "AIF2RX3", "AIF2RX3" }, \
+	{ name, "AIF2RX4", "AIF2RX4" }, \
+	{ name, "AIF2RX5", "AIF2RX5" }, \
+	{ name, "AIF2RX6", "AIF2RX6" }, \
 	{ name, "AIF3RX1", "AIF3RX1" }, \
 	{ name, "AIF3RX2", "AIF3RX2" }, \
 	{ name, "SLIMRX1", "SLIMRX1" }, \
@@ -861,9 +893,17 @@ static const struct snd_soc_dapm_route wm5110_dapm_routes[] = {
 
 	{ "AIF2 Capture", NULL, "AIF2TX1" },
 	{ "AIF2 Capture", NULL, "AIF2TX2" },
+	{ "AIF2 Capture", NULL, "AIF2TX3" },
+	{ "AIF2 Capture", NULL, "AIF2TX4" },
+	{ "AIF2 Capture", NULL, "AIF2TX5" },
+	{ "AIF2 Capture", NULL, "AIF2TX6" },
 
 	{ "AIF2RX1", NULL, "AIF2 Playback" },
 	{ "AIF2RX2", NULL, "AIF2 Playback" },
+	{ "AIF2RX3", NULL, "AIF2 Playback" },
+	{ "AIF2RX4", NULL, "AIF2 Playback" },
+	{ "AIF2RX5", NULL, "AIF2 Playback" },
+	{ "AIF2RX6", NULL, "AIF2 Playback" },
 
 	{ "AIF3 Capture", NULL, "AIF3TX1" },
 	{ "AIF3 Capture", NULL, "AIF3TX2" },
@@ -947,6 +987,10 @@ static const struct snd_soc_dapm_route wm5110_dapm_routes[] = {
 
 	ARIZONA_MIXER_ROUTES("AIF2TX1", "AIF2TX1"),
 	ARIZONA_MIXER_ROUTES("AIF2TX2", "AIF2TX2"),
+	ARIZONA_MIXER_ROUTES("AIF2TX3", "AIF2TX3"),
+	ARIZONA_MIXER_ROUTES("AIF2TX4", "AIF2TX4"),
+	ARIZONA_MIXER_ROUTES("AIF2TX5", "AIF2TX5"),
+	ARIZONA_MIXER_ROUTES("AIF2TX6", "AIF2TX6"),
 
 	ARIZONA_MIXER_ROUTES("AIF3TX1", "AIF3TX1"),
 	ARIZONA_MIXER_ROUTES("AIF3TX2", "AIF3TX2"),
@@ -1079,14 +1123,14 @@ static struct snd_soc_dai_driver wm5110_dai[] = {
 		.playback = {
 			.stream_name = "AIF2 Playback",
 			.channels_min = 1,
-			.channels_max = 2,
+			.channels_max = 6,
 			.rates = WM5110_RATES,
 			.formats = WM5110_FORMATS,
 		},
 		.capture = {
 			 .stream_name = "AIF2 Capture",
 			 .channels_min = 1,
-			 .channels_max = 2,
+			 .channels_max = 6,
 			 .rates = WM5110_RATES,
 			 .formats = WM5110_FORMATS,
 		 },
-- 
1.7.2.5


