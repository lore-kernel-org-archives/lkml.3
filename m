Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759968AbbA2JFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:05:51 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44851 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752903AbbA2JFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:05:46 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>,
        Christoph Hellwig <hch@lst.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 085/176] Revert "[SCSI] mpt2sas: Remove phys on topology change."
Date: Wed, 28 Jan 2015 15:28:35 +0100
Message-Id: <ba77da8bb79a6f887e05dff47cf98017f2ba302b.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 81a89c2d891b78695aa7e4cc0d5a7427785ae078 upstream.

This reverts commit 3520f9c779bed098ca76dd3fb6377264301d57ed
("mpt2sas: Remove phys on topology change")

Reverting the previous mpt2sas drives patch changes,
since we will observe below issue

Issue:
Drives connected Enclosure/Expander will unregister with
SCSI Transport Layer, if any one remove and add expander
cable with in DMD (Device Missing Delay) time period or
even any one power-off and power-on the Enclosure with in
the DMD period.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/scsi/mpt2sas/mpt2sas_transport.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index 9d26637308be..396d78ef59e7 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -1006,12 +1006,9 @@ mpt2sas_transport_update_links(struct MPT2SAS_ADAPTER *ioc,
 		    &mpt2sas_phy->remote_identify);
 		_transport_add_phy_to_an_existing_port(ioc, sas_node,
 		    mpt2sas_phy, mpt2sas_phy->remote_identify.sas_address);
-	} else {
+	} else
 		memset(&mpt2sas_phy->remote_identify, 0 , sizeof(struct
 		    sas_identify));
-		_transport_del_phy_from_an_existing_port(ioc, sas_node,
-		    mpt2sas_phy);
-	}
 
 	if (mpt2sas_phy->phy)
 		mpt2sas_phy->phy->negotiated_linkrate =
-- 
2.2.2

