Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168AbaAFWlw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:41:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48468 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933111AbaAFWlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:41:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>, Sage Weil <sage@inktank.com>
Subject: [PATCH 3.10 108/129] libceph: create_singlethread_workqueue() doesnt return ERR_PTRs
Date: Mon,  6 Jan 2014 14:38:57 -0800
Message-Id: <20140106223902.688633581@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit dbcae088fa660086bde6e10d63bb3c9264832d85 upstream.

create_singlethread_workqueue() returns NULL on error, and it doesn't
return ERR_PTRs.

I tweaked the error handling a little to be consistent with earlier in
the function.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ceph/osd_client.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -2257,12 +2257,10 @@ int ceph_osdc_init(struct ceph_osd_clien
 	if (err < 0)
 		goto out_msgpool;
 
+	err = -ENOMEM;
 	osdc->notify_wq = create_singlethread_workqueue("ceph-watch-notify");
-	if (IS_ERR(osdc->notify_wq)) {
-		err = PTR_ERR(osdc->notify_wq);
-		osdc->notify_wq = NULL;
+	if (!osdc->notify_wq)
 		goto out_msgpool;
-	}
 	return 0;
 
 out_msgpool:


