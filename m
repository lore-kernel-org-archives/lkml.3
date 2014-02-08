Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaBHTzL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 14:55:11 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:46453 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaBHTzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 14:55:10 -0500
Date: Sun, 9 Feb 2014 01:25:05 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Rashika Kheria <rashika.kheria@gmail.com>, netdev@vger.kernel.org,
        josh@joshtriplett.org
Subject: [PATCH 05/13] net: Mark function as static in core/filter.c
Message-ID: <b4fedb3d1984f8e1878015e12b7214c00a6588bb.1391888654.git.rashika.kheria@gmail.com>
References: <6f029c895035908595957fb16ab445c82793c77d.1391888654.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6f029c895035908595957fb16ab445c82793c77d.1391888654.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function as static in core/filter.c because it is not used outside
this file.

This eliminates the following warning in core/filter.c:
net/core/filter.c:48:7: warning: no previous prototype for ‘bpf_internal_load_pointer_neg_helper’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 net/core/filter.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index ad30d62..a022dad 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -44,7 +44,8 @@
  *
  * Exported for the bpf jit load helper.
  */
-void *bpf_internal_load_pointer_neg_helper(const struct sk_buff *skb, int k, unsigned int size)
+static void *bpf_internal_load_pointer_neg_helper(const struct sk_buff *skb,
+						  int k, unsigned int size)
 {
 	u8 *ptr = NULL;
 
-- 
1.7.9.5

