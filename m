Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab3EJOoH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:44:07 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57046 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754559Ab3EJOUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:20:43 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Theodore Ts'o" <tytso@mit.edu>,
        "Jiri Benc" <jbenc@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Michael Riesch" <michael.riesch@omicron.at>,
        "Mark Rustad" <mark.d.rustad@intel.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.913664514@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [093/118] rtnetlink: Call nlmsg_parse() with correct header  length
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Riesch <michael.riesch@omicron.at>

[ Upstream commit 88c5b5ce5cb57af6ca2a7cf4d5715fa320448ff9 ]

Signed-off-by: Michael Riesch <michael.riesch@omicron.at>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Benc <jbenc@redhat.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org
Acked-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/core/rtnetlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1064,7 +1064,7 @@ static int rtnl_dump_ifinfo(struct sk_bu
 	rcu_read_lock();
 	cb->seq = net->dev_base_seq;
 
-	if (nlmsg_parse(cb->nlh, sizeof(struct rtgenmsg), tb, IFLA_MAX,
+	if (nlmsg_parse(cb->nlh, sizeof(struct ifinfomsg), tb, IFLA_MAX,
 			ifla_policy) >= 0) {
 
 		if (tb[IFLA_EXT_MASK])
@@ -1907,7 +1907,7 @@ static u16 rtnl_calcit(struct sk_buff *s
 	u32 ext_filter_mask = 0;
 	u16 min_ifinfo_dump_size = 0;
 
-	if (nlmsg_parse(nlh, sizeof(struct rtgenmsg), tb, IFLA_MAX,
+	if (nlmsg_parse(nlh, sizeof(struct ifinfomsg), tb, IFLA_MAX,
 			ifla_policy) >= 0) {
 		if (tb[IFLA_EXT_MASK])
 			ext_filter_mask = nla_get_u32(tb[IFLA_EXT_MASK]);

