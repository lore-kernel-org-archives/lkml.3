Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbaFUMs3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 08:48:29 -0400
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:60991 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbaFUMs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 08:48:28 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: netdev@vger.kernel.org
Cc: hariprasad@chelsio.com, linux-kernel@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Subject: [PATCH] cxgb4: use dev_port to identify ports
Date: Sat, 21 Jun 2014 09:48:08 -0300
Message-Id: <1403354888-15600-1-git-send-email-cascardo@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062112-2194-0000-0000-0000092B1A79
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 3f85944fe207d0225ef21a2c0951d4946fc9a95d ("net: Add sysfs file
for port number") introduce dev_port to network devices. cxgb4 adapters
have multiple ports on the same PCI function, and used dev_id to
identify those ports. That use was removed by commit
8c367fcbe6549195d2eb11e62bea233f811aad41 ("cxgb4: Do not set
net_device::dev_id to VI index"), since dev_id should be used only when
devices share the same MAC address.

Using dev_port for cxgb4 allows different ports on the same PCI function
to be identified.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
---
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index bba6768..931478e 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -3962,6 +3962,7 @@ int t4_port_init(struct adapter *adap, int mbox, int pf, int vf)
 		p->lport = j;
 		p->rss_size = rss_size;
 		memcpy(adap->port[i]->dev_addr, addr, ETH_ALEN);
+		adap->port[i]->dev_port = j;
 
 		ret = ntohl(c.u.info.lstatus_to_modtype);
 		p->mdio_addr = (ret & FW_PORT_CMD_MDIOCAP) ?
-- 
1.7.1

