Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbaJFPrZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 11:47:25 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:55524 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbaJFPrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 11:47:23 -0400
X-AuditID: cbfee61b-f79d76d0000024d6-01-5432b98a7056
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        pebolle@tiscali.nl, jg1.han@samsung.com,
        linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] usb: Remove references to non-existent PLAT_S5P symbol
Date: Mon, 06 Oct 2014 17:47:10 +0200
Message-id: <1412610430-8647-1-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOJMWRmVeSWpSXmKPExsVy+t9jAd2unUYhBk0HOC2aF69ns7i88BKr
	xeVdc9gsZpzfx2SxaFkrs8WiW2eYLQ6/aWd1YPfYP3cNu0ffllWMHhu3P2Hy+LxJLoAlissm
	JTUnsyy1SN8ugStj4uHLjAVLOCuerH7I2sC4j72LkZNDQsBEYuH2NVC2mMSFe+vZuhi5OIQE
	FjFKLNs1mwXC6WCS2LZ/NStIFZuAoUTv0T5GEFtEQE7iye0/zCBFzAI7GCVWdoJ0cHIIC7hL
	HH42C8xmEVCVOD33GJjNK+Aq8fTtU6BmDqB1ChJzJtlMYORewMiwilE0tSC5oDgpPddIrzgx
	t7g0L10vOT93EyM4OJ5J72Bc1WBxiFGAg1GJhzdih2GIEGtiWXFl7iFGCQ5mJRFe83lGIUK8
	KYmVValF+fFFpTmpxYcYpTlYlMR5D7ZaBwoJpCeWpGanphakFsFkmTg4pRoYu9tu3T7f5zYj
	LyYmqrb5e+Tcw+aSFzf9rU7iV1rBZLxr85Jil0/HDxo0vo9dffnX/2tXc2ZblctuPzEpIY3/
	2NWZkpP/ttUu7Jq5WEcnabbDY44He36kTlmuujg8/W9Y+4rZK07aNJzdnu9Qoit+KE18BtPn
	TbsyI6I/PO/2PmK846bTuU1ipUosxRmJhlrMRcWJAAIxCaEKAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PLAT_S5P Kconfig symbol was removed in commit d78c16ccde96
("ARM: SAMSUNG: Remove remaining legacy code"). There are still
some references left, fix that by replacing them with ARCH_S5PV210.

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
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

