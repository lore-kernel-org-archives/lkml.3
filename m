Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbaCXUbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 16:31:45 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:34333 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623AbaCXUbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 16:31:43 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 1/5] PM / Runtime: dev_pm_info.runtime_error is signed
Date: Mon, 24 Mar 2014 21:31:27 +0100
Message-Id: <1395693091-4813-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

dev_pm_info.runtime_error has always been a signed int, to store a signed
error code. Correct the documentation.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 Documentation/power/runtime_pm.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/power/runtime_pm.txt b/Documentation/power/runtime_pm.txt
index b6ce00b2be9a..a5683a5662cb 100644
--- a/Documentation/power/runtime_pm.txt
+++ b/Documentation/power/runtime_pm.txt
@@ -232,7 +232,7 @@ defined in include/linux/pm.h:
       equal to zero); the initial value of it is 1 (i.e. runtime PM is
       initially disabled for all devices)
 
-  unsigned int runtime_error;
+  int runtime_error;
     - if set, there was a fatal error (one of the callbacks returned error code
       as described in Section 2), so the helper funtions will not work until
       this flag is cleared; this is the error code returned by the failing
-- 
1.7.9.5

