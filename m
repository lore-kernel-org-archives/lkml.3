Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab3F1TXX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:23:23 -0400
Received: from 8bytes.org ([85.214.48.195]:47351 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab3F1TXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 15:23:22 -0400
Date: Fri, 28 Jun 2013 21:23:19 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Andreas Hartmann <andihartmann@01019freenet.de>,
        Alex Williamson <alex.williamson@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ 102/127] iommu/amd: Workaround for ERBT1312
Message-ID: <20130628192319.GV11309@8bytes.org>
References: <lhtAZ-q1-5@gated-at.bofh.it>
 <lhtB1-q1-53@gated-at.bofh.it>
 <20130628181136.52d00e9c@dualc.maya.org>
 <20130628182533.GT11309@8bytes.org>
 <51CDD8FD.808@01019freenet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51CDD8FD.808@01019freenet.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Jun 28 21:23:20 2013
X-DSPAM-Confidence: 0.9988
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51cde2a820862074613982
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex, Andreas,

On Fri, Jun 28, 2013 at 08:42:05PM +0200, Andreas Hartmann wrote:
> You're right, there is exactly one entry directly after loading of vfio.
> I can see this message, too, with linux 3.4.43.

Can you please test this patch? It should reduce the noise
significantly, but a few of those error messages are still expected.

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index e3c2d74..74e1d1c 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1431,6 +1431,7 @@ static void init_device_table_dma(void)
 	for (devid = 0; devid <= amd_iommu_last_bdf; ++devid) {
 		set_dev_entry_bit(devid, DEV_ENTRY_VALID);
 		set_dev_entry_bit(devid, DEV_ENTRY_TRANSLATION);
+		set_dev_entry_bit(devid, DEV_ENTRY_ONE_FAULT);
 	}
 }
 
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index 083f98c..4872b68 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -173,6 +173,7 @@
 #define DEV_ENTRY_TRANSLATION   0x01
 #define DEV_ENTRY_IR            0x3d
 #define DEV_ENTRY_IW            0x3e
+#define DEV_ENTRY_ONE_FAULT	0x61
 #define DEV_ENTRY_NO_PAGE_FAULT	0x62
 #define DEV_ENTRY_EX            0x67
 #define DEV_ENTRY_SYSMGT1       0x68

