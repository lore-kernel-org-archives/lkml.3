Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934581Ab3GQW4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:56:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56772 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934522Ab3GQW4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:56:34 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Phil Oester <kernel@linuxace.com>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 081/145] netfilter: xt_TCPMSS: Fix missing fragmentation handling
Date: Wed, 17 Jul 2013 15:46:53 -0700
Message-Id: <1374101277-7915-82-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

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

