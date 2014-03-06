Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902AbaCFCka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 21:40:30 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:33854 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757087AbaCFCjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 21:39:49 -0500
MIME-Version: 1.0
Date: Thu, 6 Mar 2014 10:39:49 +0800
Message-ID: <CACRpkdZZ8aeuz15FNZ5uzOwuhKs7ktatQd-XbTSDXtYZPPLUnQ@mail.gmail.com>
Subject: [GIT PULL] pin control fixes, take two
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

this is a set of pin control fixes I have collected over the last few days.
Some have rotated more than others in linux-next, but they were
rebased on v3.14-rc5 due to sloppy commit messages. I am quite
convinced that they are all good fixes that only hit this or that
individual driver and not the entire subsystem.

Please pull this in!

Yours,
Linus Walleij


The following changes since commit 0414855fdc4a40da05221fc6062cccbc0c30f169:

  Linux 3.14-rc5 (2014-03-02 18:56:16 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-v3.14-3

for you to fetch changes up to e291fd20ef0870ed527470ca9c2402ba6f44d31c:

  pinctrl: sirf: fix kernel panic in gpio_lock_as_irq (2014-03-05
17:11:47 +0800)

----------------------------------------------------------------
A set of pin control fixes for the v3.14 series:

- Fix chained interrupts, interrupt masking and register offset
  calculation for the sunxi driver.

- Make MSM a bool rather than a tristate to stop build problems
  to happen - chained interrupt controllers cannot currently be
  defined in modules.

- Fix a clock in the PFC driver.

- Fix a kernel panic in the sirf driver.

----------------------------------------------------------------
Barry Song (1):
      pinctrl: sirf: fix kernel panic in gpio_lock_as_irq

Chen-Yu Tsai (1):
      pinctrl: sunxi: use chained_irq_{enter, exit} for GIC compatibility

Hans de Goede (2):
      pinctrl: sunxi: Fix masking when setting irq type
      pinctrl: sunxi: Fix interrupt register offset calculation

Josh Cartwright (1):
      pinctrl: msm: make PINCTRL_MSM bool instead of tristate

Magnus Damm (1):
      pinctrl: sh-pfc: r8a7791: SD1_CLK fix

 drivers/pinctrl/Kconfig              | 2 +-
 drivers/pinctrl/pinctrl-sunxi.c      | 6 +++++-
 drivers/pinctrl/pinctrl-sunxi.h      | 6 +++---
 drivers/pinctrl/sh-pfc/pfc-r8a7791.c | 6 ++++--
 drivers/pinctrl/sirf/pinctrl-sirf.c  | 4 ++--
 5 files changed, 15 insertions(+), 9 deletions(-)
