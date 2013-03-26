Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965155Ab3CZPXE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:23:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53888 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964913Ab3CZPW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:58 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dmitry Torokhov <dtor@vmware.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 080/150] USB: xhci - fix bit definitions for IMAN register
Date: Tue, 26 Mar 2013 15:19:39 +0000
Message-Id: <1364311249-14454-81-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dtor@vmware.com>

commit f8264340e694604863255cc0276491d17c402390 upstream.

According to XHCI specification (5.5.2.1) the IP is bit 0 and IE is bit 1
of IMAN register. Previously their definitions were reversed.

Even though there are no ill effects being observed from the swapped
definitions (because IMAN_IP is RW1C and in legacy PCI case we come in
with it already set to 1 so it was clearing itself even though we were
setting IMAN_IE instead of IMAN_IP), we should still correct the values.

This patch should be backported to kernels as old as 2.6.36, that
contain the commit 4e833c0b87a30798e67f06120cecebef6ee9644c "xhci: don't
re-enable IE constantly".

Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/host/xhci.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index b2a5527..b35bbbe 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -206,8 +206,8 @@ struct xhci_op_regs {
 /* bits 12:31 are reserved (and should be preserved on writes). */
 
 /* IMAN - Interrupt Management Register */
-#define IMAN_IP		(1 << 1)
-#define IMAN_IE		(1 << 0)
+#define IMAN_IE		(1 << 1)
+#define IMAN_IP		(1 << 0)
 
 /* USBSTS - USB status - status bitmasks */
 /* HC not running - set to 1 when run/stop bit is cleared. */
-- 
1.8.1.2

