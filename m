Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474AbaIZKPn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:15:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33029 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754914AbaIZJqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:22 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Roger Quadros <rogerq@ti.com>, Michael Welling <mwelling@emacinc.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 031/142] USB: fix build error with CONFIG_PM_RUNTIME disabled
Date: Fri, 26 Sep 2014 11:44:02 +0200
Message-Id: <a6c8b5b4fe09fe235aa7089caf7d4c000f26cd41.1411724723.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a9ef803d740bfadf5e505fbc57efa57692e27025 upstream.

commit bdd405d2a528 ("usb: hub: Prevent hub autosuspend if
usbcore.autosuspend is -1") causes a build error if CONFIG_PM_RUNTIME is
disabled.  Fix that by doing a simple #ifdef guard around it.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Cc: Roger Quadros <rogerq@ti.com>
Cc: Michael Welling <mwelling@emacinc.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/core/hub.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 156fe93fb3d9..721de375c543 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1708,8 +1708,10 @@ static int hub_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	 * - If user has indicated to prevent autosuspend by passing
 	 *   usbcore.autosuspend = -1 then keep autosuspend disabled.
 	 */
+#ifdef CONFIG_PM_RUNTIME
 	if (hdev->dev.power.autosuspend_delay >= 0)
 		pm_runtime_set_autosuspend_delay(&hdev->dev, 0);
+#endif
 
 	/*
 	 * Hubs have proper suspend/resume support, except for root hubs
-- 
2.1.0

