Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933786Ab3AOWxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:53:10 -0500
Received: from mail.kernel.org ([198.145.19.201]:47182 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932834Ab3AOWxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:53:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 143/171] libceph: report connection fault with warning
Date: Tue, 15 Jan 2013 14:45:08 -0800
Message-Id: <20130115224323.664869538@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Alex Elder <elder@inktank.com>

When a connection's socket disconnects, or if there's a protocol
error of some kind on the connection, a fault is signaled and
the connection is reset (closed and reopened, basically).  We
currently get an error message on the log whenever this occurs.

A ceph connection will attempt to reestablish a socket connection
repeatedly if a fault occurs.  This means that these error messages
will get repeatedly added to the log, which is undesirable.

Change the error message to be a warning, so they don't get
logged by default.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
(cherry picked from commit 28362986f8743124b3a0fda20a8ed3e80309cce1)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -2365,7 +2365,7 @@ fault:
 static void ceph_fault(struct ceph_connection *con)
 	__releases(con->mutex)
 {
-	pr_err("%s%lld %s %s\n", ENTITY_NAME(con->peer_name),
+	pr_warning("%s%lld %s %s\n", ENTITY_NAME(con->peer_name),
 	       ceph_pr_addr(&con->peer_addr.in_addr), con->error_msg);
 	dout("fault %p state %lu to peer %s\n",
 	     con, con->state, ceph_pr_addr(&con->peer_addr.in_addr));


