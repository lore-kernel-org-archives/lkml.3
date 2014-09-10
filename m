Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbaIJCAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 22:00:21 -0400
Received: from mail-by2on0127.outbound.protection.outlook.com ([207.46.100.127]:51776
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750998AbaIJCAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 22:00:19 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>, <perex@perex.cz>,
        <tiwai@suse.de>, <moinejf@free.fr>, <kuninori.morimoto.gx@renesas.com>,
        <jsarha@ti.com>, <alsa-devel@alsa-project.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv4] ASoC: simple-card: Adjust the comments of simple card.
Date: Wed, 10 Sep 2014 09:59:55 +0800
Message-ID: <1410314395-10050-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019019)(6009001)(189002)(199003)(83072002)(74662001)(87936001)(79102001)(81542001)(85852003)(26826002)(87286001)(20776003)(99396002)(68736004)(89996001)(48376002)(77982001)(64706001)(31966008)(47776003)(97736003)(36756003)(4396001)(74502001)(50466002)(50226001)(81342001)(90102001)(62966002)(83322001)(88136002)(85306004)(21056001)(104166001)(80022001)(102836001)(106466001)(46102001)(107046002)(76482001)(92726001)(92566001)(105606002)(86362001)(104016003)(95666004)(84676001)(6806004)(19580395003)(44976005)(77156001)(19580405001)(50986999)(229853001)(93916002)(2201001)(21314002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0619;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 033054F29A
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---

Changes in V4:
- To apply against current code. 



 sound/soc/generic/simple-card.c | 48 ++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index 4053152..f20feb4 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -122,7 +122,7 @@ asoc_simple_card_sub_parse_of(struct device_node *np,
 	int ret;
 
 	/*
-	 * get node via "sound-dai = <&phandle port>"
+	 * Get node via "sound-dai = <&phandle port>"
 	 * it will be used as xxx_of_node on soc_bind_dai_link()
 	 */
 	ret = of_parse_phandle_with_args(np, "sound-dai",
@@ -135,19 +135,19 @@ asoc_simple_card_sub_parse_of(struct device_node *np,
 	if (args_count)
 		*args_count = args.args_count;
 
-	/* get dai->name */
+	/* Get dai->name */
 	ret = snd_soc_of_get_dai_name(np, name);
 	if (ret < 0)
 		return ret;
 
-	/* parse TDM slot */
+	/* Parse TDM slot */
 	ret = snd_soc_of_parse_tdm_slot(np, &dai->slots, &dai->slot_width);
 	if (ret)
 		return ret;
 
 	/*
-	 * dai->sysclk come from
-	 *  "clocks = <&xxx>" (if system has common clock)
+	 * Parse dai->sysclk come from "clocks = <&xxx>"
+	 * (if system has common clock)
 	 *  or "system-clock-frequency = <xxx>"
 	 *  or device's module clock.
 	 */
@@ -240,9 +240,11 @@ static int asoc_simple_card_dai_link_of(struct device_node *node,
 		goto dai_link_of_err;
 
 	if (strlen(prefix) && !bitclkmaster && !framemaster) {
-		/* No dai-link level and master setting was not found from
-		   sound node level, revert back to legacy DT parsing and
-		   take the settings from codec node. */
+		/*
+		 * No DAI link level and master setting was found
+		 * from sound node level, revert back to legacy DT
+		 * parsing and take the settings from codec node.
+		 */
 		dev_dbg(dev, "%s: Revert to legacy daifmt parsing\n",
 			__func__);
 		dai_props->cpu_dai.fmt = dai_props->codec_dai.fmt =
@@ -271,10 +273,10 @@ static int asoc_simple_card_dai_link_of(struct device_node *node,
 		goto dai_link_of_err;
 	}
 
-	/* simple-card assumes platform == cpu */
+	/* Simple Card assumes platform == cpu */
 	dai_link->platform_of_node = dai_link->cpu_of_node;
 
-	/* Link name is created from CPU/CODEC dai name */
+	/* DAI link name is created from CPU/CODEC dai name */
 	name = devm_kzalloc(dev,
 			    strlen(dai_link->cpu_dai_name)   +
 			    strlen(dai_link->codec_dai_name) + 2,
@@ -296,11 +298,11 @@ static int asoc_simple_card_dai_link_of(struct device_node *node,
 		dai_props->codec_dai.sysclk);
 
 	/*
-	 * soc_bind_dai_link() will check cpu name
-	 * after of_node matching if dai_link has cpu_dai_name.
-	 * but, it will never match if name was created by fmt_single_name()
-	 * remove cpu_dai_name if cpu_args was 0.
-	 * see
+	 * In soc_bind_dai_link() will check cpu name after
+	 * of_node matching if dai_link has cpu_dai_name.
+	 * but, it will never match if name was created by
+	 * fmt_single_name() remove cpu_dai_name if cpu_args
+	 * was 0. See:
 	 *	fmt_single_name()
 	 *	fmt_multiple_name()
 	 */
@@ -329,10 +331,10 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 	if (!node)
 		return -EINVAL;
 
-	/* parsing the card name from DT */
+	/* Parse the card name from DT */
 	snd_soc_of_parse_card_name(&priv->snd_card, "simple-audio-card,name");
 
-	/* off-codec widgets */
+	/* The off-codec widgets */
 	if (of_property_read_bool(node, "simple-audio-card,widgets")) {
 		ret = snd_soc_of_parse_audio_simple_widgets(&priv->snd_card,
 					"simple-audio-card,widgets");
@@ -387,7 +389,7 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 	return 0;
 }
 
-/* update the reference count of the devices nodes at end of probe */
+/* Decrease the reference count of the device nodes */
 static int asoc_simple_card_unref(struct platform_device *pdev)
 {
 	struct snd_soc_card *card = platform_get_drvdata(pdev);
@@ -416,29 +418,27 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	int num_links, ret;
 
-	/* get the number of DAI links */
+	/* Get the number of DAI links */
 	if (np && of_get_child_by_name(np, "simple-audio-card,dai-link"))
 		num_links = of_get_child_count(np);
 	else
 		num_links = 1;
 
-	/* allocate the private data and the DAI link array */
+	/* Allocate the private data and the DAI link array */
 	priv = devm_kzalloc(dev,
 			sizeof(*priv) + sizeof(*dai_link) * num_links,
 			GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
-	/*
-	 * init snd_soc_card
-	 */
+	/* Init snd_soc_card */
 	priv->snd_card.owner = THIS_MODULE;
 	priv->snd_card.dev = dev;
 	dai_link = priv->dai_link;
 	priv->snd_card.dai_link = dai_link;
 	priv->snd_card.num_links = num_links;
 
-	/* get room for the other properties */
+	/* Get room for the other properties */
 	priv->dai_props = devm_kzalloc(dev,
 			sizeof(*priv->dai_props) * num_links,
 			GFP_KERNEL);
-- 
2.1.0.27.g96db324

