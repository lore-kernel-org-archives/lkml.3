Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab3LSLzc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:55:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44391 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab3LSLzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:55:24 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Florent Fourcot <florent.fourcot@enst-bretagne.fr>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 008/208] ipv6: protect for_each_sk_fl_rcu in mem_check with rcu_read_lock_bh
Date: Thu, 19 Dec 2013 11:51:46 +0000
Message-Id: <1387454106-19326-9-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

commit f8c31c8f80dd882f7eb49276989a4078d33d67a7 upstream.

Fixes a suspicious rcu derference warning.

Cc: Florent Fourcot <florent.fourcot@enst-bretagne.fr>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv6/ip6_flowlabel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/ip6_flowlabel.c b/net/ipv6/ip6_flowlabel.c
index 46e8843..f0ccdb7 100644
--- a/net/ipv6/ip6_flowlabel.c
+++ b/net/ipv6/ip6_flowlabel.c
@@ -453,8 +453,10 @@ static int mem_check(struct sock *sk)
 	if (room > FL_MAX_SIZE - FL_MAX_PER_SOCK)
 		return 0;
 
+	rcu_read_lock_bh();
 	for_each_sk_fl_rcu(np, sfl)
 		count++;
+	rcu_read_unlock_bh();
 
 	if (room <= 0 ||
 	    ((count >= FL_MAX_PER_SOCK ||
-- 
1.8.3.2

