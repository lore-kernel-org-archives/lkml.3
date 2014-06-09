Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933542AbaFIJRh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:17:37 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58415 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754852AbaFIIvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:24 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 010/146] ACPI / video: Fix initial level validity test
Date: Mon,  9 Jun 2014 10:49:05 +0200
Message-Id: <e1e6a6a85c2a9b025e59ac428f553ab3ad881ef2.1402303820.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aaron Lu <aaron.lu@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 9efa5e50598c5568b0678bb411b239a0b6e9a328 upstream.

When testing if the firmware's initial value is valid, we should use
the corrected level value instead of the raw value returned from
firmware.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/acpi/video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 5708e44376fe..d2e069044a0f 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -836,7 +836,7 @@ acpi_video_init_brightness(struct acpi_video_device *device)
 		 * or an index). Set the backlight to max_level in this case.
 		 */
 		for (i = 2; i < br->count; i++)
-			if (level_old == br->levels[i])
+			if (level == br->levels[i])
 				break;
 		if (i == br->count || !level)
 			level = max_level;
-- 
1.9.3

