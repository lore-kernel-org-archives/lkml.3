Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab3J3Q3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 12:29:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312Ab3J3Q1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 12:27:30 -0400
From: Aristeu Rozanski <arozansk@redhat.com>
To: linux-edac@vger.kernel.org
Cc: tony.luck@intel.com, Aristeu Rozanski <arozansk@redhat.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com> (maintainer:EDAC-SBRIDGE),
        Doug Thompson <dougthompson@xmission.com> (supporter:EDAC-CORE),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 10/12] sb_edac: rename mci_bind_devs()
Date: Wed, 30 Oct 2013 12:27:04 -0400
Message-Id: <1383150426-24730-11-git-send-email-arozansk@redhat.com>
In-Reply-To: <1383150426-24730-1-git-send-email-arozansk@redhat.com>
References: <1383150426-24730-1-git-send-email-arozansk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is in preparation for Ivy Bridge support

Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>
---
 drivers/edac/sb_edac.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 3e07c28..2e977b9 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -1227,8 +1227,8 @@ static int sbridge_get_all_devices(u8 *num_mc,
 	return 0;
 }
 
-static int mci_bind_devs(struct mem_ctl_info *mci,
-			 struct sbridge_dev *sbridge_dev)
+static int sbridge_mci_bind_devs(struct mem_ctl_info *mci,
+				 struct sbridge_dev *sbridge_dev)
 {
 	struct sbridge_pvt *pvt = mci->pvt_info;
 	struct pci_dev *pdev;
@@ -1670,7 +1670,7 @@ static int sbridge_register_mci(struct sbridge_dev *sbridge_dev)
 	mci->edac_check = sbridge_check_error;
 
 	/* Store pci devices at mci for faster access */
-	rc = mci_bind_devs(mci, sbridge_dev);
+	rc = sbridge_mci_bind_devs(mci, sbridge_dev);
 	if (unlikely(rc < 0))
 		goto fail0;
 
-- 
1.7.1

