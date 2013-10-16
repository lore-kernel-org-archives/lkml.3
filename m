Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760170Ab3JPIX0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 04:23:26 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:37445 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab3JPIXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 04:23:23 -0400
MIME-Version: 1.0
Date: Wed, 16 Oct 2013 10:23:22 +0200
Message-ID: <CACRpkdbuCmvwWhs-m3bfY9=suVvyWDwzd3Wm8Rafg6-z9taQwg@mail.gmail.com>
Subject: [GIT PULL] late GPIO fixes for v3.12
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here are three late GPIO fixes for the v3.12 series. It fixes two issues with
internal refactoring of the subsystem to preserve external semantics, and
a common bug in the Lynxpoint driver.

In the absence of linux-next I'm using some extended local build tests
and the kernelorg autobuilder to get some confidence in the soundness
of these patch stacks. All patches reside inside the subsystem.

Please pull them in!

Yours,
Linus Walleij


The following changes since commit d0e639c9e06d44e713170031fe05fb60ebe680af:

  Linux 3.12-rc4 (2013-10-06 14:00:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
tags/gpio-v3.12-3

for you to fetch changes up to 0204df470d6db830f0f2f5654ec582be84d81588:

  gpiolib: let gpiod_request() return -EPROBE_DEFER (2013-10-11 16:31:54 +0200)

----------------------------------------------------------------
Three GPIO fixes for the v3.12 series:
- A fix to the Lynxpoint IRQ handler
- Two late fixes to fallout from the gpiod refactoring

----------------------------------------------------------------
Alexandre Courbot (2):
      gpiolib: safer implementation of desc_to_gpio()
      gpiolib: let gpiod_request() return -EPROBE_DEFER

Mika Westerberg (1):
      gpio/lynxpoint: check if the interrupt is enabled in IRQ handler

 drivers/gpio/gpio-lynxpoint.c | 5 +++--
 drivers/gpio/gpiolib.c        | 6 ++++--
 2 files changed, 7 insertions(+), 4 deletions(-)
