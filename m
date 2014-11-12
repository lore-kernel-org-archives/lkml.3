Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161300AbaKLB5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:57:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33214 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161262AbaKLB5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:57:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ilya Dryomov <idryomov@redhat.com>, Micha Krause <micha@krausam.de>,
        Sage Weil <sage@redhat.com>
Subject: [PATCH 3.10 123/123] libceph: ceph-msgr workqueue needs a resque worker
Date: Wed, 12 Nov 2014 10:18:09 +0900
Message-Id: <20141112011724.538184854@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011718.985171261@linuxfoundation.org>
References: <20141112011718.985171261@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Dryomov <idryomov@redhat.com>

commit f9865f06f7f18c6661c88d0511f05c48612319cc upstream.

Commit f363e45fd118 ("net/ceph: make ceph_msgr_wq non-reentrant")
effectively removed WQ_MEM_RECLAIM flag from ceph_msgr_wq.  This is
wrong - libceph is very much a memory reclaim path, so restore it.

Signed-off-by: Ilya Dryomov <idryomov@redhat.com>
Tested-by: Micha Krause <micha@krausam.de>
Reviewed-by: Sage Weil <sage@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ceph/messenger.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -290,7 +290,8 @@ int ceph_msgr_init(void)
 	if (ceph_msgr_slab_init())
 		return -ENOMEM;
 
-	ceph_msgr_wq = alloc_workqueue("ceph-msgr", WQ_NON_REENTRANT, 0);
+	ceph_msgr_wq = alloc_workqueue("ceph-msgr",
+				       WQ_NON_REENTRANT | WQ_MEM_RECLAIM, 0);
 	if (ceph_msgr_wq)
 		return 0;
 


