Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759481AbbAYTXO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:23:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57232 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890AbbAYSJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>,
        Tomas Henzl <thenzl@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3.14 37/98] Revert "[SCSI] mpt3sas: Remove phys on topology change"
Date: Sun, 25 Jan 2015 10:06:55 -0800
Message-Id: <20150125180714.479027430@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180712.859646324@linuxfoundation.org>
References: <20150125180712.859646324@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/mpt3sas/mpt3sas_transport.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -1003,12 +1003,9 @@ mpt3sas_transport_update_links(struct MP
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


