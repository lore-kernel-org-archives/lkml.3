Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421AbaH1Mb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 08:31:56 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:49523 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaH1Mbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 08:31:55 -0400
MIME-Version: 1.0
Date: Thu, 28 Aug 2014 14:31:54 +0200
Message-ID: <CACRpkdbanpfcuy6Bui_aT15-BPRaAZ4WujbdTGy2rwYqxiMX8g@mail.gmail.com>
Subject: [GIT PULL] pin control fixes for the v3.17 series
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here is my first (a bit delayed) pack of pin control fixes, details
in the signed tag as usual.

Please pull it in!

Yours,
Linus Walleij


The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-v3.17-2

for you to fetch changes up to 0252d6a2ac2ad9961dace28e4c8c9abe6f2a0472:

  pinctrl: qcom: apq8064: Correct interrupts in example (2014-08-21
07:28:24 -0500)

----------------------------------------------------------------
Pin control fixes for the v3.17 series, only driver fixes:

- SH-PFC (Renesas) r8a7791 CAN bus pin group problem
- Rockchip (GPIO0 configuration)
- Tegra-xusb (interrupt handling)
- Exynos (GPIO interrupt locking)
- Qualcomm (fix misleading example interrupts)
- Minor non-critical fixes for abx500 and AT91 also sneaked in,
  because I initially intended this pull for post RC-1, hope it's
  still OK.

----------------------------------------------------------------
Bjorn Andersson (1):
      pinctrl: qcom: apq8064: Correct interrupts in example

Dan Carpenter (2):
      pinctrl: tegra-xusb: fix an off by one test
      pinctrl: tegra-xusb: testing wrong variable in probe()

Hans Wennborg (1):
      pinctrl: pinctrl-at91.c: fix decimal printf format specifiers
prefixed with 0x

Patrice CHOTARD (1):
      pinctrl: abx500: remove useless check

Sergei Shtylyov (1):
      sh-pfc: r8a7791: fix CAN pin groups

Sonny Rao (1):
      pinctrl: rockchip: fix rk3288 gpio0 configuration

Tomasz Figa (1):
      pinctrl: exynos: Lock GPIOs as interrupts when used as EINTs

 .../bindings/pinctrl/qcom,apq8064-pinctrl.txt      |  2 +-
 drivers/pinctrl/nomadik/pinctrl-abx500.c           |  3 +-
 drivers/pinctrl/pinctrl-at91.c                     |  4 +-
 drivers/pinctrl/pinctrl-rockchip.c                 | 15 +++--
 drivers/pinctrl/pinctrl-tegra-xusb.c               |  5 +-
 drivers/pinctrl/samsung/pinctrl-exynos.c           | 69 ++++++++++++++++++++--
 drivers/pinctrl/samsung/pinctrl-samsung.h          |  1 +
 drivers/pinctrl/sh-pfc/pfc-r8a7791.c               |  8 +--
 8 files changed, 84 insertions(+), 23 deletions(-)
