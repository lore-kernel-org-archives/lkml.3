Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab3EJOrJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:47:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56943 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754285Ab3EJOUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:20:10 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Wei Yongjun" <yongjun_wei@trendmicro.com.cn>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.541594674@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [109/118] netrom: fix invalid use of sizeof in nr_recvmsg()
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

[ Upstream commit c802d759623acbd6e1ee9fbdabae89159a513913 ]

sizeof() when applied to a pointer typed expression gives the size of the
pointer, not that of the pointed data.
Introduced by commit 3ce5ef(netrom: fix info leak via msg_name in nr_recvmsg)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/netrom/af_netrom.c | 2 +-
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

