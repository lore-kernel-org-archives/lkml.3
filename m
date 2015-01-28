Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760555AbbA1Bch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:32:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41191 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760107AbbA1B2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:28:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3.18 51/61] netfilter: nfnetlink: validate nfnetlink header from batch
Date: Tue, 27 Jan 2015 17:27:03 -0800
Message-Id: <20150128012642.503000865@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012636.936333725@linuxfoundation.org>
References: <20150128012636.936333725@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 9ea2aa8b7dba9e99544c4187cc298face254569f upstream.

Make sure there is enough room for the nfnetlink header in the
netlink messages that are part of the batch. There is a similar
check in netlink_rcv_skb().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nfnetlink.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -321,7 +321,8 @@ replay:
 		nlh = nlmsg_hdr(skb);
 		err = 0;
 
-		if (nlh->nlmsg_len < NLMSG_HDRLEN) {
+		if (nlmsg_len(nlh) < sizeof(struct nfgenmsg) ||
+		    skb->len < nlh->nlmsg_len) {
 			err = -EINVAL;
 			goto ack;
 		}


