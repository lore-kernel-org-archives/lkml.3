Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbaJGJM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 05:12:26 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:55902 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbaJGJMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 05:12:22 -0400
X-AuditID: cbfee61b-f79d76d0000024d6-ab-5433ae7492eb
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        pebolle@tiscali.nl, jg1.han@samsung.com,
        linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v3] usb: Remove references to non-existent PLAT_S5P symbol
Date: Tue, 07 Oct 2014 11:12:07 +0200
Message-id: <1412673127-11479-1-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t9jQd2SdcYhBstPC1k0L17PZnF54SVW
	i8u75rBZzDi/j8li0bJWZotFt84wWxx+087qwO6xf+4ado++LasYPTZuf8Lk8XmTXABLFJdN
	SmpOZllqkb5dAlfGjHudTAXvuCounvvL1sD4jqOLkZNDQsBE4vezVlYIW0ziwr31bF2MXBxC
	AtMZJX6c/wiWEBLoYJJYetQFxGYTMJToPdrHCGKLCMhJPLn9hxmkgVlgB6PEys7ZLCAJYQEv
	icsHWsCKWARUJf6uOs4OYvMKuEm0vDkCVMMBtE1BYs4kmwmM3AsYGVYxiqYWJBcUJ6XnGukV
	J+YWl+al6yXn525iBIfGM+kdjKsaLA4xCnAwKvHwrtAyDhFiTSwrrsw9xCjBwawkwntwFVCI
	NyWxsiq1KD++qDQntfgQozQHi5I478FW60AhgfTEktTs1NSC1CKYLBMHp1QD48RI9tuNpyfP
	DWCfGO/nJFd925m1JulW16sVE4P8+r9ZyF3Z3NQgmvaS8S5nubN0RcrPB6ukebXKrntyW57y
	WGfHNn/lP5u/P75ev5fyOspUcDO/U/KLX7O3rYqfy8zI9+e50oLNh8LORqvVPpcpq/nd4BEq
	UM7wWJJ9olZNa9DbdTv3XeNSV2Ipzkg01GIuKk4EADIB+ZIJAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PLAT_S5P Kconfig symbol was removed in commit d78c16ccde96
("ARM: SAMSUNG: Remove remaining legacy code"). There are still
some references left, fix that by replacing them with ARCH_S5PV210.

Fixes: d78c16ccde96 ("ARM: SAMSUNG: Remove remaining legacy code")
Reported-by: Paul Bolle <pebolle@tiscali.nl>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Cc: <stable@vger.kernel.org>	[3.17+]
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
Changes since v2:
 - updated the commit description.

 drivers/usb/host/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 82800a7..6f1d48e 100644
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

--
1.7.9.5

