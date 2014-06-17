Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967501AbaFQWe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:34:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54074 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966259AbaFQVsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:48:51 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josef Gajdusek <atx@atx.name>, Guenter Roeck <linux@roeck-us.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 111/212] hwmon: (emc1403) Support full range of known chip revision numbers
Date: Tue, 17 Jun 2014 14:43:25 -0700
Message-Id: <1403041506-13646-112-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Gajdusek <atx@atx.name>

commit 3a18e1398fc2dc9c32bbdc50664da3a77959a8d1 upstream.

The datasheet for EMC1413/EMC1414, which is fully compatible to
EMC1403/1404 and uses the same chip identification, references revision
numbers 0x01, 0x03, and 0x04. Accept the full range of revision numbers
from 0x01 to 0x04 to make sure none are missed.

Signed-off-by: Josef Gajdusek <atx@atx.name>
[Guenter Roeck: Updated headline and description]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hwmon/emc1403.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/emc1403.c b/drivers/hwmon/emc1403.c
index 42a3cfc..01723f0 100644
--- a/drivers/hwmon/emc1403.c
+++ b/drivers/hwmon/emc1403.c
@@ -330,7 +330,7 @@ static int emc1403_detect(struct i2c_client *client,
 	}
 
 	id = i2c_smbus_read_byte_data(client, THERMAL_REVISION_REG);
-	if (id != 0x01)
+	if (id < 0x01 || id > 0x04)
 		return -ENODEV;
 
 	return 0;
-- 
1.9.1

