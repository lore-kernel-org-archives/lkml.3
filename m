Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbaKQRnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 12:43:37 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:57211 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbaKQRng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 12:43:36 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>, Simon Glass <sjg@chromium.org>,
        Olof Johansson <olof@lixom.net>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 0/3] ARM: dts: Add spidev nodes for Exynos Chromebooks
Date: Mon, 17 Nov 2014 18:43:01 +0100
Message-Id: <1416246184-29071-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exynos Snow and Peach Pit/Pi Chromebooks have a serial dataflash that
is accessed through SPI. This series add spidev nodes in the Device
Tree source files so the flash can be accessed from user-space.

The series is composed of the following patches taken from the ChromeOS tree:

Doug Anderson (1):
  ARM: dts: Add spidev registration to exynos5250-snow

Javier Martinez Canillas (1):
  ARM: exynos_defconfig: Enable user mode SPI device support

Simon Glass (1):
  ARM: dts: Add SPI flash node for Peach boards

 arch/arm/boot/dts/exynos5250-snow.dts      | 20 ++++++++++++++++++++
 arch/arm/boot/dts/exynos5420-peach-pit.dts | 26 ++++++++++++++++++++++++++
 arch/arm/boot/dts/exynos5800-peach-pi.dts  | 26 ++++++++++++++++++++++++++
 arch/arm/configs/exynos_defconfig          |  1 +
 4 files changed, 73 insertions(+)

Patch #1 adds the spidev node for the Snow Chromebook, patch #2
adds the spidev node for Peach Chromebooks and peach #3 enables
support for the user mode SPI device driver.

The series were tested on Snow and Peach using:

$ flashrom -p linux_spi:dev=/dev/spidev1.0 --get-size
$ flashrom -p linux_spi:dev=/dev/spidev1.0 --flash-name

and verify that the flash can be accessed

$ set_gbb_flags 0x39

and verify that the GBB flags could be written.

Best regards,
Javier
