Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933562Ab3BSS6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:58:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54521 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757977Ab3BSSyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:54:39 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 72/81] Revert "USB: Handle warm reset failure on empty port."
Date: Tue, 19 Feb 2013 15:49:35 -0300
Message-Id: <1361299784-8830-73-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>

This reverts commit ff88c5021f17139d961478e40372f6bb028321bc, which is a
cherry-pick of commit 65bdac5effd15d6af619b3b7218627ef4d84ed6a upstream.

As discussed on a recent thread on stable/lkml/etc. ("[regression]
external HDD in USB3 enclosure cannot be dynamically removed"), this
changed caused issues, and shall be reapplied later with the proper
fixes, once they go into Linus tree.

Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/core/hub.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index c9590c6..1e8b3bd 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2488,11 +2488,6 @@ static int hub_port_wait_reset(struct usb_hub *hub, int port1,
 				return 0;
 			}
 		} else {
-			if (!(portstatus & USB_PORT_STAT_CONNECTION) ||
-					hub_port_warm_reset_required(hub,
-						portstatus))
-				return -ENOTCONN;
-
 			return 0;
 		}
 
@@ -4537,14 +4532,9 @@ static void hub_events(void)
 			 * SS.Inactive state.
 			 */
 			if (hub_port_warm_reset_required(hub, portstatus)) {
-				int status;
-
 				dev_dbg(hub_dev, "warm reset port %d\n", i);
-				status = hub_port_reset(hub, i, NULL,
+				hub_port_reset(hub, i, NULL,
 						HUB_BH_RESET_TIME, true);
-				if (status < 0)
-					hub_port_disable(hub, i, 1);
-				connect_change = 0;
 			}
 
 			if (connect_change)
-- 
1.7.9.5

