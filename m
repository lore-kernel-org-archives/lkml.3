Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbaIZK2D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:28:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33030 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754786AbaIZJqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:04 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Chen <peter.chen@freescale.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 025/142] usb: ehci: using wIndex + 1 for hub port
Date: Fri, 26 Sep 2014 11:43:56 +0200
Message-Id: <9c1421dce49baa6afc74bc845994d32786d9156c.1411724723.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Chen <peter.chen@freescale.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 5cbcc35e5bf0eae3c7494ce3efefffc9977827ae upstream.

The roothub's index per controller is from 0, but the hub port index per hub
is from 1, this patch fixes "can't find device at roohub" problem for connecting
test fixture at roohub when do USB-IF Embedded Host High-Speed Electrical Test.

This patch is for v3.12+.

Signed-off-by: Peter Chen <peter.chen@freescale.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/host/ehci-hub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index 1bb85bee2625..7ba861543d03 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -1241,7 +1241,7 @@ static int ehci_hub_control (
 			if (selector == EHSET_TEST_SINGLE_STEP_SET_FEATURE) {
 				spin_unlock_irqrestore(&ehci->lock, flags);
 				retval = ehset_single_step_set_feature(hcd,
-									wIndex);
+								wIndex + 1);
 				spin_lock_irqsave(&ehci->lock, flags);
 				break;
 			}
-- 
2.1.0

