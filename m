Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933029Ab3EGNl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:41:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42329 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933013Ab3EGNlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:41:23 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michael Riesch <michael.riesch@omicron.at>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Benc <jbenc@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 050/118] rtnetlink: Call nlmsg_parse() with correct header length
Date: Tue,  7 May 2013 14:38:16 +0100
Message-Id: <1367933964-1564-51-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Riesch <michael.riesch@omicron.at>

commit 88c5b5ce5cb57af6ca2a7cf4d5715fa320448ff9 upstream.

Signed-off-by: Michael Riesch <michael.riesch@omicron.at>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Benc <jbenc@redhat.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org
Acked-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/core/rtnetlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 844ccc6..ef7f0ab 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1073,7 +1073,7 @@ static int rtnl_dump_ifinfo(struct sk_buff *skb, struct netlink_callback *cb)
 	rcu_read_lock();
 	cb->seq = net->dev_base_seq;
 
-	if (nlmsg_parse(cb->nlh, sizeof(struct rtgenmsg), tb, IFLA_MAX,
+	if (nlmsg_parse(cb->nlh, sizeof(struct ifinfomsg), tb, IFLA_MAX,
 			ifla_policy) >= 0) {
 
 		if (tb[IFLA_EXT_MASK])
@@ -1916,7 +1916,7 @@ static u16 rtnl_calcit(struct sk_buff *skb, struct nlmsghdr *nlh)
 	u32 ext_filter_mask = 0;
 	u16 min_ifinfo_dump_size = 0;
 
-	if (nlmsg_parse(nlh, sizeof(struct rtgenmsg), tb, IFLA_MAX,
+	if (nlmsg_parse(nlh, sizeof(struct ifinfomsg), tb, IFLA_MAX,
 			ifla_policy) >= 0) {
 		if (tb[IFLA_EXT_MASK])
 			ext_filter_mask = nla_get_u32(tb[IFLA_EXT_MASK]);
-- 
1.8.1.2

