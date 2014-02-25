Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417AbaBYHkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 02:40:45 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:42165 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbaBYHko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 02:40:44 -0500
Date: Tue, 25 Feb 2014 13:10:36 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: josh@joshtriplett.org, rashika.kheria@gmail.com
Subject: [PATCH 1/8] lib: Include appropriate header file in
 lib/iommu-helper.c
Message-ID: <7bf34999aea7f3d1441dc8fc344882a814da6e06.1393313946.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include appropriate header file include/linux/iommu-helper.h in
lib/iommu-helper.c because it has prototype declaration of function
defined in lib/iommu-helper.c.

This eliminates the following warning in lib/iommu-helper.c:
lib/iommu-helper.c:9:5: warning: no previous prototype for ‘iommu_is_span_boundary’ [-Wmissing-prototypes]
lib/iommu-helper.c:19:15: warning: no previous prototype for ‘iommu_area_alloc’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 lib/iommu-helper.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/iommu-helper.c b/lib/iommu-helper.c
index c27e269..41d35fb 100644
--- a/lib/iommu-helper.c
+++ b/lib/iommu-helper.c
@@ -5,6 +5,7 @@
 #include <linux/export.h>
 #include <linux/bitmap.h>
 #include <linux/bug.h>
+#include <linux/iommu-helper.h>
 
 int iommu_is_span_boundary(unsigned int index, unsigned int nr,
 			   unsigned long shift,
-- 
1.7.9.5

