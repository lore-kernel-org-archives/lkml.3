Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbaJGUQo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 16:16:44 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:44423 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754103AbaJGUQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 16:16:42 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuMSABNJNFRXQB1d/2dsb2JhbABfgw6BK7hrCwUBc5pjBAKBEhcBe4QxLyOBGjeIQgGzP48ThiCJQGQdhDUFnUKMWIkwg2U7L4EGgUQBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] af_unix: remove NULL assignment on static
Date: Tue,  7 Oct 2014 22:16:36 +0200
Message-Id: <1412712996-4672-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

static values are automatically initialized to NULL

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
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

