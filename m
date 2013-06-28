Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab3F1TRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:17:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41571 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab3F1Sw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:52:29 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 007/105] netrom: fix invalid use of sizeof in nr_recvmsg()
Date: Fri, 28 Jun 2013 11:50:29 -0700
Message-Id: <1372445527-24414-8-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

commit c802d759623acbd6e1ee9fbdabae89159a513913 upstream.

sizeof() when applied to a pointer typed expression gives the size of the
pointer, not that of the pointed data.
Introduced by commit 3ce5ef(netrom: fix info leak via msg_name in nr_recvmsg)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/netrom/af_netrom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index 14c106b..f334fbd 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -1177,7 +1177,7 @@ static int nr_recvmsg(struct kiocb *iocb, struct socket *sock,
 	}
 
 	if (sax != NULL) {
-		memset(sax, 0, sizeof(sax));
+		memset(sax, 0, sizeof(*sax));
 		sax->sax25_family = AF_NETROM;
 		skb_copy_from_linear_data_offset(skb, 7, sax->sax25_call.ax25_call,
 			      AX25_ADDR_LEN);
-- 
1.8.1.2

