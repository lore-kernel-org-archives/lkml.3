Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843Ab3BLUns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:43:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54052 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758804Ab3BLUl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:41:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sarveshwar Bandi <sarveshwar.bandi@emulex.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 33/36] bridge: Pull ip header into skb->data before looking into ip header.
Date: Tue, 12 Feb 2013 12:41:27 -0800
Message-Id: <20130212203901.148569211@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203857.305594226@linuxfoundation.org>
References: <20130212203857.305594226@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Sarveshwar Bandi <sarveshwar.bandi@emulex.com>

[ Upstream commit 6caab7b0544e83e6c160b5e80f5a4a7dd69545c7 ]

If lower layer driver leaves the ip header in the skb fragment, it needs to
be first pulled into skb->data before inspecting ip header length or ip version
number.

Signed-off-by: Sarveshwar Bandi <sarveshwar.bandi@emulex.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_netfilter.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -254,6 +254,9 @@ static int br_parse_ip_options(struct sk
 	struct net_device *dev = skb->dev;
 	u32 len;
 
+	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
+		goto inhdr_error;
+
 	iph = ip_hdr(skb);
 	opt = &(IPCB(skb)->opt);
 


