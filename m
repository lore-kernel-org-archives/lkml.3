Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757823Ab3FDRNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:13:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48280 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756718Ab3FDQ5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 12:57:16 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Rientjes <rientjes@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 19/75] usb, chipidea: fix link error when USB_EHCI_HCD is a module
Date: Tue,  4 Jun 2013 09:55:03 -0700
Message-Id: <1370364959-9475-20-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370364959-9475-1-git-send-email-kamal@canonical.com>
References: <1370364959-9475-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.2 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/chipidea/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/chipidea/Kconfig b/drivers/usb/chipidea/Kconfig
index 608a2ae..b2df442 100644
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
-- 
1.8.1.2

