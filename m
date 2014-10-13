Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbaJMUVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 16:21:54 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:30980 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751342AbaJMUVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 16:21:53 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApwSAAkzPFRbtA5F/2dsb2JhbABbgw6BK7d1BQFzmhAEAoEgFwF9hDAvI4EaN4hCAbYujw2GIIolHYQ1BZ1LlhGBRwGCMTsvgkoBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] caif: replace kmalloc/memset 0 by kzalloc
Date: Mon, 13 Oct 2014 22:21:46 +0200
Message-Id: <1413231706-9301-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also add blank line after declaration

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/caif/cfmuxl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/caif/cfmuxl.c b/net/caif/cfmuxl.c
index 8c5d638..510aa5a 100644
--- a/net/caif/cfmuxl.c
+++ b/net/caif/cfmuxl.c
@@ -47,10 +47,10 @@ static struct cflayer *get_up(struct cfmuxl *muxl, u16 id);
 
 struct cflayer *cfmuxl_create(void)
 {
-	struct cfmuxl *this = kmalloc(sizeof(struct cfmuxl), GFP_ATOMIC);
+	struct cfmuxl *this = kzalloc(sizeof(struct cfmuxl), GFP_ATOMIC);
+
 	if (!this)
 		return NULL;
-	memset(this, 0, sizeof(*this));
 	this->layer.receive = cfmuxl_receive;
 	this->layer.transmit = cfmuxl_transmit;
 	this->layer.ctrlcmd = cfmuxl_ctrlcmd;
-- 
1.9.3

