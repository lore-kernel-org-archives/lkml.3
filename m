Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799Ab3HMQcF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:32:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33381 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757895Ab3HMQ0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:26:51 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=WbYuzpYQ-wgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=AVwXypVGYmgA:10 a=sozttTNsAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=x2szoZtqnggA:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155834.686848615@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:58:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: George Cherian <george.cherian@ti.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [70/88] usb: host: xhci-plat: release mem region while removing module
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0070-usb-host-xhci-plat-release-mem-region-while-removing.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: George Cherian <george.cherian@ti.com>

[ Upstream commit 5388a3a5faba8dfa69e5f06c3a415d373c1a4316 ]

Do a release_mem_region of the hcd resource. Without this the
subsequent insertion of module fails in request_mem_region.

Signed-off-by: George Cherian <george.cherian@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
Cc: stable <stable@vger.kernel.org> # 3.4+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/host/xhci-plat.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index df90fe5..93ad67e 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -179,6 +179,7 @@ static int xhci_plat_remove(struct platform_device *dev)
 
 	usb_remove_hcd(hcd);
 	iounmap(hcd->regs);
+	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 	usb_put_hcd(hcd);
 	kfree(xhci);
 
-- 
1.7.10.4


