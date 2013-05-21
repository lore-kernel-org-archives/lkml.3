Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab3EUN61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 09:58:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:60700 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785Ab3EUN60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 09:58:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,714,1363158000"; 
   d="scan'208";a="244628127"
Date: Tue, 21 May 2013 15:58:17 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] [3.10] mei: bus: Reset event_cb when disabling a device
Message-ID: <20130521135817.GE4589@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After cancelling all reads from the disable hook, we need to reset the
event_cb pointer as well or else we won't be able to set a new one up
when re-enabling the device.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/misc/mei/bus.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 1e935ea..9ecd49a 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -496,6 +496,8 @@ int mei_cl_disable_device(struct mei_cl_device *device)
 		}
 	}
 
+	device->event_cb = NULL;
+
 	mutex_unlock(&dev->device_lock);
 
 	if (!device->ops || !device->ops->disable)
-- 
1.7.10.4

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
