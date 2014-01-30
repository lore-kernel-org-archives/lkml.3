Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbaA3OHS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 09:07:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853AbaA3OHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 09:07:13 -0500
Date: Thu, 30 Jan 2014 15:09:07 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Wendy Xiong <wenxiong@linux.vnet.ibm.com>
Subject: [PATCH v2 1/2] ipr: Get rid of superfluous call to
 pci_disable_msi/msix()
Message-ID: <20140130140906.GB32349@dhcp-26-207.brq.redhat.com>
References: <cover.1389904166.git.agordeev@redhat.com>
 <eb0b62be65c050533f2565fcf3f1d673770dfd67.1389904166.git.agordeev@redhat.com>
 <20140128095441.GA6951@dhcp-26-207.brq.redhat.com>
 <52E7CCAD.5070008@linux.vnet.ibm.com>
 <20140129132651.GA27764@dhcp-26-207.brq.redhat.com>
 <20140130140630.GA32349@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140130140630.GA32349@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to call pci_disable_msi() or pci_disable_msix()
in case the call to pci_enable_msi() or pci_enable_msix() failed.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/scsi/ipr.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 96c10ce..48d0cfc 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -9329,7 +9329,6 @@ static int ipr_enable_msix(struct ipr_ioa_cfg *ioa_cfg)
 
 	if (err < 0) {
 		ipr_wait_for_pci_err_recovery(ioa_cfg);
-		pci_disable_msix(ioa_cfg->pdev);
 		return err;
 	}
 
@@ -9353,7 +9352,6 @@ static int ipr_enable_msi(struct ipr_ioa_cfg *ioa_cfg)
 
 	if (err < 0) {
 		ipr_wait_for_pci_err_recovery(ioa_cfg);
-		pci_disable_msi(ioa_cfg->pdev);
 		return err;
 	}
 
-- 
1.7.7.6

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
