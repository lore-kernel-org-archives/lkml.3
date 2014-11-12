Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520AbaKLC3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:29:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60839 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965503AbaKLBsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:48:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Yehuda Sadeh <yehuda@inktank.com>, Sage Weil <sage@inktank.com>,
        ceph-devel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Ilya Dryomov <idryomov@redhat.com>
Subject: [PATCH 3.14 194/203] rbd: Fix error recovery in rbd_obj_read_sync()
Date: Wed, 12 Nov 2014 10:17:44 +0900
Message-Id: <20141112011551.597465119@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit a8d4205623ae965e36c68629db306ca0695a2771 upstream.

When we fail to allocate page vector in rbd_obj_read_sync() we just
basically ignore the problem and continue which will result in an oops
later. Fix the problem by returning proper error.

CC: Yehuda Sadeh <yehuda@inktank.com>
CC: Sage Weil <sage@inktank.com>
CC: ceph-devel@vger.kernel.org
Coverity-id: 1226882
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Ilya Dryomov <idryomov@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/rbd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -3217,7 +3217,7 @@ static int rbd_obj_read_sync(struct rbd_
 	page_count = (u32) calc_pages_for(offset, length);
 	pages = ceph_alloc_page_vector(page_count, GFP_KERNEL);
 	if (IS_ERR(pages))
-		ret = PTR_ERR(pages);
+		return PTR_ERR(pages);
 
 	ret = -ENOMEM;
 	obj_request = rbd_obj_request_create(object_name, offset, length,


