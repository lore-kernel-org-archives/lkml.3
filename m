Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933718AbaLCANp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 19:13:45 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:33488 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933506AbaLCAM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 19:12:26 -0500
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@linaro.org, kernel@pengutronix.de, linux@arm.linux.org.uk,
        u.kleine-koenig@pengutronix.de, jason@lakedaemon.net, olof@lixom.net,
        arnd@arndb.de, daniel.lezcano@linaro.org, tglx@linutronix.de,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stefan Agner <stefan@agner.ch>
Subject: [PATCH 12/12] ARM: vf610m4: add defconfig for Linux on Vybrids Cortex-M4
Date: Wed,  3 Dec 2014 01:12:11 +0100
Message-Id: <1417565531-4507-13-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417565531-4507-1-git-send-email-stefan@agner.ch>
References: <1417565531-4507-1-git-send-email-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add defconfig for Linux on Vybrid (vf610) on the secondary Cortex-
M4 CPU. The use of a XIP image has been tested which needs to be
loaded (e.g. using the custom m4boot loader) to the end of the
available RAM at address 0x8f000000. The Cortex-M4 has a code-alias
which makes sure that the instructions get fetched through the code
bus (alias starts at 0x00800000 => 0x80800000 in system address).
Hence, to get optimal performance, use 0x0f000000 as XIP_PHYS_ADDR.
This address is additionally shifted by the length of the minimal
loader which is inserted by m4boot. Currently, this offset is 0x80.

The standard DRAM base address is configured to 0x8C000000, which
gives the Cortex-M4 48MiB of RAM.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/configs/vf610m4_defconfig | 49 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)
 create mode 100644 arch/arm/configs/vf610m4_defconfig

diff --git a/arch/arm/configs/vf610m4_defconfig b/arch/arm/configs/vf610m4_defconfig
new file mode 100644
index 0000000..121908b
--- /dev/null
+++ b/arch/arm/configs/vf610m4_defconfig
@@ -0,0 +1,49 @@
+CONFIG_NAMESPACES=y
+CONFIG_BLK_DEV_INITRD=y
+CONFIG_RD_LZO=y
+# CONFIG_KALLSYMS is not set
+CONFIG_EMBEDDED=y
+# CONFIG_MMU is not set
+CONFIG_ARCH_MXCM4=y
+CONFIG_SOC_VF610M4=y
+# CONFIG_KUSER_HELPERS is not set
+CONFIG_SET_MEM_PARAM=y
+CONFIG_DRAM_BASE=0x8c000000
+CONFIG_FLASH_MEM_BASE=0x8f000000
+CONFIG_FLASH_SIZE=0x01000000
+CONFIG_CMDLINE="console=/dev/ttyLP0 earlyprintk"
+CONFIG_XIP_KERNEL=y
+CONFIG_XIP_PHYS_ADDR=0x0f000080
+CONFIG_BINFMT_FLAT=y
+CONFIG_BINFMT_ZFLAT=y
+CONFIG_BINFMT_SHARED_FLAT=y
+# CONFIG_SUSPEND is not set
+# CONFIG_UEVENT_HELPER is not set
+# CONFIG_STANDALONE is not set
+# CONFIG_PREVENT_FIRMWARE_BUILD is not set
+# CONFIG_FIRMWARE_IN_KERNEL is not set
+CONFIG_BLK_DEV_RAM=y
+CONFIG_BLK_DEV_RAM_COUNT=4
+CONFIG_BLK_DEV_XIP=y
+CONFIG_SRAM=y
+# CONFIG_INPUT_MOUSEDEV is not set
+# CONFIG_KEYBOARD_ATKBD is not set
+CONFIG_KEYBOARD_GPIO=y
+CONFIG_KEYBOARD_GPIO_POLLED=y
+# CONFIG_INPUT_MOUSE is not set
+# CONFIG_SERIO is not set
+CONFIG_SERIAL_FSL_LPUART=y
+CONFIG_SERIAL_FSL_LPUART_CONSOLE=y
+# CONFIG_HW_RANDOM is not set
+# CONFIG_HID is not set
+# CONFIG_USB_SUPPORT is not set
+CONFIG_MMC=y
+CONFIG_MMC_SDHCI=y
+CONFIG_MMC_SDHCI_PLTFM=y
+CONFIG_MMC_SDHCI_ESDHC_IMX=y
+# CONFIG_IOMMU_SUPPORT is not set
+CONFIG_EXT4_FS=y
+# CONFIG_MISC_FILESYSTEMS is not set
+CONFIG_DEBUG_MEMORY_INIT=y
+# CONFIG_FTRACE is not set
+# CONFIG_CRYPTO_HW is not set
-- 
2.1.3

