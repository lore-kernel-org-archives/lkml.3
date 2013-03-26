Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366Ab3CZVo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 17:44:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:54142 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab3CZVo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 17:44:58 -0400
Message-ID: <515208D3.5000605@infradead.org>
Date: Tue, 26 Mar 2013 13:45:07 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xensource.com
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH] xen: fix fbdev frontend kconfig warning
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix kconfig dependency warning for XEN_FBDEV_FRONTEND:

warning: (XEN_FBDEV_FRONTEND) selects INPUT_XEN_KBDDEV_FRONTEND which has unmet direct dependencies (!UML && INPUT && INPUT_MISC && XEN)

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc:	Jeremy Fitzhardinge <jeremy@goop.org>
Cc:	xen-devel@lists.xensource.com
Cc:	virtualization@lists.linux-foundation.org
---
 drivers/video/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-39-rc4.orig/drivers/video/Kconfig
+++ lnx-39-rc4/drivers/video/Kconfig
@@ -2277,7 +2277,7 @@ config XEN_FBDEV_FRONTEND
 	select FB_SYS_IMAGEBLIT
 	select FB_SYS_FOPS
 	select FB_DEFERRED_IO
-	select INPUT_XEN_KBDDEV_FRONTEND
+	select INPUT_XEN_KBDDEV_FRONTEND if INPUT
 	select XEN_XENBUS_FRONTEND
 	default y
 	help
