Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbaICDPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 23:15:47 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:51552
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754192AbaICDPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 23:15:13 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <perex@perex.cz>, <lgirdwood@gmail.com>,
        <tiwai@suse.de>, <moinejf@free.fr>, <andrew@lunn.ch>,
        <kuninori.morimoto.gx@renesas.com>, <jsarha@ti.com>,
        <devicetree@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv3 2/3] ASoC: simple-card: Adjust the comments of simple card.
Date: Wed, 3 Sep 2014 10:23:40 +0800
Message-ID: <1409711021-19277-3-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1409711021-19277-1-git-send-email-Li.Xiubo@freescale.com>
References: <1409711021-19277-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199003)(36756003)(80022001)(229853001)(69596002)(50986999)(76176999)(95666004)(84676001)(90102001)(81156004)(44976005)(107046002)(31966008)(64706001)(81342001)(77156001)(104166001)(106466001)(81542001)(97736001)(85306004)(21056001)(88136002)(50226001)(102836001)(85852003)(89996001)(74662001)(26826002)(68736004)(83322001)(19580405001)(104016003)(105606002)(92566001)(74502001)(19580395003)(62966002)(87286001)(87936001)(4396001)(99396002)(93916002)(76482001)(48376002)(20776003)(46102001)(83072002)(92726001)(86362001)(47776003)(50466002)(79102001)(77982001)(6806004)(2201001)(1121002)(21314002)(921003);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR0301MB0609;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 032334F434
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/generic/simple-card.c | 48 ++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index 1597a24..07f7fb6 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -120,7 +120,7 @@ asoc_simple_card_sub_parse_of(struct device_node *np,
 	int ret;
 
 	/*
-	 * get node via "sound-dai = <&phandle port>"
+	 * Get node via "sound-dai = <&phandle port>"
 	 * it will be used as xxx_of_node on soc_bind_dai_link()
 	 */
 	node = of_parse_phandle(np, "sound-dai", 0);
@@ -128,19 +128,19 @@ asoc_simple_card_sub_parse_of(struct device_node *np,
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
 
 	/*
-	 * dai->sysclk come from
-	 *  "clocks = <&xxx>" (if system has common clock)
+	 * Parse dai->sysclk come from "clocks = <&xxx>"
+	 * (if system has common clock)
 	 *  or "system-clock-frequency = <xxx>"
 	 *  or device's module clock.
 	 */
@@ -232,9 +232,11 @@ static int asoc_simple_card_dai_link_of(struct device_node *node,
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
@@ -263,10 +265,10 @@ static int asoc_simple_card_dai_link_of(struct device_node *node,
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
@@ -288,11 +290,11 @@ static int asoc_simple_card_dai_link_of(struct device_node *node,
 		dai_props->codec_dai.sysclk);
 
 	/*
-	 * soc_bind_dai_link() will check cpu name
-	 * after of_node matching if dai_link has cpu_dai_name.
-	 * but, it will never match if name was created by fmt_single_name()
-	 * remove cpu_dai_name to escape name matching.
-	 * see
+	 * In soc_bind_dai_link() will check cpu name after
+	 * of_node matching if dai_link has cpu_dai_name.
+	 * but, it will never match if name was created by
+	 * fmt_single_name() remove cpu_dai_name to escape
+	 * name matching. Please see:
 	 *	fmt_single_name()
 	 *	fmt_multiple_name()
 	 */
@@ -320,10 +322,10 @@ static int asoc_simple_card_parse_of(struct device_node *node,
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
@@ -378,7 +380,7 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 	return 0;
 }
 
-/* update the reference count of the devices nodes at end of probe */
+/* Decrease the reference count of the device nodes */
 static int asoc_simple_card_unref(struct platform_device *pdev)
 {
 	struct snd_soc_card *card = platform_get_drvdata(pdev);
@@ -407,29 +409,27 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
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
1.8.4

