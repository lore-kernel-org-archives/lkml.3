Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab3EIW5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:57:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46044 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757632Ab3EIWcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:32:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Patrick McHardy <kaber@trash.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ 20/73] netfilter: nf_ct_sip: dont drop packets with offsets pointing outside the packet
Date: Thu,  9 May 2013 15:31:43 -0700
Message-Id: <20130509222800.156365776@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222757.917088509@linuxfoundation.org>
References: <20130509222757.917088509@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_conntrack_sip.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1547,7 +1547,7 @@ static int sip_help_tcp(struct sk_buff *
 
 		msglen = origlen = end - dptr;
 		if (msglen > datalen)
-			return NF_DROP;
+			return NF_ACCEPT;
 
 		ret = process_sip_msg(skb, ct, protoff, dataoff,
 				      &dptr, &msglen);


