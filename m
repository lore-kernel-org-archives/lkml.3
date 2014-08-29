Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbaH2JYd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 05:24:33 -0400
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:7419
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752074AbaH2JYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 05:24:13 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <moinejf@free.fr>,
        <kuninori.morimoto.gx@renesas.com>, <jsarha@ti.com>,
        <alsa-devel@alsa-project.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH 1/2] ASoC: simple-card: Fix bug of forgetting decrement DT node's refcount
Date: Fri, 29 Aug 2014 17:19:32 +0800
Message-ID: <1409303973-1084-2-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.5
In-Reply-To: <1409303973-1084-1-git-send-email-Li.Xiubo@freescale.com>
References: <1409303973-1084-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199003)(85852003)(93916002)(97736001)(575784001)(50226001)(77982001)(76176999)(4396001)(31966008)(104166001)(76482001)(79102001)(74662001)(92726001)(95666004)(92566001)(2201001)(36756003)(87936001)(81542001)(83072002)(89996001)(86362001)(107046002)(21056001)(19580395003)(229853001)(74502001)(88136002)(83322001)(50466002)(6806004)(80022001)(47776003)(19580405001)(64706001)(90102001)(99396002)(26826002)(20776003)(84676001)(85306004)(81342001)(106466001)(62966002)(105606002)(77156001)(48376002)(44976005)(50986999)(69596002)(68736004)(102836001)(46102001)(81156004)(87286001)(104016003);DIR:OUT;SFP:;SCL:1;SRVR:CY1PR0301MB0620;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0318501FAE
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We shouldn't forget decrement the last DT node when the
of_get_next_child() has finished searching.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/generic/simple-card.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index 21b0ea2..9675bf7 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -344,6 +344,7 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 				return ret;
 			}
 		}
+		of_node_put(np);
 	} else {
 		ret = simple_card_dai_link_of(node, dev, dai_link, dai_props,
 					      true);
-- 
1.8.5

