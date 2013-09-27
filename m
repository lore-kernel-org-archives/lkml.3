Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab3I0QvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 12:51:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:15217 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356Ab3I0QvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 12:51:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,994,1371106800"; 
   d="scan'208";a="300200547"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
Subject: [PATCH char-misc-next 5/5] misc: mic: depend on X86 for both host and card drivers.
Date: Fri, 27 Sep 2013 09:50:16 -0700
Message-Id: <bdff05b31cceb8ccd15e1d4516014dd09dfe3b90.1380289102.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1380289102.git.sudeep.dutt@intel.com>
References: <cover.1380289102.git.sudeep.dutt@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes build failures seen on certain non X86 architectures.
The card driver should correctly always depend on X86. The host
driver can potentially work on non X86 architectures although
it has never been built or validated in such configurations.
The host driver dependency on X86 can be removed at some point
in the future but this workaround is required for now.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>
Signed-off-by: Nikhil Rao <nikhil.rao@intel.com>
Signed-off-by: Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>
Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
---
 drivers/misc/mic/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mic/Kconfig b/drivers/misc/mic/Kconfig
index d453768..e42b331 100644
--- a/drivers/misc/mic/Kconfig
+++ b/drivers/misc/mic/Kconfig
@@ -2,7 +2,7 @@ comment "Intel MIC Host Driver"
 
 config INTEL_MIC_HOST
 	tristate "Intel MIC Host Driver"
-	depends on 64BIT && PCI
+	depends on 64BIT && PCI && X86
 	select VHOST_RING
 	default N
 	help
@@ -23,7 +23,7 @@ comment "Intel MIC Card Driver"
 
 config INTEL_MIC_CARD
 	tristate "Intel MIC Card Driver"
-	depends on 64BIT
+	depends on 64BIT && X86
 	select VIRTIO
 	default N
 	help
-- 
1.8.2.1

