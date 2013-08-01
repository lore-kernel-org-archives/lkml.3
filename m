Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab3HAJDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 05:03:46 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:65133 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab3HAJDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 05:03:44 -0400
MIME-Version: 1.0
Date: Thu, 1 Aug 2013 11:03:43 +0200
Message-ID: <CACRpkdbcp1VtcXTgOoqOJ0dSzqkpxnKxUXny3mcOWp0xd2t1zg@mail.gmail.com>
Subject: [GIT PULL] GPIO fixes for v3.11
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Stephen Boyd <sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here is yet another GPIO pull request, fixing the fix from the last
one. It turns out that fixing the boot path for device tree boots on
OMAP breaks out antique systems (such as OMAP1) and we
need to find a better way. So we're reverting that "fix" for the moment
and thinking about something better.

Also fixing a build issue on the MSM driver.

Please pull it in.

Yours,
Linus Walleij

The following changes since commit 5ae90d8e467e625e447000cb4335c4db973b1095:

  Linux 3.11-rc3 (2013-07-28 20:53:33 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
tags/gpio-for-v3.11-3

for you to fetch changes up to 011b2039dfd46fa030138b2e2ed3c55c8341151d:

  gpio_msm: Fix build error due to missing err.h (2013-07-31 00:34:31 +0200)

----------------------------------------------------------------
GPIO fixes for v3.11:
- Revert the OMAP fixes that caused more problems than they solved.
- Fix a build error.

----------------------------------------------------------------
Linus Walleij (3):
      Revert "gpio/omap: fix build error when OF_GPIO is not defined."
      Revert "gpio/omap: auto request GPIO as input if used as IRQ via DT"
      Revert "gpio/omap: don't create an IRQ mapping for every GPIO on DT"

Stephen Boyd (1):
      gpio_msm: Fix build error due to missing err.h

 drivers/gpio/gpio-msm-v1.c |  1 +
 drivers/gpio/gpio-omap.c   | 84 ++++++++--------------------------------------
 2 files changed, 15 insertions(+), 70 deletions(-)
