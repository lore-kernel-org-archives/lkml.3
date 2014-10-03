Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291AbaJCW2q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:28:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47570 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515AbaJCW0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:26:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Julian Anastasov <ja@ssi.bg>, Hans Schillstrom <hans@schillstrom.com>,
        Simon Horman <horms@verge.net.au>
Subject: [PATCH 3.10 128/143] ipvs: avoid netns exit crash on ip_vs_conn_drop_conntrack
Date: Fri,  3 Oct 2014 14:35:23 -0700
Message-Id: <20141003213318.326413934@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003213314.470709810@linuxfoundation.org>
References: <20141003213314.470709810@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/ipvs/ip_vs_conn.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -797,7 +797,6 @@ static void ip_vs_conn_expire(unsigned l
 			ip_vs_control_del(cp);
 
 		if (cp->flags & IP_VS_CONN_F_NFCT) {
-			ip_vs_conn_drop_conntrack(cp);
 			/* Do not access conntracks during subsys cleanup
 			 * because nf_conntrack_find_get can not be used after
 			 * conntrack cleanup for the net.


