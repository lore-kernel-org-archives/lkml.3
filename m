Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbaFEFHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 01:07:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43801 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbaFEEUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:20:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Josef Gajdusek <atx@atx.name>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3.4 045/214] hwmon: (emc1403) Support full range of known chip revision numbers
Date: Wed,  4 Jun 2014 21:16:48 -0700
Message-Id: <20140605041645.684377506@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/emc1403.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/emc1403.c
+++ b/drivers/hwmon/emc1403.c
@@ -294,7 +294,7 @@ static int emc1403_detect(struct i2c_cli
 	}
 
 	id = i2c_smbus_read_byte_data(client, THERMAL_REVISION_REG);
-	if (id != 0x01)
+	if (id < 0x01 || id > 0x04)
 		return -ENODEV;
 
 	return 0;


