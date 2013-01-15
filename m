Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933932Ab3AOXTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:19:54 -0500
Received: from mail.kernel.org ([198.145.19.201]:47359 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933873Ab3AOWxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:53:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 159/171] rbd: remove linger unconditionally
Date: Tue, 15 Jan 2013 14:45:24 -0800
Message-Id: <20130115224324.804808292@linuxfoundation.org>
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

In __unregister_linger_request(), the request is being removed
from the osd client's req_linger list only when the request
has a non-null osd pointer.  It should be done whether or not
the request currently has an osd.

This is most likely a non-issue because I believe the request
will always have an osd when this function is called.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
(cherry picked from commit 61c74035626beb25a39b0273ccf7d75510bc36a1)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osd_client.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -905,8 +905,8 @@ static void __unregister_linger_request(
 					struct ceph_osd_request *req)
 {
 	dout("__unregister_linger_request %p\n", req);
+	list_del_init(&req->r_linger_item);
 	if (req->r_osd) {
-		list_del_init(&req->r_linger_item);
 		list_del_init(&req->r_linger_osd);
 
 		if (list_empty(&req->r_osd->o_requests) &&


