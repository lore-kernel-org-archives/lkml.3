Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415Ab3D2TEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:04:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32868 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760025Ab3D2TDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:03:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 28/30] netrom: fix invalid use of sizeof in nr_recvmsg()
Date: Mon, 29 Apr 2013 12:02:52 -0700
Message-Id: <20130429184358.467908038@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130429184355.299556377@linuxfoundation.org>
References: <20130429184355.299556377@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

[ Upstream commit c802d759623acbd6e1ee9fbdabae89159a513913 ]

sizeof() when applied to a pointer typed expression gives the size of the
pointer, not that of the pointed data.
Introduced by commit 3ce5ef(netrom: fix info leak via msg_name in nr_recvmsg)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netrom/af_netrom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -1178,7 +1178,7 @@ static int nr_recvmsg(struct kiocb *iocb
 	}
 
 	if (sax != NULL) {
-		memset(sax, 0, sizeof(sax));
+		memset(sax, 0, sizeof(*sax));
 		sax->sax25_family = AF_NETROM;
 		skb_copy_from_linear_data_offset(skb, 7, sax->sax25_call.ax25_call,
 			      AX25_ADDR_LEN);


