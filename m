Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673AbaIBKyv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 06:54:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:64545 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643AbaIBKyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 06:54:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,448,1406617200"; 
   d="scan'208";a="596691818"
From: Irina Tirdea <irina.tirdea@intel.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org
Cc: Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-kernel@vger.kernel.org, Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH] iio: gyro: bmg160: only set power state if PM_RUNTIME is defined
Date: Tue,  2 Sep 2014 14:02:39 +0300
Message-Id: <1409655759-28849-1-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_PM_RUNTIME is not defined and bmg160 tries to power
off the device, bmg160_set_power_state will call pm_runtime_put_autosuspend,
which is not implemented (wil return -ENOSYS).

Only call bmg160_set_power_state when CONFIG_PM_RUNTIME is defined.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Reviewed-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
---
 drivers/iio/gyro/bmg160.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/iio/gyro/bmg160.c b/drivers/iio/gyro/bmg160.c
index 7524698..e41d6b5 100644
--- a/drivers/iio/gyro/bmg160.c
+++ b/drivers/iio/gyro/bmg160.c
@@ -235,6 +235,7 @@ static int bmg160_chip_init(struct bmg160_data *data)
 	return 0;
 }
 
+#ifdef CONFIG_PM_RUNTIME
 static int bmg160_set_power_state(struct bmg160_data *data, bool on)
 {
 	int ret;
@@ -254,6 +255,12 @@ static int bmg160_set_power_state(struct bmg160_data *data, bool on)
 
 	return 0;
 }
+#else
+static int bmg160_set_power_state(struct bmg160_data *data, bool on)
+{
+	return 0;
+}
+#endif
 
 static int bmg160_setup_any_motion_interrupt(struct bmg160_data *data,
 					     bool status)
-- 
1.7.9.5

