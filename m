Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbaI3Vhd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:37:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60929 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718AbaI3VhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:37:25 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Chen <peter.chen@freescale.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 059/103] usb: ehci: using wIndex + 1 for hub port
Date: Tue, 30 Sep 2014 14:31:04 -0700
Message-Id: <1412112708-27356-60-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Chen <peter.chen@freescale.com>

commit 5cbcc35e5bf0eae3c7494ce3efefffc9977827ae upstream.

The roothub's index per controller is from 0, but the hub port index per hub
is from 1, this patch fixes "can't find device at roohub" problem for connecting
test fixture at roohub when do USB-IF Embedded Host High-Speed Electrical Test.

This patch is for v3.12+.

Signed-off-by: Peter Chen <peter.chen@freescale.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/ehci-hub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index 1bb85be..7ba8615 100644
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
1.9.1

