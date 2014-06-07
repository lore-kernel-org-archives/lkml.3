Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012AbaFGBhc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:37:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36047 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752619AbaFGBXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:37 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Guenter Roeck" <linux@roeck-us.net>,
        "Josef Gajdusek" <atx@atx.name>, "Jean Delvare" <jdelvare@suse.de>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.213583915@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 65/92] hwmon: (emc1403) fix inverted store_hyst()
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

commit 17c048fc4bd95efea208a1920f169547d8588f1f upstream.

Attempts to set the hysteresis value to a temperature below the target
limit fails with "write error: Numerical result out of range" due to
an inverted comparison.

Signed-off-by: Josef Gajdusek <atx@atx.name>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
[Guenter Roeck: Updated headline and description]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwmon/emc1403.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/emc1403.c
+++ b/drivers/hwmon/emc1403.c
@@ -159,7 +159,7 @@ static ssize_t store_hyst(struct device
 	if (retval < 0)
 		goto fail;
 
-	hyst = val - retval * 1000;
+	hyst = retval * 1000 - val;
 	hyst = DIV_ROUND_CLOSEST(hyst, 1000);
 	if (hyst < 0 || hyst > 255) {
 		retval = -ERANGE;

