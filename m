Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbaHEM7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 08:59:00 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:34582 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbaHEM66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 08:58:58 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] swiotlb: Make linux/swiotlb.h standalone includable
Date: Tue,  5 Aug 2014 14:58:51 +0200
Message-Id: <1407243531-20538-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

This header file uses the enum dma_data_direction and struct page types
without explicitly including the corresponding header files. This makes
it rely on the includer to have included the proper headers before.

To fix this, include linux/dma-direction.h and forward-declare struct
page. The swiotlb_free() function is also annotated __init, therefore
requires linux/init.h to be included as well.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Alternatively rather than include linux/init.h for swiotlb_free() it
should be possible to simply remove the annotation in the header since
the implementation already has it and that's where it matters.

 include/linux/swiotlb.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index e7a018eaf3a2..017fced60242 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -1,10 +1,13 @@
 #ifndef __LINUX_SWIOTLB_H
 #define __LINUX_SWIOTLB_H
 
+#include <linux/dma-direction.h>
+#include <linux/init.h>
 #include <linux/types.h>
 
 struct device;
 struct dma_attrs;
+struct page;
 struct scatterlist;
 
 extern int swiotlb_force;
-- 
2.0.4

