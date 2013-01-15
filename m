Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758636Ab3AOWkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:40:00 -0500
Received: from mail.kernel.org ([198.145.19.201]:44027 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932895Ab3AOWg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:36:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 212/221] rbd: remove linger unconditionally
Date: Tue, 15 Jan 2013 10:52:19 -0800
Message-Id: <20130115185013.359211739@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Alex Elder <elder@inktank.com>

(cherry picked from commit 61c74035626beb25a39b0273ccf7d75510bc36a1)

In __unregister_linger_request(), the request is being removed
from the osd client's req_linger list only when the request
has a non-null osd pointer.  It should be done whether or not
the request currently has an osd.

This is most likely a non-issue because I believe the request
will always have an osd when this function is called.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osd_client.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -907,8 +907,8 @@ static void __unregister_linger_request(
 					struct ceph_osd_request *req)
 {
 	dout("__unregister_linger_request %p\n", req);
+	list_del_init(&req->r_linger_item);
 	if (req->r_osd) {
-		list_del_init(&req->r_linger_item);
 		list_del_init(&req->r_linger_osd);
 
 		if (list_empty(&req->r_osd->o_requests) &&


