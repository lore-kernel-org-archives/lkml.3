Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab3BVJkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 04:40:13 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:36238 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755913Ab3BVJkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 04:40:07 -0500
Date: Fri, 22 Feb 2013 10:39:59 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH] mfd: trivially fix build warning in sta2x11-mfd
Message-ID: <20130222093959.GA6549@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver cannot be a module, so "remove" is never called.  The
mishap is mine, and back then there was no warning due to __devexit().

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---
 drivers/mfd/sta2x11-mfd.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/mfd/sta2x11-mfd.c b/drivers/mfd/sta2x11-mfd.c
index 9bd3316..d70a3430 100644
--- a/drivers/mfd/sta2x11-mfd.c
+++ b/drivers/mfd/sta2x11-mfd.c
@@ -98,17 +98,6 @@ static int sta2x11_mfd_add(struct pci_dev *pdev, gfp_t flags)
 	return 0;
 }
 
-static int mfd_remove(struct pci_dev *pdev)
-{
-	struct sta2x11_mfd *mfd = sta2x11_mfd_find(pdev);
-
-	if (!mfd)
-		return -ENODEV;
-	list_del(&mfd->list);
-	kfree(mfd);
-	return 0;
-}
-
 /* This function is exported and is not expected to fail */
 u32 __sta2x11_mfd_mask(struct pci_dev *pdev, u32 reg, u32 mask, u32 val,
 		       enum sta2x11_mfd_plat_dev index)
-- 
1.7.7.2
