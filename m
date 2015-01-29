Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbbA2PA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:00:26 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:47364 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbbA2PAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:00:24 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Kukjin Kim <kgene@kernel.org>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>, Arend van Spriel <arend@broadcom.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v3 0/6] Add multiple GPIO and external clock to MMC pwrseq_simple
Date: Thu, 29 Jan 2015 16:00:02 +0100
Message-Id: <1422543608-24704-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ulf,

Many WLAN chips attached to an SDIO interface needs more than one GPIO
for their reset sequence and also an external clock to be operational.

Since this is very common, this series extend the simple MMC power sequence
to support more than one reset GPIO and also an optional external clock.

This is the third version of the series that addressed issues pointed out
in the previous versions.

The series depend on v4 "mmc: core: Add support for MMC power sequences":

http://comments.gmane.org/gmane.linux.kernel.mmc/30665

Javier Martinez Canillas (6):
  mmc: pwrseq: Document that simple sequence support more than one GPIO
  mmc: pwrseq_simple: Extend to support more pins
  mmc: pwrseq: Document optional clock for the simple power sequence
  mmc: pwrseq_simple: Add optional reference clock support
  ARM: dts: exynos5250-snow: Enable wifi power-on
  ARM: dts: exynos5250-snow: Add cap-sdio-irq to wifi mmc node

 .../devicetree/bindings/mmc/mmc-pwrseq-simple.txt  | 11 ++-
 arch/arm/boot/dts/exynos5250-snow.dts              | 26 ++++++-
 drivers/mmc/core/pwrseq_simple.c                   | 89 ++++++++++++++++++----
 3 files changed, 107 insertions(+), 19 deletions(-)

Patch #1 extends the simple MMC power sequence DT binding to support more
than one GPIO and patch #2 adds the actual implementation.

In the same way, patch #3 and #4 extend the simple MMC power sequence DT
binding and pwrseq_simple driver to support an optional external clock.

Finally as an example, patch #5 and patch #6 adds support for the wifi
chip in the Exynos5250 Snow that needs all these resources. These two
patches were added to the series only for completeness and should be
picked by Kukjin through his linux-samsung tree.

Best regards,
Javier
