Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935243AbaKNL6t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 06:58:49 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:29913 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933262AbaKNL6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 06:58:47 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-c0-5465ee746c8c
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] ARM: exynos_defconfig: Use 16 minors per MMC block device
Date: Fri, 14 Nov 2014 12:58:37 +0100
Message-id: <1415966317-11170-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIJMWRmVeSWpSXmKPExsVy+t/xq7ol71JDDJa1WVtsnLGe1eL1C0OL
	3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2Rx+zKvxdojd9kdOD1amnvYPDYvqffo27KK0ePz
	JrkAligum5TUnMyy1CJ9uwSujHu77zIXXOOs+PpgE3MD42/2LkZODgkBE4muVTMZIWwxiQv3
	1rN1MXJxCAksZZRY+GsPO4TTxyTx40cLWAebgLHE5uVLwKpEBHYwSiy/dxmsilngKKPE9N63
	TF2MHBzCAl4Sq9eZgDSwCKhKfDn5gQ3E5hVwlzh7ch3UOjmJk8cms05g5F7AyLCKUTS1NLmg
	OCk910ivODG3uDQvXS85P3cTIyRYvu5gXHrM6hCjAAejEg+vRmZqiBBrYllxZe4hRgkOZiUR
	3u/PgUK8KYmVValF+fFFpTmpxYcYmTg4pRoYi6afVpf2U4udu+r02g91STebxeoqHGWmm8QH
	/pryY+KzYPHIM+0n+zuuJrXz3nxiy/8+9Je7acF3Y00lXbOo/XM6Oj68TlfgvO83LX6z8yMF
	jatHTl30fftF/L7KFRdhVWaPU15ue7idOF+5lUzZlaRpt/G797fDs2bOulqSc9PD6GaoQKeW
	EktxRqKhFnNRcSIAJqfZtPQBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

16 minors per MMC block device are required to boot Rinato (Gear 2)
board because up to 15 partitions are used.

With default 8 minors booting failed with:
[    1.329092] mmcblk0: mmc0:0001 F5X5MA 3.64 GiB
[    1.329448] mmcblk0boot0: mmc0:0001 F5X5MA partition 1 4.00 MiB
[    1.329627] mmcblk0boot1: mmc0:0001 F5X5MA partition 2 4.00 MiB
[    1.329808] mmcblk0rpmb: mmc0:0001 F5X5MA partition 3 512 KiB
[    1.335717]  mmcblk0: p1 p2 p3 p4 p5 p6 p7
[    1.436553] Waiting for root device /dev/mmcblk0p15...

while the correct list of partitions on mmcblk0 for Gear 2 is:
[    1.436651]  mmcblk0: p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11 p12 p13 p14 p15

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/configs/exynos_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/exynos_defconfig b/arch/arm/configs/exynos_defconfig
index 72058b8a6f4d..aa32931bdd30 100644
--- a/arch/arm/configs/exynos_defconfig
+++ b/arch/arm/configs/exynos_defconfig
@@ -134,6 +134,7 @@ CONFIG_USB_STORAGE=y
 CONFIG_USB_DWC3=y
 CONFIG_USB_HSIC_USB3503=y
 CONFIG_MMC=y
+CONFIG_MMC_BLOCK_MINORS=16
 CONFIG_MMC_SDHCI=y
 CONFIG_MMC_SDHCI_S3C=y
 CONFIG_MMC_SDHCI_S3C_DMA=y
-- 
1.9.1

