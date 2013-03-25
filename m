Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321Ab3CYBbB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:31:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33954 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755960Ab3CYBPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:15:55 -0400
Message-Id: <20130325010530.792145638@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:06:30 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Dmitry Torokhov <dtor@vmware.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 066/104] USB: xhci - fix bit definitions for IMAN register
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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


