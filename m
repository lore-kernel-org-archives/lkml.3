Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836AbaKLDch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:32:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59364 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933096AbaKLBcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:32:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>, Jingoo Han <jg1.han@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 3.17 238/319] usb: Remove references to non-existent PLAT_S5P symbol
Date: Wed, 12 Nov 2014 10:16:16 +0900
Message-Id: <20141112011032.133927967@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sylwester Nawrocki <s.nawrocki@samsung.com>

commit cd6e245a2d061a8367e37aaece32cf3fc922de80 upstream.

The PLAT_S5P Kconfig symbol was removed in commit d78c16ccde96
("ARM: SAMSUNG: Remove remaining legacy code"). There are still
some references left, fix that by replacing them with ARCH_S5PV210.

Fixes: d78c16ccde96 ("ARM: SAMSUNG: Remove remaining legacy code")
Reported-by: Paul Bolle <pebolle@tiscali.nl>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -220,7 +220,7 @@ config USB_EHCI_SH
 
 config USB_EHCI_EXYNOS
        tristate "EHCI support for Samsung S5P/EXYNOS SoC Series"
-       depends on PLAT_S5P || ARCH_EXYNOS
+       depends on ARCH_S5PV210 || ARCH_EXYNOS
        help
 	Enable support for the Samsung Exynos SOC's on-chip EHCI controller.
 
@@ -527,7 +527,7 @@ config USB_OHCI_SH
 
 config USB_OHCI_EXYNOS
 	tristate "OHCI support for Samsung S5P/EXYNOS SoC Series"
-	depends on PLAT_S5P || ARCH_EXYNOS
+	depends on ARCH_S5PV210 || ARCH_EXYNOS
 	help
 	 Enable support for the Samsung Exynos SOC's on-chip OHCI controller.
 


