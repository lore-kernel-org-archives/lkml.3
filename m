Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601Ab3AOWoJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:44:09 -0500
Received: from mail.kernel.org ([198.145.19.201]:43765 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932760Ab3AOWfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:35:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 195/221] libceph: register request before unregister linger
Date: Tue, 15 Jan 2013 10:52:02 -0800
Message-Id: <20130115185012.110307602@linuxfoundation.org>
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

(cherry picked from commit c89ce05e0c5a01a256100ac6a6019f276bdd1ca6)

In kick_requests(), we need to register the request before we
unregister the linger request.  Otherwise the unregister will
reset the request's osd pointer to NULL.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osd_client.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1366,8 +1366,8 @@ static void kick_requests(struct ceph_os
 
 		dout("kicking lingering %p tid %llu osd%d\n", req, req->r_tid,
 		     req->r_osd ? req->r_osd->o_osd : -1);
-		__unregister_linger_request(osdc, req);
 		__register_request(osdc, req);
+		__unregister_linger_request(osdc, req);
 	}
 	mutex_unlock(&osdc->request_mutex);
 


