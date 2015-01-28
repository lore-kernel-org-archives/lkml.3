Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997AbbA2JF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:05:56 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44849 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756828AbbA2JFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:05:40 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>,
        Christoph Hellwig <hch@lst.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 086/176] Revert "[SCSI] mpt3sas: Remove phys on topology change"
Date: Wed, 28 Jan 2015 15:28:36 +0100
Message-Id: <95bc632b0923745238d250febe3cc02bb3839f1c.1422455352.git.jslaby@suse.cz>
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

commit 2311ce4d9c91ed63a46e18f0378f3e406e7e888e upstream.

This reverts commit 963ba22b90a955363644cd397b20226928eab976
("mpt3sas: Remove phys on topology change")

Reverting the previous mpt3sas drives patch changes,
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
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index e771a88c6a74..dcadd56860ff 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -1003,12 +1003,9 @@ mpt3sas_transport_update_links(struct MPT3SAS_ADAPTER *ioc,
 		    &mpt3sas_phy->remote_identify);
 		_transport_add_phy_to_an_existing_port(ioc, sas_node,
 		    mpt3sas_phy, mpt3sas_phy->remote_identify.sas_address);
-	} else {
+	} else
 		memset(&mpt3sas_phy->remote_identify, 0 , sizeof(struct
 		    sas_identify));
-		_transport_del_phy_from_an_existing_port(ioc, sas_node,
-		    mpt3sas_phy);
-	}
 
 	if (mpt3sas_phy->phy)
 		mpt3sas_phy->phy->negotiated_linkrate =
-- 
2.2.2

