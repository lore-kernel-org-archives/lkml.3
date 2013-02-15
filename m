Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161291Ab3BOMpo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:45:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935977Ab3BOMph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:45:37 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-acpi@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDAC 10/13] edac: better report error conditions in debug mode
Date: Fri, 15 Feb 2013 10:44:58 -0200
Message-Id: <eabec3c83459107b7cba0b5f6e5ae425a2edad81.1360931635.git.mchehab@redhat.com>
In-Reply-To: <cover.1360931635.git.mchehab@redhat.com>
References: <cover.1360931635.git.mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is hard to find what's wrong without a proper error
report. Improve it, in debug mode.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_mc_sysfs.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 0ca1ca7..9c58da6 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -429,8 +429,12 @@ static int edac_create_csrow_objects(struct mem_ctl_info *mci)
 		if (!nr_pages_per_csrow(csrow))
 			continue;
 		err = edac_create_csrow_object(mci, mci->csrows[i], i);
-		if (err < 0)
+		if (err < 0) {
+			edac_dbg(1,
+				 "failure: create csrow objects for csrow %d\n",
+				 i);
 			goto error;
+		}
 	}
 	return 0;
 
@@ -1007,6 +1011,7 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 	edac_dbg(0, "creating device %s\n", dev_name(&mci->dev));
 	err = device_add(&mci->dev);
 	if (err < 0) {
+		edac_dbg(1, "failure: create device %s\n", dev_name(&mci->dev));
 		bus_unregister(&mci->bus);
 		kfree(mci->bus.name);
 		return err;
-- 
1.8.1.2

