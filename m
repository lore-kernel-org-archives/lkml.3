Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbaJ0SMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 14:12:05 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:18791 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752960AbaJ0SMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:12:02 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArYUAAiKTlRXQ3zJ/2dsb2JhbABcgw6BLLlDCwUBdJo9BAKBHhcBfYRfI4EaN4hFAbxrjlwshjSKVB2ENQWdYYxqiUSBRwGCMTwvgksBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] ipv6: replace min/casting by min_t
Date: Mon, 27 Oct 2014 19:11:56 +0100
Message-Id: <1414433516-29278-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/ipv6/addrconf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 725c763..50b95b2 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2315,8 +2315,8 @@ ok:
 			else
 				stored_lft = 0;
 			if (!update_lft && !create && stored_lft) {
-				const u32 minimum_lft = min(
-					stored_lft, (u32)MIN_VALID_LIFETIME);
+				const u32 minimum_lft = min_t(u32,
+					stored_lft, MIN_VALID_LIFETIME);
 				valid_lft = max(valid_lft, minimum_lft);
 
 				/* RFC4862 Section 5.5.3e:
-- 
1.9.1

