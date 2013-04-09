Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936750Ab3DIHex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 03:34:53 -0400
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:35728
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936486Ab3DIHew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 03:34:52 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
From: <Yuantian.Tang@freescale.com>
To: <grant.likely@secretlab.ca>
CC: <rob.herring@calxeda.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        Tang Yuantian <yuantian.tang@freescale.com>,
        Tang Yuantian <Yuantian.Tang@freescale.com>
Subject: [PATCH] of: remove the unnecessary of_node_put for of_parse_phandle_with_args()
Date: Tue, 9 Apr 2013 14:56:09 +0800
Message-ID: <1365490569-32455-1-git-send-email-Yuantian.Tang@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tang Yuantian <yuantian.tang@freescale.com>

As the function itself says it is caller's responsibility to call the
of_node_put().  So, remove it on success to keep the reference count
correct.

Signed-off-by: Tang Yuantian <Yuantian.Tang@freescale.com>
---
 drivers/of/base.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 321d3ef..e8b4c28 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1168,9 +1168,6 @@ static int __of_parse_phandle_with_args(const struct device_node *np,
 					out_args->args[i] = be32_to_cpup(list++);
 			}
 
-			/* Found it! return success */
-			if (node)
-				of_node_put(node);
 			return 0;
 		}
 
-- 
1.8.0


