Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965627Ab3GSFpY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:45:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39669 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965572Ab3GSF02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:26:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        George Cherian <george.cherian@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [ 16/72] usb: host: xhci-plat: release mem region while removing module
Date: Thu, 18 Jul 2013 22:25:33 -0700
Message-Id: <20130719052600.975461703@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052559.852627424@linuxfoundation.org>
References: <20130719052559.852627424@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Cherian <george.cherian@ti.com>

commit 5388a3a5faba8dfa69e5f06c3a415d373c1a4316 upstream.

Do a release_mem_region of the hcd resource. Without this the
subsequent insertion of module fails in request_mem_region.

Signed-off-by: George Cherian <george.cherian@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-plat.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -179,6 +179,7 @@ static int xhci_plat_remove(struct platf
 
 	usb_remove_hcd(hcd);
 	iounmap(hcd->regs);
+	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 	usb_put_hcd(hcd);
 	kfree(xhci);
 


