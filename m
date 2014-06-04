Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbaFEAKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:10:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40316 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbaFDXWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.14 176/228] Target/iser: Fix wrong connection requests list addition
Date: Wed,  4 Jun 2014 16:23:25 -0700
Message-Id: <20140604232353.671382934@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Grimberg <sagig@mellanox.com>

commit 9fe63c88b1d59f1ce054d6948ccd3096496ecedb upstream.

Should be adding list_add_tail($new, $head) and not
the other way around.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/isert/ib_isert.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -582,7 +582,7 @@ isert_connect_request(struct rdma_cm_id
 		goto out_conn_dev;
 
 	mutex_lock(&isert_np->np_accept_mutex);
-	list_add_tail(&isert_np->np_accept_list, &isert_conn->conn_accept_node);
+	list_add_tail(&isert_conn->conn_accept_node, &isert_np->np_accept_list);
 	mutex_unlock(&isert_np->np_accept_mutex);
 
 	pr_debug("isert_connect_request() waking up np_accept_wq: %p\n", np);


