Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024Ab3KYNJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:09:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57322 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887Ab3KYNJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:09:07 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Patrick McHardy <kaber@trash.net>, Pablo Neira Ayuso <pablo@netfilter.org>,
        William Roberts <bill.c.roberts@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 69/78] netfilter: nf_ct_sip: don't drop packets with offsets pointing outside the packet
Date: Mon, 25 Nov 2013 13:06:56 +0000
Message-Id: <1385384825-21681-70-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
References: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.26 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrick McHardy <kaber@trash.net>

commit 3a7b21eaf4fb3c971bdb47a98f570550ddfe4471 upstream.

Some Cisco phones create huge messages that are spread over multiple packets.
After calculating the offset of the SIP body, it is validated to be within
the packet and the packet is dropped otherwise. This breaks operation of
these phones. Since connection tracking is supposed to be passive, just let
those packets pass unmodified and untracked.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: William Roberts <bill.c.roberts@gmail.com>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/netfilter/nf_conntrack_sip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 93faf6a..4a8c55b 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1468,7 +1468,7 @@ static int sip_help_tcp(struct sk_buff *skb, unsigned int protoff,
 
 		msglen = origlen = end - dptr;
 		if (msglen > datalen)
-			return NF_DROP;
+			return NF_ACCEPT;
 
 		ret = process_sip_msg(skb, ct, dataoff, &dptr, &msglen);
 		if (ret != NF_ACCEPT)
-- 
1.8.3.2

