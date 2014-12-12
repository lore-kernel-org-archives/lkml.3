Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966575AbaLLGzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:55:46 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51772 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758767AbaLLGQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:54 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Chuck Lever" <chuck.lever@oracle.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.731325699@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 140/164] sunrpc: fix byte-swapping of displayed XID
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit 71efecb3f58c8c7a15f6135e3f9b39d1e3d3fae3 upstream.

xprt_lookup_rqst() and bc_send_request() display a byte-swapped XID,
but receive_cb_reply() does not.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sunrpc/svcsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1062,7 +1062,7 @@ static int receive_cb_reply(struct svc_s
 			"%s: Got unrecognized reply: "
 			"calldir 0x%x xpt_bc_xprt %p xid %08x\n",
 			__func__, ntohl(calldir),
-			bc_xprt, xid);
+			bc_xprt, ntohl(xid));
 		return -EAGAIN;
 	}
 

