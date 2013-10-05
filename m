Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab3JESfq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 14:35:46 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:57282 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab3JESfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 14:35:44 -0400
MIME-Version: 1.0
Date: Sat, 5 Oct 2013 20:35:44 +0200
Message-ID: <CACRpkdZBzFTtoFHTiFS8HXXFy_6cmuMTTTv6C-VLubc64NgsQA@mail.gmail.com>
Subject: [GIT PULL] GPIO fixes for v3.12
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here are two GPIO fixes for v3.12, both dealing with setting up
IRQs properly on the OMAP for the device tree boot path.
The subject as such is pretty tricky and we're still discussing how
we want to handle this long-term, but this fix is widely ACKed
and tested.

In the absence of linux-next I've done some additional builds and
tests to make sure nothing is wrecked.

Please pull it in!

Yours,
Linus Walleij

The following changes since commit 272b98c6455f00884f0350f775c5342358ebb73f:

  Linux 3.12-rc1 (2013-09-16 16:17:51 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
tags/gpio-v3.12-2

for you to fetch changes up to fac7fa162a19100298d5d91359960037dc5bfca9:

  gpio/omap: auto-setup a GPIO when used as an IRQ (2013-10-01 13:16:02 +0200)

----------------------------------------------------------------
Fixes for the GPIO tree for v3.12:
- Two patches for the OMAP driver, dealing with setting up IRQs
  properly on the device tree boot path.

----------------------------------------------------------------
Javier Martinez Canillas (2):
      gpio/omap: maintain GPIO and IRQ usage separately
      gpio/omap: auto-setup a GPIO when used as an IRQ

 drivers/gpio/gpio-omap.c | 158 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 101 insertions(+), 57 deletions(-)
