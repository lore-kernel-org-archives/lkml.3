Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbaIKMn5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:43:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51644 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755435AbaIKMeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:08 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Guenter Roeck" <linux@roeck-us.net>,
        "Axel Lin" <axel.lin@ingics.com>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.384398996@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 050/131] hwmon: (sis5595) Prevent overflow problem
 when writing large limits
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit cc336546ddca8c22de83720632431c16a5f9fe9a upstream.

On platforms with sizeof(int) < sizeof(long), writing a temperature
limit larger than MAXINT will result in unpredictable limit values
written to the chip. Avoid auto-conversion from long to int to fix
the problem.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwmon/sis5595.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/sis5595.c
+++ b/drivers/hwmon/sis5595.c
@@ -149,7 +149,7 @@ static inline int TEMP_FROM_REG(s8 val)
 {
 	return val * 830 + 52120;
 }
-static inline s8 TEMP_TO_REG(int val)
+static inline s8 TEMP_TO_REG(long val)
 {
 	int nval = SENSORS_LIMIT(val, -54120, 157530) ;
 	return nval<0 ? (nval-5212-415)/830 : (nval-5212+415)/830;

