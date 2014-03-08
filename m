Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbaCHBW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:22:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46513 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212AbaCHBHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:07:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jianpeng Ma <majianpeng@gmail.com>, Sage Weil <sage@inktank.com>,
        Ben Hutchings <ben@decadent.org.uk>, Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 3.4 57/99] libceph: unregister request in __map_request failed and nofail == false
Date: Fri,  7 Mar 2014 17:07:53 -0800
Message-Id: <20140308010613.433172153@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140308010611.468206150@linuxfoundation.org>
References: <20140308010611.468206150@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: majianpeng <majianpeng@gmail.com>

commit 73d9f7eef3d98c3920e144797cc1894c6b005a1e upstream.

For nofail == false request, if __map_request failed, the caller does
cleanup work, like releasing the relative pages.  It doesn't make any sense
to retry this request.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
Reviewed-by: Sage Weil <sage@inktank.com>
[bwh: Backported to 3.2: adjust indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ceph/osd_client.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1721,6 +1721,8 @@ int ceph_osdc_start_request(struct ceph_
 				dout("osdc_start_request failed map, "
 				     " will retry %lld\n", req->r_tid);
 				rc = 0;
+			} else {
+				__unregister_request(osdc, req);
 			}
 			goto out_unlock;
 		}


