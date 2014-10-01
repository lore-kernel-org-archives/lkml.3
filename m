Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253AbaJAQ2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 12:28:01 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:14385 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751445AbaJAQ17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 12:27:59 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsYSAG4qLFRbsmCr/2dsb2JhbABggw6BLLY3BQFyAZpTBAKBDRcBe4RgI4EaN4hCAa57j2+GFYktDVcdhDUFnTOMSYkqg2U7L4EGAR+BJAEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] tcp: add __init to tcp_init_mem
Date: Wed,  1 Oct 2014 18:27:50 +0200
Message-Id: <1412180870-7599-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tcp_init_mem is only called by __init tcp_init.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/ipv4/tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index cf5e508..5c17034 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3172,7 +3172,7 @@ static int __init set_thash_entries(char *str)
 }
 __setup("thash_entries=", set_thash_entries);
 
-static void tcp_init_mem(void)
+static void __init tcp_init_mem(void)
 {
 	unsigned long limit = nr_free_buffer_pages() / 8;
 	limit = max(limit, 128UL);
-- 
1.9.3

