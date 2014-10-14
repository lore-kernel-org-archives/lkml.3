Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbaJNRBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 13:01:22 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:62248 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755381AbaJNRBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 13:01:19 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AskNAKhVPVRbtAZ+/2dsb2JhbABbgw6BK7h2BQFzmhaBFhcBfYQwLyOBGjeIQgG3Vo9FhiCJQWQdhDUFnUuMXIk1gUcBgjE7L4EGgUQBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Joe Perches <joe@perches.com>, Fabian Frederick <fabf@skynet.be>,
        Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH V2 2/2 net-next] caif_usb: use target structure member in memset
Date: Tue, 14 Oct 2014 19:01:14 +0200
Message-Id: <1413306074-8401-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

parent cfusbl was used instead of first structure member 'layer'

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/caif/caif_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/caif/caif_usb.c b/net/caif/caif_usb.c
index 0e487b0..5cd44f0 100644
--- a/net/caif/caif_usb.c
+++ b/net/caif/caif_usb.c
@@ -92,7 +92,7 @@ static struct cflayer *cfusbl_create(int phyid, u8 ethaddr[ETH_ALEN],
 
 	caif_assert(offsetof(struct cfusbl, layer) == 0);
 
-	memset(this, 0, sizeof(struct cflayer));
+	memset(&this->layer, 0, sizeof(this->layer));
 	this->layer.receive = cfusbl_receive;
 	this->layer.transmit = cfusbl_transmit;
 	this->layer.ctrlcmd = cfusbl_ctrlcmd;
-- 
1.9.3

