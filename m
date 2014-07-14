Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbaGNVYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 17:24:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:6400 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756734AbaGNVYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 17:24:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,660,1400050800"; 
   d="scan'208";a="543266380"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Siva Yerramreddy <yshivakrishna@gmail.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>, Sudeep Dutt <sudeep.dutt@intel.com>,
        Paul Bolle <pebolle@tiscali.nl>,
        Himangi Saraogi <himangi774@gmail.com>, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: [PATCH char-misc-next 2/2] dma: Fix MIC X100 DMA Driver Kconfig option
Date: Mon, 14 Jul 2014 14:23:52 -0700
Message-Id: <2eadff30dc5e9642b82f523c0398bf20109dd622.1405370827.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1405370827.git.sudeep.dutt@intel.com>
References: <cover.1405370827.git.sudeep.dutt@intel.com>
In-Reply-To: <cover.1405370827.git.sudeep.dutt@intel.com>
References: <cover.1405370827.git.sudeep.dutt@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Select DMA_ENGINE instead of DMAENGINE and delete the default
line as the default is 'n' anyways.

Link: https://lkml.org/lkml/2014/7/14/90
Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
---
 drivers/dma/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 7c8b8c4..8f6afbf 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -36,8 +36,7 @@ comment "DMA Devices"
 config INTEL_MIC_X100_DMA
 	tristate "Intel MIC X100 DMA Driver"
 	depends on 64BIT && X86 && INTEL_MIC_BUS
-	select DMAENGINE
-	default N
+	select DMA_ENGINE
 	help
 	  This enables DMA support for the Intel Many Integrated Core
 	  (MIC) family of PCIe form factor coprocessor X100 devices that
-- 
1.8.2.1

