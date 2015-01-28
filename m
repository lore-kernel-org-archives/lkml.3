Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933558AbbA1Bk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:40:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41746 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933390AbbA1Bik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:38:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3.14 33/77] netfilter: nfnetlink: validate nfnetlink header from batch
Date: Tue, 27 Jan 2015 17:27:11 -0800
Message-Id: <20150128012746.963002474@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012745.971137091@linuxfoundation.org>
References: <20150128012745.971137091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -265,7 +265,8 @@ replay:
 		nlh = nlmsg_hdr(skb);
 		err = 0;
 
-		if (nlh->nlmsg_len < NLMSG_HDRLEN) {
+		if (nlmsg_len(nlh) < sizeof(struct nfgenmsg) ||
+		    skb->len < nlh->nlmsg_len) {
 			err = -EINVAL;
 			goto ack;
 		}


