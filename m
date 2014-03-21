Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760504AbaCUADz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:03:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36601 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760484AbaCUADv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:03:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jean Delvare <jdelvare@suse.de>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3.13 064/149] x86_pkg_temp_thermal: Do not expose as a hwmon device
Date: Thu, 20 Mar 2014 17:03:47 -0700
Message-Id: <20140321000439.179302053@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean Delvare <jdelvare@suse.de>

commit 79786880a47a8c5b4c8146c03432b3387a07a169 upstream.

The temperature value reported by x86_pkg_temp_thermal is already
reported by the coretemp driver. So, do not expose this thermal zone
as a hwmon device, because it would be redundant.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>
Acked-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/thermal/x86_pkg_temp_thermal.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/thermal/x86_pkg_temp_thermal.c
+++ b/drivers/thermal/x86_pkg_temp_thermal.c
@@ -68,6 +68,10 @@ struct phy_dev_entry {
 	struct thermal_zone_device *tzone;
 };
 
+static const struct thermal_zone_params pkg_temp_tz_params = {
+	.no_hwmon	= true,
+};
+
 /* List maintaining number of package instances */
 static LIST_HEAD(phy_dev_list);
 static DEFINE_MUTEX(phy_dev_list_mutex);
@@ -446,7 +450,7 @@ static int pkg_temp_thermal_device_add(u
 			thres_count,
 			(thres_count == MAX_NUMBER_OF_TRIPS) ?
 				0x03 : 0x01,
-			phy_dev_entry, &tzone_ops, NULL, 0, 0);
+			phy_dev_entry, &tzone_ops, &pkg_temp_tz_params, 0, 0);
 	if (IS_ERR(phy_dev_entry->tzone)) {
 		err = PTR_ERR(phy_dev_entry->tzone);
 		goto err_ret_free;


