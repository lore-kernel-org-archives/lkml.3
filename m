Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab3J2SKO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:10:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59646 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505Ab3J2SKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:10:10 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Pirko <jiri@resnulli.us>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 30/81] ipv6/exthdrs: accept tlv which includes only padding
Date: Tue, 29 Oct 2013 11:03:51 -0700
Message-Id: <1383069882-11437-31-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Pirko <jiri@resnulli.us>

[ Upstream commit 8112b1fe071be01a28a774ed55909e6f4b29712d ]

In rfc4942 and rfc2460 I cannot find anything which would implicate to
drop packets which have only padding in tlv.

Current behaviour breaks TAHI Test v6LC.1.2.6.

Problem was intruduced in:
9b905fe6843 "ipv6/exthdrs: strict Pad1 and PadN check"

Signed-off-by: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv6/exthdrs.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 07a7d65..8d67900 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -162,12 +162,6 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs, struct sk_buff *skb)
 		off += optlen;
 		len -= optlen;
 	}
-	/* This case will not be caught by above check since its padding
-	 * length is smaller than 7:
-	 * 1 byte NH + 1 byte Length + 6 bytes Padding
-	 */
-	if ((padlen == 6) && ((off - skb_network_header_len(skb)) == 8))
-		goto bad;
 
 	if (len == 0)
 		return true;
-- 
1.8.1.2

