Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937194Ab3DJKev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 06:34:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:63542 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937154Ab3DJKer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 06:34:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,445,1363158000"; 
   d="scan'208";a="320238862"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        ben-linux@fluff.org, Jean Delvare <khali@linux-fr.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 6/7] i2c-designware: use usleep_range() in the busy-loop
Date: Wed, 10 Apr 2013 13:36:41 +0300
Message-Id: <1365590202-1623-6-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1365590202-1623-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1365590202-1623-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not an atomic context so there is no need to use mdelay() but
instead use usleep_range().

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/i2c/busses/i2c-designware-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
index 5cc4ebf..7c10c5b 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -355,7 +355,7 @@ static int i2c_dw_wait_bus_not_busy(struct dw_i2c_dev *dev)
 			return -ETIMEDOUT;
 		}
 		timeout--;
-		mdelay(1);
+		usleep_range(1000, 1100);
 	}
 
 	return 0;
-- 
1.7.10.4

