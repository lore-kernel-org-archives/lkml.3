Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967545Ab3HICU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:20:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55607 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967425Ab3HIB6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:58:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [ 019/102] hwmon: (max6697) fix MAX6581 ideality
Date: Thu,  8 Aug 2013 18:56:55 -0700
Message-Id: <20130809015014.546123640@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>

commit 5c52add19733eb36d8619713312f5604efef3502 upstream.

Without this patch, the values for ideality (register 0x4b) and ideality
selection mask (register 0x4c) are inverted.

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/max6697.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/max6697.c
+++ b/drivers/hwmon/max6697.c
@@ -605,12 +605,12 @@ static int max6697_init_chip(struct i2c_
 		if (ret < 0)
 			return ret;
 		ret = i2c_smbus_write_byte_data(client, MAX6581_REG_IDEALITY,
-						pdata->ideality_mask >> 1);
+						pdata->ideality_value);
 		if (ret < 0)
 			return ret;
 		ret = i2c_smbus_write_byte_data(client,
 						MAX6581_REG_IDEALITY_SELECT,
-						pdata->ideality_value);
+						pdata->ideality_mask >> 1);
 		if (ret < 0)
 			return ret;
 	}


