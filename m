Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbaIXQrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:47:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:38272 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbaIXQrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:47:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,590,1406617200"; 
   d="scan'208";a="604749375"
From: Vinod Koul <vinod.koul@intel.com>
To: linux-kernel@vger.kernel.org
Cc: subhransu.s.prusty@intel.com, vinod.koul@intel.com,
        Wolfram Sang <wsa@the-dreams.de>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Andy Gross <agross@codeaurora.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Pramod Gurav <pramod.gurav@smartplayin.com>, linux-i2c@vger.kernel.org
Subject: [PATCH 10/27] i2c: qup: use pm_runtime_last_busy_and_autosuspend helper
Date: Wed, 24 Sep 2014 21:45:00 +0530
Message-Id: <1411575342-31048-11-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
References: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new pm_runtime_last_busy_and_autosuspend helper instead of open
coding the same code

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 drivers/i2c/busses/i2c-qup.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-qup.c b/drivers/i2c/busses/i2c-qup.c
index 3a4d64e..9ada3ee 100644
--- a/drivers/i2c/busses/i2c-qup.c
+++ b/drivers/i2c/busses/i2c-qup.c
@@ -518,8 +518,7 @@ static int qup_i2c_xfer(struct i2c_adapter *adap,
 		ret = num;
 out:
 
-	pm_runtime_mark_last_busy(qup->dev);
-	pm_runtime_put_autosuspend(qup->dev);
+	pm_runtime_last_busy_and_autosuspend(qup->dev);
 
 	return ret;
 }
-- 
1.7.0.4

