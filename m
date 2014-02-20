Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbaBTXyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 18:54:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46261 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046AbaBTXyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:54:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [PATCH 3.13 76/99] Revert "xhci: Avoid infinite loop when sg urb requires too many trbs"
Date: Thu, 20 Feb 2014 15:53:11 -0800
Message-Id: <20140220235120.407579896@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220235118.191692546@linuxfoundation.org>
References: <20140220235118.191692546@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3008,7 +3008,7 @@ static int prepare_ring(struct xhci_hcd
 			if (num_trbs >= TRBS_PER_SEGMENT) {
 				xhci_err(xhci, "Too many fragments %d, max %d\n",
 						num_trbs, TRBS_PER_SEGMENT - 1);
-				return -EINVAL;
+				return -ENOMEM;
 			}
 
 			nop_cmd = cpu_to_le32(TRB_TYPE(TRB_TR_NOOP) |


