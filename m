Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758433AbaIOWUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:20:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51278 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758404AbaIOWUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:20:12 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Axel Lin <axel.lin@ingics.com>, Guenter Roeck <linux@roeck-us.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 122/187] hwmon: (lm78) Fix overflow problems seen when writing large temperature limits
Date: Mon, 15 Sep 2014 15:08:52 -0700
Message-Id: <1410818997-9432-123-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 1074d683a51f1aded3562add9ef313e75d557327 upstream.

On platforms with sizeof(int) < sizeof(long), writing a temperature
limit larger than MAXINT will result in unpredictable limit values
written to the chip. Avoid auto-conversion from long to int to fix
the problem.

Cc: Axel Lin <axel.lin@ingics.com>
Reviewed-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hwmon/lm78.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/lm78.c b/drivers/hwmon/lm78.c
index a2f3b4a..b879427 100644
--- a/drivers/hwmon/lm78.c
+++ b/drivers/hwmon/lm78.c
@@ -108,7 +108,7 @@ static inline int FAN_FROM_REG(u8 val, int div)
  * TEMP: mC (-128C to +127C)
  * REG: 1C/bit, two's complement
  */
-static inline s8 TEMP_TO_REG(int val)
+static inline s8 TEMP_TO_REG(long val)
 {
 	int nval = clamp_val(val, -128000, 127000) ;
 	return nval < 0 ? (nval - 500) / 1000 : (nval + 500) / 1000;
-- 
1.9.1

