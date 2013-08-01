Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab3HAKBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 06:01:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039Ab3HAKBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 06:01:38 -0400
From: Jan Vesely <jvesely@redhat.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jan Vesely <jvesely@redhat.com>,
        Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>,
        Sreekanth Reddy <Sreekanth.Reddy@lsi.com>,
        Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH 1/2] mpt2sas: Remove phys on topology change.
Date: Thu,  1 Aug 2013 12:01:30 +0200
Message-Id: <1375351291-27107-2-git-send-email-jvesely@redhat.com>
In-Reply-To: <1375351291-27107-1-git-send-email-jvesely@redhat.com>
References: <1375351291-27107-1-git-send-email-jvesely@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Vesely <jvesely@redhat.com>

CC: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
CC: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
CC: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Jan Vesely <jvesely@redhat.com>
---
 drivers/scsi/mpt2sas/mpt2sas_transport.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index 193e7ae..e610a97 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -1006,9 +1006,12 @@ mpt2sas_transport_update_links(struct MPT2SAS_ADAPTER *ioc,
 		    &mpt2sas_phy->remote_identify);
 		_transport_add_phy_to_an_existing_port(ioc, sas_node,
 		    mpt2sas_phy, mpt2sas_phy->remote_identify.sas_address);
-	} else
+	} else {
 		memset(&mpt2sas_phy->remote_identify, 0 , sizeof(struct
 		    sas_identify));
+		_transport_del_phy_from_an_existing_port(ioc, sas_node,
+		    mpt2sas_phy);
+	}
 
 	if (mpt2sas_phy->phy)
 		mpt2sas_phy->phy->negotiated_linkrate =
-- 
1.7.1

