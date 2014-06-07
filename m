Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbaFGBiA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:38:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36002 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752583AbaFGBXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:37 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Guenter Roeck" <linux@roeck-us.net>,
        "Josef Gajdusek" <atx@atx.name>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.896527371@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 66/92] hwmon: (emc1403) Support full range of known
 chip revision numbers
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwmon/emc1403.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/emc1403.c
+++ b/drivers/hwmon/emc1403.c
@@ -290,7 +290,7 @@ static int emc1403_detect(struct i2c_cli
 	}
 
 	id = i2c_smbus_read_byte_data(client, THERMAL_REVISION_REG);
-	if (id != 0x01)
+	if (id < 0x01 || id > 0x04)
 		return -ENODEV;
 
 	return 0;

