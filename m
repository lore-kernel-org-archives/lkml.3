Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbaKAXBP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 19:01:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60071 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751460AbaKAWj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:26 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Simon Horman" <horms@verge.net.au>,
        "Hans Schillstrom" <hans@schillstrom.com>,
        "Julian Anastasov" <ja@ssi.bg>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.442457000@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 101/102] ipvs: avoid netns exit crash on
 ip_vs_conn_drop_conntrack
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Anastasov <ja@ssi.bg>

commit 2627b7e15c5064ddd5e578e4efd948d48d531a3f upstream.

commit 8f4e0a18682d91 ("IPVS netns exit causes crash in conntrack")
added second ip_vs_conn_drop_conntrack call instead of just adding
the needed check. As result, the first call still can cause
crash on netns exit. Remove it.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Hans Schillstrom <hans@schillstrom.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/netfilter/ipvs/ip_vs_conn.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -777,7 +777,6 @@ static void ip_vs_conn_expire(unsigned l
 			ip_vs_control_del(cp);
 
 		if (cp->flags & IP_VS_CONN_F_NFCT) {
-			ip_vs_conn_drop_conntrack(cp);
 			/* Do not access conntracks during subsys cleanup
 			 * because nf_conntrack_find_get can not be used after
 			 * conntrack cleanup for the net.

