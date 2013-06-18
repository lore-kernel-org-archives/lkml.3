Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353Ab3FRLpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:45:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56162 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413Ab3FRLo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:44:56 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Elder <elder@inktank.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 60/93] libceph: register request before unregister linger
Date: Tue, 18 Jun 2013 12:43:08 +0100
Message-Id: <1371555821-12820-61-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

commit c89ce05e0c5a01a256100ac6a6019f276bdd1ca6 upstream.

In kick_requests(), we need to register the request before we
unregister the linger request.  Otherwise the unregister will
reset the request's osd pointer to NULL.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ceph/osd_client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 79592c4..60ae916 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1358,8 +1358,8 @@ static void kick_requests(struct ceph_osd_client *osdc, int force_resend)
 
 		dout("kicking lingering %p tid %llu osd%d\n", req, req->r_tid,
 		     req->r_osd ? req->r_osd->o_osd : -1);
-		__unregister_linger_request(osdc, req);
 		__register_request(osdc, req);
+		__unregister_linger_request(osdc, req);
 	}
 	mutex_unlock(&osdc->request_mutex);
 
-- 
1.8.1.2

