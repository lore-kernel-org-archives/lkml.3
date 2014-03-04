Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517AbaCDUI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:08:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41830 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932372AbaCDUFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:05:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <jdelvare@suse.de>
Subject: [PATCH 3.10 73/97] hwmon: (max1668) Fix writing the minimum temperature
Date: Tue,  4 Mar 2014 12:04:26 -0800
Message-Id: <20140304200348.393213679@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200345.895517495@linuxfoundation.org>
References: <20140304200345.895517495@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 500a91571f0a5d0d3242d83802ea2fd1faccc66e upstream.

When trying to set the minimum temperature, the driver was erroneously
writing the maximum temperature into the chip.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/max1668.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/max1668.c
+++ b/drivers/hwmon/max1668.c
@@ -243,7 +243,7 @@ static ssize_t set_temp_min(struct devic
 	data->temp_min[index] = clamp_val(temp/1000, -128, 127);
 	if (i2c_smbus_write_byte_data(client,
 					MAX1668_REG_LIML_WR(index),
-					data->temp_max[index]))
+					data->temp_min[index]))
 		count = -EIO;
 	mutex_unlock(&data->update_lock);
 


