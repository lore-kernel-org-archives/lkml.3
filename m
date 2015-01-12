Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbbALSvN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:51:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58191 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086AbbALSaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:20 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>,
        Christoph Hellwig <hch@lst.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 159/216] Revert "[SCSI] mpt3sas: Remove phys on topology change"
Date: Mon, 12 Jan 2015 18:28:57 +0000
Message-Id: <1421087394-2712-47-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index 65170cb1a00f..55aa597eb229 100644
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
2.1.4

