Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298Ab3CZSCD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:02:03 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50772 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756244Ab3CZSB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 14:01:58 -0400
From: Nishanth Menon <nm@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Nishanth Menon <nm@ti.com>, Vincent Guittot <vincent.guittot@linaro.org>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] PM / OPP: add documentation to rcu head in opp struct
Date: Tue, 26 Mar 2013 13:01:49 -0500
Message-ID: <1364320909-14830-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit dde8437d06560366d8988c92b5774039ec703864
(PM / OPP: RCU reclaim)
introduced rcu_head for struct opp. This aids freeing using
kfree_rcu. However, we missed adding documentation for the
same. This generates kernel doc warning:
Warning(drivers/base/power/opp.c:70): No description found for parameter 'head'

Add documentation for the same.

Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/base/power/opp.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index 32ee0fc..f0077cb 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -55,6 +55,7 @@
  * @rate:	Frequency in hertz
  * @u_volt:	Nominal voltage in microvolts corresponding to this OPP
  * @dev_opp:	points back to the device_opp struct this opp belongs to
+ * @head:	RCU callback head used for deferred freeing
  *
  * This structure stores the OPP information for a given device.
  */
-- 
1.7.9.5

