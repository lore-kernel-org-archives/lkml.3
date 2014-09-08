Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406AbaIHN7E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:59:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:37347 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974AbaIHN7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:59:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,486,1406617200"; 
   d="scan'208";a="587964409"
From: Irina Tirdea <irina.tirdea@intel.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org
Cc: Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-kernel@vger.kernel.org, Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH v2] iio: gyro: bmg160: only set power state if PM_RUNTIME is defined
Date: Mon,  8 Sep 2014 17:05:27 +0300
Message-Id: <1410185127-13039-1-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_PM_RUNTIME is not defined and bmg160 tries to power
off the device, bmg160_set_power_state will call pm_runtime_put_autosuspend,
which is not implemented (wil return -ENOSYS).

Only call bmg160_set_power_state when CONFIG_PM_RUNTIME is defined.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---

Changes in v2:
 - moved ifdef CONFIG_PM_RUNTIME inside bmg160_set_power_state as
Hartmut Knaack suggested

 drivers/iio/gyro/bmg160.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/gyro/bmg160.c b/drivers/iio/gyro/bmg160.c
index 7524698..1f967e0d 100644
--- a/drivers/iio/gyro/bmg160.c
+++ b/drivers/iio/gyro/bmg160.c
@@ -237,6 +237,7 @@ static int bmg160_chip_init(struct bmg160_data *data)
 
 static int bmg160_set_power_state(struct bmg160_data *data, bool on)
 {
+#ifdef CONFIG_PM_RUNTIME
 	int ret;
 
 	if (on)
@@ -251,6 +252,7 @@ static int bmg160_set_power_state(struct bmg160_data *data, bool on)
 			"Failed: bmg160_set_power_state for %d\n", on);
 		return ret;
 	}
+#endif
 
 	return 0;
 }
-- 
1.7.9.5

