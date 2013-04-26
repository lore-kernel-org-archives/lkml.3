Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822Ab3DZUZF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 16:25:05 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:51515 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757442Ab3DZUZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 16:25:03 -0400
Date: Fri, 26 Apr 2013 13:25:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Alan Stern <stern@rowland.harvard.edu>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch for-3.8-rc8] usb, chipidea: fix link error when USB_EHCI_HCD
 is a module
Message-ID: <alpine.DEB.2.02.1304261323060.17754@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes link error when USB_EHCI_HCD=m and USB_CHIPIDEA_HOST=y:

	drivers/built-in.o: In function `ci_hdrc_host_init':
	drivers/usb/chipidea/host.c:104: undefined reference to `ehci_init_driver'

as a result of commit 09f6ffde2ece ("USB: EHCI: fix build error by making
ChipIdea host a normal EHCI driver").

Cc: stable@vger.kernel.org [v3.7+]
Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/usb/chipidea/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/chipidea/Kconfig b/drivers/usb/chipidea/Kconfig
--- a/drivers/usb/chipidea/Kconfig
+++ b/drivers/usb/chipidea/Kconfig
@@ -20,7 +20,7 @@ config USB_CHIPIDEA_UDC
 config USB_CHIPIDEA_HOST
 	bool "ChipIdea host controller"
 	depends on USB=y || USB=USB_CHIPIDEA
-	depends on USB_EHCI_HCD
+	depends on USB_EHCI_HCD=y
 	select USB_EHCI_ROOT_HUB_TT
 	help
 	  Say Y here to enable host controller functionality of the
