Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab3IYAYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:24:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39834 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756803Ab3IYAVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:21:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jianpeng Ma <majianpeng@gmail.com>, Sage Weil <sage@inktank.com>
Subject: [ 106/117] libceph: unregister request in __map_request failed and nofail == false
Date: Tue, 24 Sep 2013 17:19:32 -0700
Message-Id: <20130925001752.501386312@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: majianpeng <majianpeng@gmail.com>

commit 73d9f7eef3d98c3920e144797cc1894c6b005a1e upstream.

For nofail == false request, if __map_request failed, the caller does
cleanup work, like releasing the relative pages.  It doesn't make any sense
to retry this request.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ceph/osd_client.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -2129,6 +2129,8 @@ int ceph_osdc_start_request(struct ceph_
 			dout("osdc_start_request failed map, "
 				" will retry %lld\n", req->r_tid);
 			rc = 0;
+		} else {
+			__unregister_request(osdc, req);
 		}
 		goto out_unlock;
 	}


