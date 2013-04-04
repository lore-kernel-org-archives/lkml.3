Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763216Ab3DDVEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 17:04:08 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:35219 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762445Ab3DDVEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 17:04:06 -0400
From: Julius Werner <jwerner@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Julius Werner <jwerner@chromium.org>
Subject: [PATCH] usb: xhci-dbg: Display endpoint number and direction in context dump
Date: Thu,  4 Apr 2013 14:03:04 -0700
Message-Id: <1365109384-5333-1-git-send-email-jwerner@chromium.org>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_XHCI_HCD_DEBUGGING is activated, the XHCI driver can dump
device and input contexts to the console. The endpoint contexts in that
dump are labeled "Endpoint N Context", where N is DCI - 1... this is
very confusing, especially for people who are not that familiar with
the XHCI specification. Let's change this to display the endpoint number
and direction, which are much more commonly used concepts in USB (and
map to XHCI DCIs 1-to-1).

Signed-off-by: Julius Werner <jwerner@chromium.org>
---
 drivers/usb/host/xhci-dbg.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-dbg.c b/drivers/usb/host/xhci-dbg.c
index 5f3a7c7..98b1bee 100644
--- a/drivers/usb/host/xhci-dbg.c
+++ b/drivers/usb/host/xhci-dbg.c
@@ -507,7 +507,8 @@ static void xhci_dbg_ep_ctx(struct xhci_hcd *xhci,
 		dma_addr_t dma = ctx->dma +
 			((unsigned long)ep_ctx - (unsigned long)ctx->bytes);
 
-		xhci_dbg(xhci, "Endpoint %02d Context:\n", i);
+		xhci_dbg(xhci, "Endpoint %02d %s Context:\n",
+				DIV_ROUND_UP(i, 2), i % 2 ? "OUT" : "IN");
 		xhci_dbg(xhci, "@%p (virt) @%08llx (dma) %#08x - ep_info\n",
 				&ep_ctx->ep_info,
 				(unsigned long long)dma, ep_ctx->ep_info);
-- 
1.8.1.3

