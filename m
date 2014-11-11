Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbaKKMWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:22:19 -0500
Received: from mga14.intel.com ([192.55.52.115]:62222 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbaKKMVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 07:21:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="414783177"
From: Octavian Purdila <octavian.purdila@intel.com>
To: lee.jones@linaro.org
Cc: laurentiu.palcu@intel.com, johan@kernel.org, wsa@the-dreams.de,
        julia.lawall@lip6.fr, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH 1/2] mfd: dln2: fix _dln2_transfer return code
Date: Tue, 11 Nov 2014 14:20:56 +0200
Message-Id: <1415708457-18798-2-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415708457-18798-1-git-send-email-octavian.purdila@intel.com>
References: <1415708457-18798-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If wait_for_completion_interruptible_timeout returns a positive value
it may be propagated as the return value of _dln2_transfer. This
contradicts the documentation of the function and exposes unnecessary
internals to the callers.

This patch makes sure to set the return value to 0 in that case.

Reported-by: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 drivers/mfd/dln2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/dln2.c b/drivers/mfd/dln2.c
index 9765a17..f0747a1 100644
--- a/drivers/mfd/dln2.c
+++ b/drivers/mfd/dln2.c
@@ -462,7 +462,8 @@ static int _dln2_transfer(struct dln2_dev *dln2, u16 handle, u16 cmd,
 		if (!ret)
 			ret = -ETIMEDOUT;
 		goto out_free_rx_slot;
-	}
+	} else
+		ret = 0;
 
 	if (dln2->disconnect) {
 		ret = -ENODEV;
-- 
1.9.1

