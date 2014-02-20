Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012AbaBUA32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:29:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45841 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbaBTXwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:52:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [PATCH 3.12 60/82] Revert "xhci: Avoid infinite loop when sg urb requires too many trbs"
Date: Thu, 20 Feb 2014 15:52:43 -0800
Message-Id: <20140220235021.288895267@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220235019.483734207@linuxfoundation.org>
References: <20140220235019.483734207@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 9cf00d91708221ff2d8a11143315f7ebab8d5da8 upstream.

This reverts commit d6c9ea9069af684358efedcaf2f2f687f51c58ee.

We are ripping out commit 35773dac5f862cb1c82ea151eba3e2f6de51ec3e "usb:
xhci: Link TRB must not occur within a USB payload burst" because it's a
hack that caused regressions in the usb-storage and userspace USB
drivers that use usbfs and libusb.  This commit attempted to fix the
issues with that patch.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-ring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2964,7 +2964,7 @@ static int prepare_ring(struct xhci_hcd
 			if (num_trbs >= TRBS_PER_SEGMENT) {
 				xhci_err(xhci, "Too many fragments %d, max %d\n",
 						num_trbs, TRBS_PER_SEGMENT - 1);
-				return -EINVAL;
+				return -ENOMEM;
 			}
 
 			nop_cmd = cpu_to_le32(TRB_TYPE(TRB_TR_NOOP) |


