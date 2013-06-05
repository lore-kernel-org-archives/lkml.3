Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543Ab3FEWHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 18:07:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37660 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757917Ab3FEVfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:35:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Rientjes <rientjes@google.com>
Subject: [ 020/127] usb, chipidea: fix link error when USB_EHCI_HCD is a module
Date: Wed,  5 Jun 2013 14:33:07 -0700
Message-Id: <20130605213220.319083322@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Rientjes <rientjes@google.com>

commit 7c8bfed7aaeba690de30835fe89882e1047a55fd upstream.

Fixes link error when USB_EHCI_HCD=m and USB_CHIPIDEA_HOST=y:

	drivers/built-in.o: In function `ci_hdrc_host_init':
	drivers/usb/chipidea/host.c:104: undefined reference to `ehci_init_driver'

as a result of commit 09f6ffde2ece ("USB: EHCI: fix build error by making
ChipIdea host a normal EHCI driver").

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/chipidea/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


