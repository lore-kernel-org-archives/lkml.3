Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936159Ab3DKUve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:51:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4488 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935924Ab3DKUtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:36 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=5sl8XVbb5QYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=NgEsN6Y7OP0A:10 a=eh1Yez-EAAAA:8 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=sdsLm1MIxTpCfJA8-tQA:9 a=W6U7dDoXpqQA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202556.567267119@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dmitry Torokhov <dtor@vmware.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 063/171 ] USB: xhci - fix bit definitions for IMAN register
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0063-USB-xhci-fix-bit-definitions-for-IMAN-register.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dtor@vmware.com>

[ Upstream commit f8264340e694604863255cc0276491d17c402390 ]

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
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/host/xhci.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 53df4e7..7c75bfe 100644
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
1.7.10.4


