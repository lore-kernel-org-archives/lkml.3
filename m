Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbaLTQQT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 11:16:19 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:46805 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbaLTQQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 11:16:16 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Mike Marciniszyn <infinipath@intel.com>, Roland Dreier <roland@kernel.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] infiniband: hw: ipath: ipath_wc_ppc64.c:  Remove unused function
Date: Sat, 20 Dec 2014 17:19:02 +0100
Message-Id: <1419092342-7120-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function ipath_unordered_wc() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/infiniband/hw/ipath/ipath_kernel.h    |    3 ---
 drivers/infiniband/hw/ipath/ipath_wc_ppc64.c  |   13 -------------
 drivers/infiniband/hw/ipath/ipath_wc_x86_64.c |   15 ---------------
 3 files changed, 31 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_kernel.h b/drivers/infiniband/hw/ipath/ipath_kernel.h
index 6559af6..e08db70 100644
--- a/drivers/infiniband/hw/ipath/ipath_kernel.h
+++ b/drivers/infiniband/hw/ipath/ipath_kernel.h
@@ -908,9 +908,6 @@ void ipath_chip_cleanup(struct ipath_devdata *);
 /* clean up any chip type-specific stuff */
 void ipath_chip_done(void);
 
-/* check to see if we have to force ordering for write combining */
-int ipath_unordered_wc(void);
-
 void ipath_disarm_piobufs(struct ipath_devdata *, unsigned first,
 			  unsigned cnt);
 void ipath_cancel_sends(struct ipath_devdata *, int);
diff --git a/drivers/infiniband/hw/ipath/ipath_wc_ppc64.c b/drivers/infiniband/hw/ipath/ipath_wc_ppc64.c
index 1d7bd82..1a7e20a 100644
--- a/drivers/infiniband/hw/ipath/ipath_wc_ppc64.c
+++ b/drivers/infiniband/hw/ipath/ipath_wc_ppc64.c
@@ -47,16 +47,3 @@ int ipath_enable_wc(struct ipath_devdata *dd)
 {
 	return 0;
 }
-
-/**
- * ipath_unordered_wc - indicate whether write combining is unordered
- *
- * Because our performance depends on our ability to do write
- * combining mmio writes in the most efficient way, we need to
- * know if we are on a processor that may reorder stores when
- * write combining.
- */
-int ipath_unordered_wc(void)
-{
-	return 1;
-}
diff --git a/drivers/infiniband/hw/ipath/ipath_wc_x86_64.c b/drivers/infiniband/hw/ipath/ipath_wc_x86_64.c
index 3428acb..4ad0b93 100644
--- a/drivers/infiniband/hw/ipath/ipath_wc_x86_64.c
+++ b/drivers/infiniband/hw/ipath/ipath_wc_x86_64.c
@@ -167,18 +167,3 @@ void ipath_disable_wc(struct ipath_devdata *dd)
 		dd->ipath_wc_cookie = 0; /* even on failure */
 	}
 }
-
-/**
- * ipath_unordered_wc - indicate whether write combining is ordered
- *
- * Because our performance depends on our ability to do write combining mmio
- * writes in the most efficient way, we need to know if we are on an Intel
- * or AMD x86_64 processor.  AMD x86_64 processors flush WC buffers out in
- * the order completed, and so no special flushing is required to get
- * correct ordering.  Intel processors, however, will flush write buffers
- * out in "random" orders, and so explicit ordering is needed at times.
- */
-int ipath_unordered_wc(void)
-{
-	return boot_cpu_data.x86_vendor != X86_VENDOR_AMD;
-}
-- 
1.7.10.4

