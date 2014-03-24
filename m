Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbaCXUdE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 16:33:04 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:34333 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138AbaCXUbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 16:31:44 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 5/5] PM / Runtime: s/foo_process_requests/foo_process_next_request/
Date: Mon, 24 Mar 2014 21:31:31 +0100
Message-Id: <1395693091-4813-5-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1395693091-4813-1-git-send-email-geert@linux-m68k.org>
References: <1395693091-4813-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

The example uses foo_process_next_request() everywhere else.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 Documentation/power/runtime_pm.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/power/runtime_pm.txt b/Documentation/power/runtime_pm.txt
index 0c1c4124d23a..5f96daf8566a 100644
--- a/Documentation/power/runtime_pm.txt
+++ b/Documentation/power/runtime_pm.txt
@@ -870,7 +870,7 @@ Here is a schematic pseudo-code example:
 		foo->is_suspended = 0;
 		pm_runtime_mark_last_busy(&foo->dev);
 		if (foo->num_pending_requests > 0)
-			foo_process_requests(foo);
+			foo_process_next_request(foo);
 		unlock(&foo->private_lock);
 		return 0;
 	}
-- 
1.7.9.5

