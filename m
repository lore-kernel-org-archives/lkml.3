Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932731AbaFCLlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:41:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43559 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932628AbaFCLlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:41:37 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josef Gajdusek <atx@atx.name>, Guenter Roeck <linux@roeck-us.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 070/138] hwmon: (emc1403) Support full range of known chip revision numbers
Date: Tue,  3 Jun 2014 12:38:36 +0100
Message-Id: <1401795584-22664-71-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hwmon/emc1403.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/emc1403.c b/drivers/hwmon/emc1403.c
index 62fba71ef3c5..361f50b221bd 100644
--- a/drivers/hwmon/emc1403.c
+++ b/drivers/hwmon/emc1403.c
@@ -295,7 +295,7 @@ static int emc1403_detect(struct i2c_client *client,
 	}
 
 	id = i2c_smbus_read_byte_data(client, THERMAL_REVISION_REG);
-	if (id != 0x01)
+	if (id < 0x01 || id > 0x04)
 		return -ENODEV;
 
 	return 0;
-- 
1.9.1

