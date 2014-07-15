Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759704AbaGOXNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:13:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44907 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758155AbaGOXNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:13:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>, Axel Lin <axel.lin@ingics.com>
Subject: [PATCH 3.4 05/22] hwmon: (amc6821) Fix permissions for temp2_input
Date: Tue, 15 Jul 2014 16:17:10 -0700
Message-Id: <20140715231622.285894954@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231622.121816073@linuxfoundation.org>
References: <20140715231622.121816073@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit df86754b746e9a0ff6f863f690b1c01d408e3cdc upstream.

temp2_input should not be writable, fix it.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/amc6821.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/amc6821.c
+++ b/drivers/hwmon/amc6821.c
@@ -715,7 +715,7 @@ static SENSOR_DEVICE_ATTR(temp1_max_alar
 	get_temp_alarm, NULL, IDX_TEMP1_MAX);
 static SENSOR_DEVICE_ATTR(temp1_crit_alarm, S_IRUGO,
 	get_temp_alarm, NULL, IDX_TEMP1_CRIT);
-static SENSOR_DEVICE_ATTR(temp2_input, S_IRUGO | S_IWUSR,
+static SENSOR_DEVICE_ATTR(temp2_input, S_IRUGO,
 	get_temp, NULL, IDX_TEMP2_INPUT);
 static SENSOR_DEVICE_ATTR(temp2_min, S_IRUGO | S_IWUSR, get_temp,
 	set_temp, IDX_TEMP2_MIN);


