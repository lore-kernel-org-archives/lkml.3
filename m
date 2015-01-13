Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788AbbAMMAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 07:00:24 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:49982 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbbAMMAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 07:00:22 -0500
From: Johan Hovold <johan@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 0/3] gpio: sysfs: fix attribute leaks and races
Date: Tue, 13 Jan 2015 13:00:03 +0100
Message-Id: <1421150406-20255-1-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are three more patches for 3.19 fixing some long-standing memory
leaks and races (with userspace) in the gpio sysfs-interface
implementation.

The memory leaks are marked for stable, but I'll need to backport them
to pre-3.18 kernels once they are upstream due to commit 0eb4c6c2671c
("gpio: move sysfs support to its own file").

I chose not to mark the final patch for stable as the attribute-creation
race with userspace (e.g. udev rule) is not as critical (and patch a bit
more invasive).

Please note that these patches will cause a conflict with 3511ee7b3312
("gpio: lib-sysfs: Add 'wakeup' attribute") in gpio/devel, which adds
yet another device attribute without ever removing it. Unless the commit
in question can be reverted, that leak could be fixed as part of the
merge resolution, I guess.

Johan


Johan Hovold (3):
  gpio: sysfs: fix gpio-chip device-attribute leak
  gpio: sysfs: fix gpio device-attribute leak
  gpio: sysfs: fix gpio attribute-creation race

 drivers/gpio/gpiolib-sysfs.c | 92 +++++++++++++++++++++++++-------------------
 drivers/gpio/gpiolib.h       |  1 +
 2 files changed, 53 insertions(+), 40 deletions(-)

-- 
2.0.5

