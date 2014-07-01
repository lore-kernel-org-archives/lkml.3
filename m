Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731AbaGATt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 15:49:26 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:46389 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758637AbaGATtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 15:49:22 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArsHAAYQs1NbsGsk/2dsb2JhbABagw2sYwUBbplbgQ8XdYQxLyOBGjeIRgGzC5V1hW+JMB2ELQWaZotFiD6DRDs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Roland Dreier <roland@kernel.org>,
        Sean Hefty <sean.hefty@intel.com>, linux-rdma@vger.kernel.org
Subject: [PATCH 1/1] IB/mlx4: use ARRAY_SIZE instead of sizeof/sizeof[0]
Date: Tue,  1 Jul 2014 21:49:17 +0200
Message-Id: <1404244157-24367-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use macro definition

Cc: Roland Dreier <roland@kernel.org>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: linux-rdma@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/infiniband/hw/mlx4/main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 0f7027e..0dc807f 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -910,8 +910,7 @@ static int __mlx4_ib_default_rules_match(struct ib_qp *qp,
 	const struct default_rules *pdefault_rules = default_table;
 	u8 link_layer = rdma_port_get_link_layer(qp->device, flow_attr->port);
 
-	for (i = 0; i < sizeof(default_table)/sizeof(default_table[0]); i++,
-	     pdefault_rules++) {
+	for (i = 0; i < ARRAY_SIZE(default_table); i++, pdefault_rules++) {
 		__u32 field_types[IB_FLOW_SPEC_SUPPORT_LAYERS];
 		memset(&field_types, 0, sizeof(field_types));
 
@@ -965,8 +964,7 @@ static int __mlx4_ib_create_default_rules(
 	int size = 0;
 	int i;
 
-	for (i = 0; i < sizeof(pdefault_rules->rules_create_list)/
-			sizeof(pdefault_rules->rules_create_list[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(pdefault_rules->rules_create_list); i++) {
 		int ret;
 		union ib_flow_spec ib_spec;
 		switch (pdefault_rules->rules_create_list[i]) {
-- 
1.9.1

