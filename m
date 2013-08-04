Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab3HDJ4B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 05:56:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:28923 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040Ab3HDJ4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 05:56:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,811,1367996400"; 
   d="scan'208";a="381610164"
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Subject: [PATCH net] busy_poll: cleanup do-nothing placeholders
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Sun, 04 Aug 2013 12:55:48 +0300
Message-ID: <20130804095548.30006.8133.stgit@ladj378.jer.intel.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When renaming ll_poll to busy poll, I introduced a typo
in the name of the do-nothing placeholder for sk_busy_loop
and called it sk_busy_poll.
This broke compile when busy poll was not configured.
Cong Wang submitted a patch to fixed that.
This patch removes the now redundant, misspelled placeholder.

Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
---

 include/net/busy_poll.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
index f18b919..8e2dfc1 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -162,11 +162,6 @@ static inline bool sk_can_busy_loop(struct sock *sk)
 	return false;
 }
 
-static inline bool sk_busy_poll(struct sock *sk, int nonblock)
-{
-	return false;
-}
-
 static inline void skb_mark_napi_id(struct sk_buff *skb,
 				    struct napi_struct *napi)
 {

