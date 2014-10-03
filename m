Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760852AbaJCX7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:59:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45826 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756762AbaJCVx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:53:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Murat Ilsever <murat.ilsever@gmail.com>,
        Robert Coulson <rob.coulson@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3.16 255/357] hwmon: (ds1621) Update zbits after conversion rate change
Date: Fri,  3 Oct 2014 14:30:41 -0700
Message-Id: <20141003212941.165258141@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Coulson <rob.coulson@gmail.com>

commit 39c627a084475e8a690a4a9e7601410ca173ddd2 upstream.

After the conversion rate is changed, the zbits are not updated,
but should be, since they are used later in the set_temp function.

Fixes: a50d9a4d9ad3 ("hwmon: (ds1621) Fix temperature rounding operations")
Reported-by: Murat Ilsever <murat.ilsever@gmail.com>
Signed-off-by: Robert Coulson <rob.coulson@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/ds1621.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hwmon/ds1621.c
+++ b/drivers/hwmon/ds1621.c
@@ -309,6 +309,7 @@ static ssize_t set_convrate(struct devic
 	data->conf |= (resol << DS1621_REG_CONFIG_RESOL_SHIFT);
 	i2c_smbus_write_byte_data(client, DS1621_REG_CONF, data->conf);
 	data->update_interval = ds1721_convrates[resol];
+	data->zbits = 7 - resol;
 	mutex_unlock(&data->update_lock);
 
 	return count;


