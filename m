Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759397Ab3EWVZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 17:25:22 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:50797 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758136Ab3EWVZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 17:25:21 -0400
MIME-Version: 1.0
Date: Thu, 23 May 2013 23:25:20 +0200
Message-ID: <CACRpkdaqGa0kF6A0=NxtwX7WM3JdLjy_L1Wo-EL59LiLPUrPKA@mail.gmail.com>
Subject: [GIT PULL] GPIO fixes for v3.10
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Axel Lin <axel.lin@ingics.com>, David Cohen <david.a.cohen@intel.com>,
        Jon Hunter <jon-hunter@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here are some GPIO fixes I've collected for the v3.10 series.
Detailed info in the signed tag.

It's all been in -next and it's all been build tested, yes.

Yours,
Linus Walleij


The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
tags/gpio-fixes-v3.10-1

for you to fetch changes up to cfb10898efe1bc1f3eb8d8f37f164d9e2ac8b43a:

  gpio: Don't override the error code in probe error handling
(2013-05-20 20:27:30 +0200)

----------------------------------------------------------------
GPIO fixes for the v3.10 series:
- An OMAP fix that makes ethernet work again.
- Fix for build problem when building the MCP23S08 driver
  as module.
- IRQ conflicts in the Langwell driver.
- Fix IRQ coherency issues in the MXS driver.
- Return correct errorcode on errorpath when removing
  GPIO chips.

----------------------------------------------------------------
Axel Lin (2):
      gpio: mcp23s08: Fix build error when CONFIG_SPI_MASTER=y && CONFIG_I2C=m
      gpio: Don't override the error code in probe error handling

David Cohen (1):
      gpio-langwell: fix irq conflicts when DT is not used

Jon Hunter (1):
      gpio/omap: ensure gpio context is initialised

Maxime Ripard (1):
      gpio: mxs: Use set and clear capabilities of the gpio controller

 drivers/gpio/Kconfig           |  2 +-
 drivers/gpio/gpio-langwell.c   | 17 +++++++++------
 drivers/gpio/gpio-ml-ioh.c     |  3 +--
 drivers/gpio/gpio-mxs.c        |  3 ++-
 drivers/gpio/gpio-omap.c       | 48 +++++++++++++++++++++++++++++++++++++++---
 drivers/gpio/gpio-pch.c        |  3 +--
 drivers/gpio/gpio-sch.c        |  6 ++----
 drivers/gpio/gpio-viperboard.c |  3 ++-
 8 files changed, 64 insertions(+), 21 deletions(-)
