Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab3F0TsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 15:48:00 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:44165 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab3F0Tr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 15:47:59 -0400
From: naresh.bhat@linaro.org
To: linux-acpi@vger.kernel.org
Cc: len.brown@intel.com, patches@linaro.org, linaro-kernel@lists.linaro.org,
        naresh.bhat@linaro.org, linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: [PATCH] ACPI/fan: Initialize acpi_state variable
Date: Fri, 28 Jun 2013 01:17:43 +0530
Message-Id: <1372362463-4186-1-git-send-email-naresh.bhat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Naresh Bhat <naresh.bhat@linaro.org>

  CC      drivers/acpi/fan.o
drivers/acpi/fan.c: In function ‘fan_get_cur_state’:
drivers/acpi/fan.c:96:9: warning: ‘acpi_state’ may be used uninitialized in this function [-Wuninitialized]
---
 drivers/acpi/fan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
index f815da8..f961435 100644
--- a/drivers/acpi/fan.c
+++ b/drivers/acpi/fan.c
@@ -84,7 +84,7 @@ static int fan_get_cur_state(struct thermal_cooling_device *cdev, unsigned long
 {
 	struct acpi_device *device = cdev->devdata;
 	int result;
-	int acpi_state;
+	int acpi_state = ACPI_STATE_D0;
 
 	if (!device)
 		return -EINVAL;
-- 
1.7.9.5

