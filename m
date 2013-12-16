Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab3LPKOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 05:14:53 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:56470 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab3LPKOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 05:14:49 -0500
Date: Mon, 16 Dec 2013 15:44:39 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        dmaengine@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 2/2] drivers: dma: Include appropriate header file in dca.c
Message-ID: <855c6e216e86bed7b723c1a647491d9fab2ed77b.1387188138.git.rashika.kheria@gmail.com>
References: <dba654dc34646dda2998dbf7b08d7ce3c160ff8c.1387188138.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dba654dc34646dda2998dbf7b08d7ce3c160ff8c.1387188138.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Includes an appropriate header file dma_v2.h in ioat/dca.c because
functions ioat2_dca_init() and ioat3_dca_init() have their function
declarations in dma_v2.h.

This eliminates the following warning in ioat/dca.c:
drivers/dma/ioat/dca.c:410:22: warning: no previous prototype for ‘ioat2_dca_init’ [-Wmissing-prototypes]
drivers/dma/ioat/dca.c:624:22: warning: no previous prototype for ‘ioat3_dca_init’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/dma/ioat/dca.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/ioat/dca.c b/drivers/dma/ioat/dca.c
index 9e84d5b..b158bba 100644
--- a/drivers/dma/ioat/dca.c
+++ b/drivers/dma/ioat/dca.c
@@ -35,6 +35,7 @@
 
 #include "dma.h"
 #include "registers.h"
+#include "dma_v2.h"
 
 /*
  * Bit 7 of a tag map entry is the "valid" bit, if it is set then bits 0:6
-- 
1.7.9.5

