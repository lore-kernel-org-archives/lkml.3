Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934387AbbA1Urt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:47:49 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:46226 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934266AbbA1Url (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:47:41 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Kukjin Kim <kgene@kernel.org>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 0/5] Add multiple GPIO and external clock to MMC pwrseq_simple
Date: Wed, 28 Jan 2015 11:10:14 +0100
Message-Id: <1422439819-29854-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ulf,

Many WLAN chips attached to an SDIO interface needs more than one GPIO
for their reset sequence and also need an external clock to be operational.

Since this is very common, this series extend the simple MMC power sequence
to support more than one reset GPIO and also an optional external clock.

The series depend on v4 "mmc: core: Add support for MMC power sequences":

http://comments.gmane.org/gmane.linux.kernel.mmc/30665

Javier Martinez Canillas (5):
  mmc: pwrseq: Document that simple sequence support more than one GPIO
  mmc: pwrseq_simple: Extend to support more pins
  mmc: pwrseq: Document optional clock for the simple power sequence
  mmc: pwrseq_simple: Add optional reference clock support
  ARM: dts: exynos5250-snow: Enable wifi power-on

 .../devicetree/bindings/mmc/mmc-pwrseq-simple.txt  | 10 ++-
 arch/arm/boot/dts/exynos5250-snow.dts              | 25 ++++++-
 drivers/mmc/core/pwrseq_simple.c                   | 85 ++++++++++++++++++----
 3 files changed, 103 insertions(+), 17 deletions(-)

Patch #1 extends the simple MMC power sequence DT binding to support more
than one GPIO and patch #2 adds the actual implementation.

In the same way, patch #3 and #4 extend the simple MMC power sequence DT
binding and pwrseq_simple driver to support an optional external clock.

Finally as an example, patch #5 adds support for the wifi chip in the
Exynos5250 Snow that is attached to a SDIO interface and needs all these.

Best regards,
Javier

