Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757697Ab3BBOmE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 09:42:04 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:52352 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab3BBOmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 09:42:00 -0500
From: Alexandre Courbot <acourbot@nvidia.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Dirk Opfer <dirk@opfer-online.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 0/2] gpiolib: remove gpiochip_reserve()
Date: Sat,  2 Feb 2013 23:44:04 +0900
Message-Id: <1359816246-3979-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Tosa (Sharp SL-C6000x) target is the last remaining user of
gpiochip_reserve(). I would like to get rid of this function as part of my
project to totally remove the big static gpio_desc[] array of gpiolib. Patches
that achieve this are written and working, but the presence of
gpiochip_reserve() makes it necessary to maintain a list of "reserved" ranges
in the GPIO space, which complexifies code that would be much simpler
otherwise.

Even for Tosa the use of gpiochip_reserve() does not seem necessary - all GPIO
controllers have their own base GPIO set AFAICT, so there should be no need to
use it. And without any user in the kernel, there should be no reason to keep
this function.

If Dmitri could give his Acked-by or Tested-by and one of the GPIO maintainers
merge this series, I could go ahead with the deeper changes to gpiolib.

Thanks,

Alexandre Courbot (2):
  arm: pxa: tosa: do not use gpiochip_reserve()
  gpiolib: remove gpiochip_reserve()

 arch/arm/mach-pxa/tosa.c   |  6 -----
 drivers/gpio/gpiolib.c     | 58 +++++++---------------------------------------
 include/asm-generic/gpio.h |  1 -
 3 files changed, 8 insertions(+), 57 deletions(-)

-- 
1.8.1.1

