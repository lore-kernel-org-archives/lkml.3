Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbaHOCnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 22:43:18 -0400
Received: from smtp-out-03.shaw.ca ([64.59.136.139]:51779 "EHLO
	smtp-out-02.shaw.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752688AbaHOCnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 22:43:16 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=ryrf5q5p6c4dCQYR2lAej91p2ozDt6sfPnRAuS/Q8hc= c=1 sm=1
 a=nCpW03ZwStYA:10 a=iejKkUC8jUoA:10 a=3762yOXauukA:10 a=BLceEmwcHowA:10
 a=x/GiHf5VU5uXFAeKKVSXKg==:17 a=47LbCVvxAAAA:8 a=HlPRHPCHw5Ts0-oRL6QA:9
 a=QhNQsjeWOoAA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
From: Simon Wood <simon@mungewell.org>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Simon Wood <simon@mungewell.org>
Subject: [PATCHv2] HID:hid-logitech: Prevent possibility of infinite loop when using /sys interface
Date: Thu, 14 Aug 2014 20:43:01 -0600
Message-Id: <1408070581-2460-1-git-send-email-simon@mungewell.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <alpine.LNX.2.00.1408121630000.15220@pobox.suse.cz>
References: <alpine.LNX.2.00.1408121630000.15220@pobox.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the device data is not accessible for some reason, returning 0 will cause the call to be
continuously called again as none of the string has been 'consumed'.

Signed-off-by: Simon Wood <simon@mungewell.org>
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

