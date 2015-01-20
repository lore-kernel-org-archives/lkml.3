Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbbATKf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:35:56 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:60480 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbbATKfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:35:54 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Kukjin Kim <kgene@kernel.org>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Mike Turquette <mturquette@linaro.org>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Arun Kumar K <arun.kk@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tobias Jakobi <liquid.acid@gmx.net>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kevin Hilman <khilman@linaro.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 0/2] Add HDMI support for Exynos5420 platform
Date: Tue, 20 Jan 2015 11:35:25 +0100
Message-Id: <1421750127-22536-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This series adds HDMI support for Exynos5420/5422/5800 machines by adding a
node for the DISP1 power domain which is used by the HDMI and MIXER modules.

It also adds IDs for the attached devices parent and input clocks that are
used by the Exynos power domain driver to re-parent the devices input clocks
when the DISP1 power domain is powered off and on.

Thanks a lot to Joonyoung Shim and Krzysztof Kozlowski for point me in the
right direction.

The series is based on Marek Szyprowski's patch
'ARM: DTS: Exynos: convert to generic power domain bindings'
(http://www.spinics.net/lists/linux-samsung-soc/msg40584.html)

The patches were tested on an Exynos5420 Peach Pit and Exynos5800 Peach Pi
Chromebooks and an Exynos5422 Odroid XU3.

NOTE: There is an issue noticed with these patches and is that if the kconfig
CONFIG_DRM_EXYNOS_DP symbol is disabled and only CONFIG_DRM_EXYNOS_HDMI is
enabled, then disabling the framebuffer and enabling it again with:

# echo 0 > /sys/devices/platform/exynos-drm/graphics/fb0/blank                                                           
# echo 1 > /sys/devices/platform/exynos-drm/graphics/fb0/blank

makes the system to crash due the exynos_mixer driver needing clocks enabled
by the exynos_hdmi driver that are gated on hdmi_poweroff().

The same issue has been reported on other Exynos platforms so it's orthogonal
to this series and needs to be fixed for all platforms.

Javier Martinez Canillas (2):
  clk: exynos5420: Add IDs for clocks used in DISP1 power domain
  ARM: dts: Add DISP1 power domain for exynos5420

 arch/arm/boot/dts/exynos5420.dtsi      | 17 +++++++++++++++++
 drivers/clk/samsung/clk-exynos5420.c   | 23 ++++++++++++-----------
 include/dt-bindings/clock/exynos5420.h |  6 ++++++
 3 files changed, 35 insertions(+), 11 deletions(-)

Patches 1 and 2 depend on each other so they have to either be merged through
the same tree or patch 1 has to be merged through clock tree and create a topic
branch to be pulled by the linux-samsung tree.

Best regards,
Javier
