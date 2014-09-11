Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbaIKXvf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 19:51:35 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:61797 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085AbaIKXve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 19:51:34 -0400
From: Julien Grall <julien.grall@linaro.org>
To: xen-devel@lists.xenproject.org
Cc: linux-kernel@vger.kernel.org, Julien Grall <julien.grall@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, David Vrabel <david.vrabel@citrix.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] xen/hvc: Fix warning compilation when CONFIG_HVC_XEN_FRONTEND is not enabled
Date: Fri, 12 Sep 2014 00:50:59 +0100
Message-Id: <1410479459-20353-1-git-send-email-julien.grall@linaro.org>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below warning appears when the hvc xen driver is compiled without
CONFIG_HVC_XEN_FRONTEND not enabled:

drivers/tty/hvc/hvc_xen.c:333:12: warning: ‘xen_console_remove’ defined but not
used [-Wunused-function]
 static int xen_console_remove(struct xencons_info *info)
            ^

Move the #ifdef CONFIG_HVC_XEN_FRONTEND earlier to only compile
xen_console_remove, xen_cons_free, xen_cons_disconnect_backend when it's
necessary.

Signed-off-by: Julien Grall <julien.grall@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/tty/hvc/hvc_xen.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
index 931c72a..2fd51ac 100644
--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -306,6 +306,7 @@ void xen_console_resume(void)
 		rebind_evtchn_irq(info->evtchn, info->irq);
 }
 
+#ifdef CONFIG_HVC_XEN_FRONTEND
 static void xencons_disconnect_backend(struct xencons_info *info)
 {
 	if (info->irq > 0)
@@ -346,7 +347,6 @@ static int xen_console_remove(struct xencons_info *info)
 	return 0;
 }
 
-#ifdef CONFIG_HVC_XEN_FRONTEND
 static struct xenbus_driver xencons_driver;
 
 static int xencons_remove(struct xenbus_device *dev)
-- 
1.7.10.4

