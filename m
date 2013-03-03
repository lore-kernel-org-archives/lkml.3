Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab3CDAeZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 19:34:25 -0500
Received: from mail-ye0-f181.google.com ([209.85.213.181]:34819 "EHLO
	mail-ye0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646Ab3CDAeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 19:34:24 -0500
X-Greylist: delayed 2311 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Mar 2013 19:34:24 EST
From: Claudiu Ghioc <claudiughioc@gmail.com>
To: davem@davemloft.net
Cc: edumazet@google.com, dborkman@redhat.com, jpirko@redhat.com,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Claudiu Ghioc <claudiu.ghioc@gmail.com>
Subject: [PATCH] filter: fix sparse warning for bpf_internal_load_pointer_neg_helper
Date: Mon,  4 Mar 2013 01:30:04 +0200
Message-Id: <1362353404-27034-1-git-send-email-claudiu.ghioc@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed the following sparse warning:
*   net/core/filter.c:48:6: warning: symbol
    'bpf_internal_load_pointer_neg_helper' was
    not declared. Should it be static?

Signed-off-by: Claudiu Ghioc <claudiu.ghioc@gmail.com>
---
 net/core/filter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 2e20b55..f6c907c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -45,7 +45,7 @@
  *
  * Exported for the bpf jit load helper.
  */
-void *bpf_internal_load_pointer_neg_helper(const struct sk_buff *skb, int k, unsigned int size)
+static void *bpf_internal_load_pointer_neg_helper(const struct sk_buff *skb, int k, unsigned int size)
 {
 	u8 *ptr = NULL;
 
-- 
1.7.10.4

