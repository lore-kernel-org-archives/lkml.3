Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab3JUIzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:55:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39909 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754637Ab3JUIxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:53:32 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Henrik Rydberg" <rydberg@euromail.se>,
        "Guenter Roeck" <guenter.roeck@ericsson.com>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.843886656@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 144/149] hwmon: (applesmc) Silence uninitialized warnings
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Henrik Rydberg <rydberg@euromail.se>

commit 0fc86eca1b338d06ec500b34ef7def79c32b602b upstream.

Some error paths do not set a result, leading to the (false)
assumption that the value may be used uninitialized. Set results for
those paths as well.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwmon/applesmc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 1b13085..f082e48 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -344,8 +344,10 @@ static int applesmc_get_lower_bound(unsigned int *lo, const char *key)
 	while (begin != end) {
 		int middle = begin + (end - begin) / 2;
 		entry = applesmc_get_entry_by_index(middle);
-		if (IS_ERR(entry))
+		if (IS_ERR(entry)) {
+			*lo = 0;
 			return PTR_ERR(entry);
+		}
 		if (strcmp(entry->key, key) < 0)
 			begin = middle + 1;
 		else
@@ -364,8 +366,10 @@ static int applesmc_get_upper_bound(unsigned int *hi, const char *key)
 	while (begin != end) {
 		int middle = begin + (end - begin) / 2;
 		entry = applesmc_get_entry_by_index(middle);
-		if (IS_ERR(entry))
+		if (IS_ERR(entry)) {
+			*hi = smcreg.key_count;
 			return PTR_ERR(entry);
+		}
 		if (strcmp(key, entry->key) < 0)
 			end = middle;
 		else

