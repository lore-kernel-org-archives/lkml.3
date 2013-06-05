Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933281Ab3FEVmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:42:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38077 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933127Ab3FEVgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:36:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [ 114/127] IB/iser: Return error to upper layers on EAGAIN registration failures
Date: Wed,  5 Jun 2013 14:34:41 -0700
Message-Id: <20130605213230.940017472@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Or Gerlitz <ogerlitz@mellanox.com>

commit 450d1e40d597dd71843457c73d372c4b4f2a83eb upstream.

Commit 819a087316a6 ("IB/iser: Avoid error prints on EAGAIN
registration failures") not only eliminated the error print on that
case, but rather also modified the code such that it doesn't return
any error to upper layers.  As a result a wrong mapping was used.  Fix
this to correctly return the error in that case.

Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/iser/iser_memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -416,8 +416,9 @@ int iser_reg_rdma_mem(struct iscsi_iser_
 			for (i=0 ; i<ib_conn->page_vec->length ; i++)
 				iser_err("page_vec[%d] = 0x%llx\n", i,
 					 (unsigned long long) ib_conn->page_vec->pages[i]);
-			return err;
 		}
+		if (err)
+			return err;
 	}
 	return 0;
 }


