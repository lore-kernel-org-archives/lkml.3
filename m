Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab3KNQjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:39:32 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:58722 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676Ab3KNQix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:38:53 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Dmitry Eremin <dmitry.eremin@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 06/39] staging/lustre/lnet: build Lustre with Intel OFED for Xeon Phi
Date: Fri, 15 Nov 2013 00:32:29 +0800
Message-Id: <1384446782-13741-7-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
References: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Eremin <dmitry.eremin@intel.com>

The compilation of Lustre with Intel OFED for Xeon Phi failed
because of missing include of pci-dma.h header file. In Linux
kernel includes this file included automatically from pci.h
but in Intel Xeon Phi headers it's not true. So, just add this
include explicitly.

Lustre-change: http://review.whamcloud.com/7115
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3637
Signed-off-by: Dmitry Eremin <dmitry.eremin@intel.com>
Reviewed-by: Liang Zhen <liang.zhen@intel.com>
Reviewed-by: Doug Oucharek <doug.s.oucharek@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h    |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h
index 938df0c..8cfd78b 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h
@@ -38,6 +38,7 @@
  * Author: Eric Barton <eric@bartonsoftware.com>
  */
 
+#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
@@ -57,6 +58,7 @@
 #include <linux/kmod.h>
 #include <linux/sysctl.h>
 #include <linux/pci.h>
+#include <linux/pci-dma.h>
 
 #include <net/sock.h>
 #include <linux/in.h>
-- 
1.7.9.5

