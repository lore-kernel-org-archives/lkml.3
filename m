Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbaLEWsl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:48:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53990 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbaLEWqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:46:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Arnaud Ebalard <arno@natisbad.org>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3.17 099/122] hwmon: (g762) fix call to devm_hwmon_device_register_with_groups()
Date: Fri,  5 Dec 2014 14:44:33 -0800
Message-Id: <20141205223320.861744873@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaud Ebalard <arno@natisbad.org>

commit 6b19b66013cfe608d63f0dab38834bbaceb0217a upstream.

g762_remove() needs to first call hwmon_device_unregister() and then
g762_of_clock_disable(). For that reason, it is not possible to
convert it to devm_hwmon_device_register_with_groups() and the
the non device managed version must be used.

This is correctly stated in commit message for 398e16db6262 ("hwmon:
(g762) Convert to hwmon_device_register_with_groups") but the
associated changes do in fact introduce a call to the device managed
version of the function.

This patch fixes that typo by switching to the non devm_ version.

Fixes: 398e16db6262 ("hwmon: (g762) Convert to hwmon_device_register_with_groups")
Signed-off-by: Arnaud Ebalard <arno@natisbad.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/g762.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/hwmon/g762.c
+++ b/drivers/hwmon/g762.c
@@ -1084,10 +1084,8 @@ static int g762_probe(struct i2c_client
 	if (ret)
 		goto clock_dis;
 
-	data->hwmon_dev = devm_hwmon_device_register_with_groups(dev,
-								 client->name,
-								 data,
-								 g762_groups);
+	data->hwmon_dev = hwmon_device_register_with_groups(dev, client->name,
+							    data, g762_groups);
 	if (IS_ERR(data->hwmon_dev)) {
 		ret = PTR_ERR(data->hwmon_dev);
 		goto clock_dis;


