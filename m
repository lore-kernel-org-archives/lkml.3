Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbaIAFVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 01:21:32 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:47708
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752433AbaIAFV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 01:21:29 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>, <perex@perex.cz>,
        <tiwai@suse.de>, <kuninori.morimoto.gx@renesas.com>, <moinejf@free.fr>,
        <andrew@lunn.ch>, <jsarha@ti.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-sh@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <shawn.guo@freescale.com>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv1 2/7] ASoC: simple-card: Adjust the comments of simple card.
Date: Mon, 1 Sep 2014 12:29:36 +0800
Message-ID: <1409545781-20530-3-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1409545781-20530-1-git-send-email-Li.Xiubo@freescale.com>
References: <1409545781-20530-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199003)(104016003)(85306004)(81342001)(68736004)(19580395003)(26826002)(102836001)(76482001)(36756003)(31966008)(83322001)(88136002)(104166001)(81542001)(44976005)(80022001)(229853001)(4396001)(64706001)(47776003)(20776003)(50226001)(87286001)(107046002)(95666004)(62966002)(99396002)(85852003)(48376002)(77156001)(50986999)(90102001)(74502001)(92566001)(106466001)(19580405001)(50466002)(6806004)(21056001)(77982001)(89996001)(79102001)(69596002)(2201001)(84676001)(105606002)(87936001)(74662001)(83072002)(46102001)(86362001)(93916002)(92726001)(97736001)(81156004)(76176999)(921003)(1121002)(21314002)(83996005)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB340;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03218BFD9F
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/generic/simple-card.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index d45c8dd..e9d5a69 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -131,7 +131,7 @@ asoc_simple_card_sub_parse_of(struct device_node *np,
 	*daifmt &= ~(SND_SOC_DAIFMT_MASTER_MASK | SND_SOC_DAIFMT_FORMAT_MASK);
 
 	/*
-	 * get node via "sound-dai = <&phandle port>"
+	 * Get node via "sound-dai = <&phandle port>"
 	 * it will be used as xxx_of_node on soc_bind_dai_link()
 	 */
 	node = of_parse_phandle(np, "sound-dai", 0);
@@ -139,12 +139,12 @@ asoc_simple_card_sub_parse_of(struct device_node *np,
 		return -ENODEV;
 	*p_node = node;
 
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
@@ -189,7 +189,7 @@ static int asoc_simple_card_dai_link_of(struct device_node *node,
 	daifmt &= (SND_SOC_DAIFMT_MASTER_MASK | SND_SOC_DAIFMT_FORMAT_MASK);
 	dai_props->cpu_dai.fmt = dai_props->codec_dai.fmt = daifmt;
 
-	/* Parse CPU DAI */
+	/* Parse CPU DAI node */
 	np = of_get_child_by_name(node, "cpu");
 	if (!np) {
 		ret = -EINVAL;
@@ -207,7 +207,7 @@ static int asoc_simple_card_dai_link_of(struct device_node *node,
 	dai_props->cpu_dai.fmt |= daifmt;
 	of_node_put(np);
 
-	/* Parse CODEC DAI */
+	/* Parse CODEC DAI node */
 	np = of_get_child_by_name(node, "codec");
 	if (!np) {
 		ret = -EINVAL;
@@ -229,10 +229,10 @@ static int asoc_simple_card_dai_link_of(struct device_node *node,
 
 	dai_props->codec_dai.fmt |= daifmt;
 
-	/* simple-card assumes platform == cpu */
+	/* Simple Card assumes platform == cpu */
 	dai_link->platform_of_node = dai_link->cpu_of_node;
 
-	/* Link name is created from CPU/CODEC dai name */
+	/* DAI Link's name is created from CPU/CODEC dai name */
 	name = devm_kzalloc(dev,
 			    strlen(dai_link->cpu_dai_name)   +
 			    strlen(dai_link->codec_dai_name) + 2,
@@ -254,7 +254,7 @@ static int asoc_simple_card_dai_link_of(struct device_node *node,
 		dai_props->codec_dai.sysclk);
 
 	/*
-	 * soc_bind_dai_link() will check cpu name
+	 * asoc_bind_dai_link() will check cpu name
 	 * after of_node matching if dai_link has cpu_dai_name.
 	 * but, it will never match if name was created by fmt_single_name()
 	 * remove cpu_dai_name to escape name matching.
@@ -296,10 +296,10 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 	u32 val;
 	int ret, i = 0;
 
-	/* parsing the card name from DT */
+	/* Parse the card name from DT */
 	snd_soc_of_parse_card_name(&priv->snd_card, "simple-audio-card,name");
 
-	/* off-codec widgets */
+	/* Parse off-codec widgets */
 	if (of_property_read_bool(node, "simple-audio-card,widgets")) {
 		ret = snd_soc_of_parse_audio_simple_widgets(&priv->snd_card,
 					"simple-audio-card,widgets");
@@ -352,13 +352,13 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	int num_links, ret;
 
-	/* get the number of DAI links */
+	/* Get the number of DAI links */
 	if (np && of_get_child_by_name(np, "simple-audio-card,dai-link"))
 		num_links = of_get_child_count(np);
 	else
 		return -EINVAL;
 
-	/* allocate the private data and the DAI link array */
+	/* Allocate the private data and the DAI link array */
 	priv = devm_kzalloc(dev,
 			sizeof(*priv) + sizeof(*dai_link) * num_links,
 			GFP_KERNEL);
@@ -366,7 +366,7 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	/*
-	 * init snd_soc_card
+	 * Init snd_soc_card
 	 */
 	priv->snd_card.owner = THIS_MODULE;
 	priv->snd_card.dev = dev;
@@ -374,7 +374,7 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 	priv->snd_card.dai_link = dai_link;
 	priv->snd_card.num_links = num_links;
 
-	/* get room for the other properties */
+	/* Get room for the other properties */
 	priv->dai_props = devm_kzalloc(dev,
 			sizeof(*priv->dai_props) * num_links,
 			GFP_KERNEL);
-- 
1.8.4

