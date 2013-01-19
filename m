Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab3ASJOj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 04:14:39 -0500
Received: from mga03.intel.com ([143.182.124.21]:7352 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889Ab3ASJC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 04:02:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,498,1355126400"; 
   d="scan'208";a="245905173"
From: Jon Mason <jon.mason@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 01/21] NTB: correct missing readq/writeq errors
Date: Sat, 19 Jan 2013 02:02:15 -0700
Message-Id: <1358586155-23322-2-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358586155-23322-1-git-send-email-jon.mason@intel.com>
References: <1358586155-23322-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atomic readq and writeq do not exist by default on some 32bit
architectures, thus causing compile errors due to non-existent symbols.
In those cases, use the definitions of those symbols from
include/asm-generic/io-64-nonatomic-hi-lo.h

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_hw.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index 4c71b17..0b46fef 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -45,6 +45,7 @@
  * Contact Information:
  * Jon Mason <jon.mason@intel.com>
  */
+#include <asm-generic/io-64-nonatomic-hi-lo.h>
 #include <linux/debugfs.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
-- 
1.7.9.5

