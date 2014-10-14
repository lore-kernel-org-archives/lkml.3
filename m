Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbaJNRBE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 13:01:04 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:16627 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755093AbaJNRBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 13:01:02 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AskNAB9WPVRbtAZ+/2dsb2JhbABbgw6BK7h2BQFzmhaBFhcBfYRfI4EaN4hCAbdZj0WGIIolHYQ1BZ1LjFyJNYFHAYIxOy+CSgEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Joe Perches <joe@perches.com>, Fabian Frederick <fabf@skynet.be>,
        Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH V2 1/2 net-next] caif_usb: remove redundant memory message
Date: Tue, 14 Oct 2014 19:00:55 +0200
Message-Id: <1413306055-8281-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let MM subsystem display out of memory messages.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
V2: add second patch with memset fix

 net/caif/caif_usb.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/caif/caif_usb.c b/net/caif/caif_usb.c
index ba02db0..0e487b0 100644
--- a/net/caif/caif_usb.c
+++ b/net/caif/caif_usb.c
@@ -87,10 +87,9 @@ static struct cflayer *cfusbl_create(int phyid, u8 ethaddr[ETH_ALEN],
 {
 	struct cfusbl *this = kmalloc(sizeof(struct cfusbl), GFP_ATOMIC);
 
-	if (!this) {
-		pr_warn("Out of memory\n");
+	if (!this)
 		return NULL;
-	}
+
 	caif_assert(offsetof(struct cfusbl, layer) == 0);
 
 	memset(this, 0, sizeof(struct cflayer));
-- 
1.9.3

