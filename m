Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbaJGVCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 17:02:22 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:35700 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751125AbaJGVCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 17:02:21 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am0UAGlTNFRXQB1d/2dsb2JhbABfgw6BK7hxAQEBAQEBBQFzmX8EAoESFwF7hDEvI4EaN4hCAbNRjxOGIIlAZB2ENQWdQoxYiTCDZTsvgQaBRAEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
Subject: [PATCH V2 net-next] af_unix: remove 0 assignment on static
Date: Tue,  7 Oct 2014 23:02:15 +0200
Message-Id: <1412715735-6757-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

static values are automatically initialized to 0

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
V2: replace NULL by 0 in description

 net/unix/garbage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/unix/garbage.c b/net/unix/garbage.c
index 9bc73f8..99f7012 100644
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -258,7 +258,7 @@ static void inc_inflight_move_tail(struct unix_sock *u)
 		list_move_tail(&u->link, &gc_candidates);
 }
 
-static bool gc_in_progress = false;
+static bool gc_in_progress;
 #define UNIX_INFLIGHT_TRIGGER_GC 16000
 
 void wait_for_unix_gc(void)
-- 
1.9.3

