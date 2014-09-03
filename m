Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934883AbaICXBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:01:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46333 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756928AbaICWZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:25:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Chen <peter.chen@freescale.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 3.16 114/125] usb: ehci: using wIndex + 1 for hub port
Date: Wed,  3 Sep 2014 15:07:51 -0700
Message-Id: <20140903220627.119526681@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/host/ehci-hub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -1230,7 +1230,7 @@ int ehci_hub_control(
 			if (selector == EHSET_TEST_SINGLE_STEP_SET_FEATURE) {
 				spin_unlock_irqrestore(&ehci->lock, flags);
 				retval = ehset_single_step_set_feature(hcd,
-									wIndex);
+								wIndex + 1);
 				spin_lock_irqsave(&ehci->lock, flags);
 				break;
 			}


