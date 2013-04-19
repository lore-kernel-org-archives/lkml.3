Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967783Ab3DSBi2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 21:38:28 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:56312 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967641Ab3DSBi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 21:38:26 -0400
Date: Fri, 19 Apr 2013 09:38:04 +0800
From: Wang YanQing <udknight@gmail.com>
To: dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, joro@8bytes.org, alex.williamson@redhat.com
Subject: [PATCH] iommu: Include linux/err.h
Message-ID: <20130419013804.GA7552@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>, dwmw2@infradead.org,
	linux-kernel@vger.kernel.org, joro@8bytes.org,
	alex.williamson@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The linux/iommu.h header uses ERR_PTR defined
in linux/err.h but doesn't include it.

Cc:joro@8bytes.org
Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 This patch has been in LKML for more than 2 months,
 I even forget it, but the compile error when I compile
 a kernel module for 3.8.8 failed due without CONFIG_IOMMU_API
 in my .config remind me.
 
 I really hope someone accept it.

 Thanks. 
 include/linux/iommu.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index f3b99e1..f4a49a6 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -20,6 +20,7 @@
 #define __LINUX_IOMMU_H
 
 #include <linux/errno.h>
+#include <linux/err.h>
 #include <linux/types.h>
 
 #define IOMMU_READ	(1)
-- 
1.7.12.4.dirty
