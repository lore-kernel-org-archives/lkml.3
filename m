Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbaIAC05 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 22:26:57 -0400
Received: from mail-bn1blp0182.outbound.protection.outlook.com ([207.46.163.182]:8232
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751000AbaIAC0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 22:26:55 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>, <perex@perex.cz>,
        <tiwai@suse.de>, <moinejf@free.fr>, <kuninori.morimoto.gx@renesas.com>,
        <jsarha@ti.com>, <alsa-devel@alsa-project.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv2 1/2] ASoC: simple-card: Fix bug of forgetting decrement DT node's refcount
Date: Mon, 1 Sep 2014 09:35:26 +0800
Message-ID: <1409535327-11449-2-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1409535327-11449-1-git-send-email-Li.Xiubo@freescale.com>
References: <1409535327-11449-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199003)(97736001)(2201001)(77982001)(68736004)(95666004)(87936001)(4396001)(105606002)(74662001)(106466001)(104166001)(86362001)(92566001)(89996001)(92726001)(44976005)(83322001)(93916002)(69596002)(26826002)(48376002)(19580405001)(81156004)(6806004)(85852003)(83072002)(88136002)(77156001)(79102001)(19580395003)(74502001)(90102001)(102836001)(50226001)(84676001)(229853001)(64706001)(50986999)(36756003)(85306004)(81542001)(46102001)(107046002)(20776003)(31966008)(50466002)(76482001)(21056001)(87286001)(62966002)(76176999)(99396002)(104016003)(81342001)(47776003)(80022001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR0301MB0624;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
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

We shouldn't forget decrement the last DT node when the
for_each_child_of_node() has finished searching.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/generic/simple-card.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index fd8b045..9e170fe 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -360,6 +360,7 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 			}
 			i++;
 		}
+		of_node_put(np);
 	} else {
 		ret = asoc_simple_card_dai_link_of(node, dev,
 						   dai_link, dai_props, true);
-- 
1.8.4

