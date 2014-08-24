Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353AbaHXHUQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 03:20:16 -0400
Received: from mail-oi0-f43.google.com ([209.85.218.43]:64985 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaHXHUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 03:20:14 -0400
MIME-Version: 1.0
Date: Sun, 24 Aug 2014 09:20:13 +0200
Message-ID: <CACRpkdYvtj_W0bX0FRcs2c1DE9ORv-rA5JWUGkoHpRfi2zcmRQ@mail.gmail.com>
Subject: [GIT PULL] GPIO fixes for the v3.17 series
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here are some post-rc1 GPIO fixes I've collected, nothing
special apart from the Zynq fix which is for a new driver.
Please pull them in!

Yours,
Linus Walleij

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
tags/gpio-v3.17-2

for you to fetch changes up to 8117bd531501ec329e4c9ea96fb7f9d5504c82f5:

  gpio-lynxpoint: enable input sensing in resume (2014-08-21 07:44:57 -0500)

----------------------------------------------------------------
Fixes for the v3.17 series:

- A largeish fix for the IRQ handling in the new Zynq driver.
  The quite verbose commit message gives the exact details.
- Move some defines for gpiod flags outside an ifdef to make
  stub functions work again.
- Various minor fixes that we can accept for -rc1.

----------------------------------------------------------------
Julia Lawall (2):
      gpiolib: devres: use correct structure type name in sizeof
      gpio: delete unneeded test before of_node_put

Lars-Peter Clausen (1):
      gpio: zynq: Fix IRQ handlers

Linus Walleij (1):
      gpio: move GPIOD flags outside #ifdef

Markus Mayer (1):
      MAINTAINERS: Change maintainer for gpio-bcm-kona.c

Mathias Nyman (1):
      gpio-lynxpoint: enable input sensing in resume

 MAINTAINERS                   |  2 +-
 drivers/gpio/devres.c         |  2 +-
 drivers/gpio/gpio-lynxpoint.c | 18 ++++++++++++++++++
 drivers/gpio/gpio-zynq.c      | 36 ++++++++++++++++++++++++++++--------
 drivers/gpio/gpiolib-of.c     |  4 +---
 include/linux/gpio/consumer.h |  4 ++--
 6 files changed, 51 insertions(+), 15 deletions(-)
