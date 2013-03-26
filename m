Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919Ab3CZR4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:56:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15135 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996Ab3CZRgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:10 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=G7z0rm6ygKEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=_2IuK4ZghpYA:10 a=tHz9FfFoAAAA:8 a=iox4zFpeAAAA:8 a=J1Y8HTJGAAAA:8 a=AqJ00D3vZjHJZuhkqGEA:9 a=6O0IECtVFhoA:10 a=n9GBPR9yFnkA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173604.708259621@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ian Campbell <ian.campbell@citrix.com>, Jan Beulich <JBeulich@suse.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 30/86] netback: correct netbk_tx_err to handle wrap around.
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0030-netback-correct-netbk_tx_err-to-handle-wrap-around.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Ian Campbell <Ian.Campbell@citrix.com>

[ Upstream commit b9149729ebdcfce63f853aa54a404c6a8f6ebbf3 ]

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Acked-by: Jan Beulich <JBeulich@suse.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/xen-netback/netback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 7e18de2..4da6af5 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -851,7 +851,7 @@ static void netbk_tx_err(struct xenvif *vif,
 
 	do {
 		make_tx_response(vif, txp, XEN_NETIF_RSP_ERROR);
-		if (cons >= end)
+		if (cons == end)
 			break;
 		txp = RING_GET_REQUEST(&vif->tx, cons++);
 	} while (1);
-- 
1.7.10.4


