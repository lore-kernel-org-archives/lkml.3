Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934453AbaKSVdD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:33:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57776 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934434AbaKSVc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:32:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Devesh Sharma <devesh.sharma@emulex.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [PATCH 3.17 119/141] IB/core: Clear AH attr variable to prevent garbage data
Date: Wed, 19 Nov 2014 12:52:22 -0800
Message-Id: <20141119205154.584731774@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Devesh Sharma <devesh.sharma@emulex.com>

commit 8b0f93d9490653a7b9fc91f3570089132faed1c0 upstream.

During create-ah from userspace, uverbs is sending garbage data in
attr.dmac and attr.vlan_id.  This patch sets attr.dmac and
attr.vlan_id to zero.

Fixes: dd5f03beb4f7 ("IB/core: Ethernet L2 attributes in verbs/cm structures")
Signed-off-by: Devesh Sharma <devesh.sharma@emulex.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/uverbs_cmd.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2518,6 +2518,8 @@ ssize_t ib_uverbs_create_ah(struct ib_uv
 	attr.grh.sgid_index    = cmd.attr.grh.sgid_index;
 	attr.grh.hop_limit     = cmd.attr.grh.hop_limit;
 	attr.grh.traffic_class = cmd.attr.grh.traffic_class;
+	attr.vlan_id           = 0;
+	memset(&attr.dmac, 0, sizeof(attr.dmac));
 	memcpy(attr.grh.dgid.raw, cmd.attr.grh.dgid, 16);
 
 	ah = ib_create_ah(pd, &attr);


