Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab3KRSu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:50:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57572 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab3KRSlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:41:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Patrick McHardy <kaber@trash.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        William Roberts <bill.c.roberts@gmail.com>
Subject: [PATCH 3.4 07/12] netfilter: nf_ct_sip: dont drop packets with offsets pointing outside the packet
Date: Mon, 18 Nov 2013 10:41:40 -0800
Message-Id: <20131118184132.288810521@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131118184130.257996039@linuxfoundation.org>
References: <20131118184130.257996039@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_conntrack_sip.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1468,7 +1468,7 @@ static int sip_help_tcp(struct sk_buff *
 
 		msglen = origlen = end - dptr;
 		if (msglen > datalen)
-			return NF_DROP;
+			return NF_ACCEPT;
 
 		ret = process_sip_msg(skb, ct, dataoff, &dptr, &msglen);
 		if (ret != NF_ACCEPT)


