Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab3E2QHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 12:07:53 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:37714 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab3E2QHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 12:07:45 -0400
MIME-Version: 1.0
Date: Wed, 29 May 2013 18:07:45 +0200
Message-ID: <CACRpkdYzh4ZzUw=2ByQB8qchTfh0jvhz0+iSFPJmYBuVQesDgQ@mail.gmail.com>
Subject: [GIT PULL] pinctrl fixes for v3.10, take three
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        Wei Yongjun <weiyj.lk@gmail.com>, Axel Lin <axel.lin@ingics.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here are some more pinctrl fixes for the v3.10 series.

I don't exactly like the size of the Samsung/Exynos stuff, but I suspect
a bit of it can be explained by some traction around this platform right now,
leading to higher evolutional pace and some stir due to that. With the ARM
Chromebook using it and all that.

Please pull it in!

Yours,
Linus Walleij


The following changes since commit e4aa937ec75df0eea0bee03bffa3303ad36c986b:

  Linux 3.10-rc3 (2013-05-26 16:00:47 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-fixes-v3.10-3

for you to fetch changes up to a386267a2ceea33d76fa2b7f1c2e72a858fcb68e:

  pinctrl: pinconf: take the right mutex (2013-05-27 15:53:32 +0200)

----------------------------------------------------------------
Pin control fixes for v3.10:
- Six patches fixing up the suspend/resume and wakeup
  handling of the Samsung and Exynos drivers.
- Errorpath fixes for four different drivers. All on
  the probe() errorpath.
- Make the debugfs code for pin config take the right
  mutex.

----------------------------------------------------------------
Axel Lin (1):
      pinctrl: Don't override the error code in probe error handling

Doug Anderson (1):
      pinctrl: samsung: fix suspend/resume functionality

Linus Walleij (1):
      pinctrl: pinconf: take the right mutex

Tomasz Figa (5):
      pinctrl: exynos: Add support for set_irq_wake of wake-up EINTs
      ARM: EXYNOS: Fix EINT wake-up mask configuration when pinctrl is used
      pinctrl: samsung: Add support for SoC-specific suspend/resume callbacks
      pinctrl: samsung: Allow per-bank SoC-specific private data
      pinctrl: exynos: Handle suspend/resume of GPIO EINT registers

Wei Yongjun (1):
      pinctrl: sunxi: fix error return code in sunxi_pinctrl_probe()

 arch/arm/mach-exynos/include/mach/pm-core.h |  14 ++-
 drivers/pinctrl/pinconf.c                   |   4 +-
 drivers/pinctrl/pinctrl-coh901.c            |   3 +-
 drivers/pinctrl/pinctrl-exynos.c            | 139 ++++++++++++++++++++++++-
 drivers/pinctrl/pinctrl-exynos.h            |   1 +
 drivers/pinctrl/pinctrl-samsung.c           | 154 ++++++++++++++++++++++++++++
 drivers/pinctrl/pinctrl-samsung.h           |   9 ++
 drivers/pinctrl/pinctrl-sunxi.c             |   7 +-
 drivers/pinctrl/vt8500/pinctrl-wmt.c        |   3 +-
 9 files changed, 323 insertions(+), 11 deletions(-)
