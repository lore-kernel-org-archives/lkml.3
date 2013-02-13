Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab3BMHCH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 02:02:07 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:42442 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab3BMHCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 02:02:06 -0500
From: Alexandre Courbot <gnurou@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, gnurou@gmail.com
Subject: [PATCH 0/4] gpiolib: some fixup patches
Date: Wed, 13 Feb 2013 16:02:58 +0900
Message-Id: <1360738983-22436-1-git-send-email-gnurou@gmail.com>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This short series is a fixup to patch 6/9 of my previous series ("gpiolib: use 
descriptors internally"), which mainly addresses issues raised by Linus W. in 
this patch and a few other minor ones caught while proof-reading gpiolib.

First patch is the most significant. It mostly avoids oopses when passing an 
invalid GPIO to some functions. Also gpio_get/set_value*() now return 0 when 
given an invalid GPIO number instead of oopsing. I tend to think that's an 
improvement, but if it's not please let me know.

Ideally these patches should be melded into the above-mentioned patch since 
they were intended to become a new revision, but I leave that decision to 
Grant's discretion.

This patchset has been thoroughly tested on Tegra 2/Ventana with a GPIO 
backlight driver and the sysfs interface.

Alexandre Courbot (4):
  gpiolib: check descriptors validity before use
  gpiolib: use const parameters when possible
  gpiolib: move comment to right function
  gpiolib: rename local offset variables to "hwgpio"

 drivers/gpio/gpiolib.c | 165 ++++++++++++++++++++++++++-----------------------
 1 file changed, 87 insertions(+), 78 deletions(-)

-- 
1.8.1.3

