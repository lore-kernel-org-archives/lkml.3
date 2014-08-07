Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbaHGDCK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 23:02:10 -0400
Received: from smtp-out-02.shaw.ca ([64.59.136.138]:3144 "EHLO
	smtp-out-02.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510AbaHGDCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 23:02:07 -0400
X-Greylist: delayed 573 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Aug 2014 23:02:07 EDT
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=W0/jygPWOP4vNGB1giqMd6hViTlTWopR5z2gXdBWnF4= c=1 sm=1
 a=VeS-mf-K6mcA:10 a=EJEADgB2CZsA:10 a=3762yOXauukA:10 a=BLceEmwcHowA:10
 a=x/GiHf5VU5uXFAeKKVSXKg==:17 a=HlPRHPCHw5Ts0-oRL6QA:9
 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
From: Simon Wood <simon@mungewell.org>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Simon Wood <simon@mungewell.org>
Subject: [PATCH] HID:hid-logitech: Prevent possibility of infinite loop when using /sys interface
Date: Wed,  6 Aug 2014 20:52:31 -0600
Message-Id: <1407379951-7038-1-git-send-email-simon@mungewell.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the device data is not accessible for some reason, returning 0 will cause the call to be
continuously called again as none of the string has been 'consumed'.
---
 drivers/hid/hid-lg4ff.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
index cc2bd20..7835717 100644
--- a/drivers/hid/hid-lg4ff.c
+++ b/drivers/hid/hid-lg4ff.c
@@ -451,13 +451,13 @@ static ssize_t lg4ff_range_store(struct device *dev, struct device_attribute *at
 	drv_data = hid_get_drvdata(hid);
 	if (!drv_data) {
 		hid_err(hid, "Private driver data not found!\n");
-		return 0;
+		return -EINVAL;
 	}
 
 	entry = drv_data->device_props;
 	if (!entry) {
 		hid_err(hid, "Device properties not found!\n");
-		return 0;
+		return -EINVAL;
 	}
 
 	if (range == 0)
-- 
1.9.1

