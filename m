Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933952Ab3CRVt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:49:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45700 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824Ab3CRVHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:07:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        xiong <xiong@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 58/75] atl1c: restore buffer state
Date: Mon, 18 Mar 2013 14:07:21 -0700
Message-Id: <20130318210514.425551426@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210510.203500214@linuxfoundation.org>
References: <20130318210510.203500214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "Huang, Xiong" <xiong@qca.qualcomm.com>

[ Upstream commit 7cb08d7f3a5ea6131f4f243c2080530ac41cb293 ]

in the previous commit : f1f220ea1dda078, the BUSY state of buffer is wrongly
deleted. this patch just restore it.

Signed-off-by: xiong <xiong@qca.qualcomm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -2075,7 +2075,7 @@ static int atl1c_tx_map(struct atl1c_ada
 		if (unlikely(pci_dma_mapping_error(adapter->pdev,
 						   buffer_info->dma)))
 			goto err_dma;
-
+		ATL1C_SET_BUFFER_STATE(buffer_info, ATL1C_BUFFER_BUSY);
 		ATL1C_SET_PCIMAP_TYPE(buffer_info, ATL1C_PCIMAP_SINGLE,
 			ATL1C_PCIMAP_TODEVICE);
 		mapped_len += map_len;


