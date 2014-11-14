Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161566AbaKNSiu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 13:38:50 -0500
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:32246 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754655AbaKNSit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 13:38:49 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4SANhLZlRXQzQ2/2dsb2JhbABbgw6BLrlDBQF1mg8EAoEdFwEBAQEBfYQwLyOBGjeIRQHBcZBRhj6KZB2ENQWeTJZ6gUcBgjU8MIJLAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] net: dsa: replace count*size kzalloc by kcalloc
Date: Fri, 14 Nov 2014 19:38:23 +0100
Message-Id: <1415990303-28764-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kcalloc manages count*sizeof overflow.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/dsa/dsa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 4648f12..e84b656 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -606,8 +606,8 @@ static int dsa_of_probe(struct platform_device *pdev)
 	if (pd->nr_chips > DSA_MAX_SWITCHES)
 		pd->nr_chips = DSA_MAX_SWITCHES;
 
-	pd->chip = kzalloc(pd->nr_chips * sizeof(struct dsa_chip_data),
-			GFP_KERNEL);
+	pd->chip = kcalloc(pd->nr_chips, sizeof(struct dsa_chip_data),
+			   GFP_KERNEL);
 	if (!pd->chip) {
 		ret = -ENOMEM;
 		goto out_free;
-- 
1.9.3

