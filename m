Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932966Ab3GKOmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:42:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43055 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932886Ab3GKO0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:26:18 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Phil Oester <kernel@linuxace.com>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 49/98] netfilter: xt_TCPMSS: Fix missing fragmentation handling
Date: Thu, 11 Jul 2013 15:24:19 +0100
Message-Id: <1373552708-15235-50-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Oester <kernel@linuxace.com>

commit b396966c4688522863572927cb30aa874b3ec504 upstream.

Similar to commit bc6bcb59 ("netfilter: xt_TCPOPTSTRIP: fix
possible mangling beyond packet boundary"), add safe fragment
handling to xt_TCPMSS.

Signed-off-by: Phil Oester <kernel@linuxace.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/netfilter/xt_TCPMSS.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 4960b66..a77d786 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -55,6 +55,10 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 	u16 newmss;
 	u8 *opt;
 
+	/* This is a fragment, no TCP header is available */
+	if (par->fragoff != 0)
+		return XT_CONTINUE;
+
 	if (!skb_make_writable(skb, skb->len))
 		return -1;
 
-- 
1.8.1.2

