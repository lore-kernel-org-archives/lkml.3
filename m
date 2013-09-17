Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab3IQVqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 17:46:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003Ab3IQVqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 17:46:13 -0400
Date: Tue, 17 Sep 2013 17:45:54 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Subject: infiniband: remove self-assignment from nes_query_qp()
Message-ID: <20130917214554.GA357@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Roland Dreier <roland@kernel.org>,
	Sean Hefty <sean.hefty@intel.com>,
	Hal Rosenstock <hal.rosenstock@gmail.com>,
	linux-rdma@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assigning a value to itself is pointless.

Spotted with coverity, no hardware to test.

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 5b53ca5..8308e36 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -2834,7 +2834,7 @@ static int nes_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	init_attr->qp_context = nesqp->ibqp.qp_context;
 	init_attr->send_cq = nesqp->ibqp.send_cq;
 	init_attr->recv_cq = nesqp->ibqp.recv_cq;
-	init_attr->srq = nesqp->ibqp.srq = nesqp->ibqp.srq;
+	init_attr->srq = nesqp->ibqp.srq;
 	init_attr->cap = attr->cap;
 
 	return 0;
