Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910Ab3BLUov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:44:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54036 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758752Ab3BLUl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:41:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ian Campbell <ian.campbell@citrix.com>,
        Jan Beulich <JBeulich@suse.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 30/36] netback: correct netbk_tx_err to handle wrap around.
Date: Tue, 12 Feb 2013 12:41:24 -0800
Message-Id: <20130212203900.813634541@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203857.305594226@linuxfoundation.org>
References: <20130212203857.305594226@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Ian Campbell <Ian.Campbell@citrix.com>

[ Upstream commit b9149729ebdcfce63f853aa54a404c6a8f6ebbf3 ]

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Acked-by: Jan Beulich <JBeulich@suse.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netback/netback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -852,7 +852,7 @@ static void netbk_tx_err(struct xenvif *
 
 	do {
 		make_tx_response(vif, txp, XEN_NETIF_RSP_ERROR);
-		if (cons >= end)
+		if (cons == end)
 			break;
 		txp = RING_GET_REQUEST(&vif->tx, cons++);
 	} while (1);


