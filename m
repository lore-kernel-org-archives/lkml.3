Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbaCYMwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 08:52:30 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:58618 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbaCYMw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 08:52:29 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-gpio@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Cc: Alexandre Courbot <acourbot@nvidia.com>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 0/4] provide irqchip in gpiolib
Date: Tue, 25 Mar 2014 13:51:30 +0100
Message-Id: <1395751894-7110-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series provides a central facility for registering a chained
(cascaded) irqchip as a sibling to a certain gpiochip. Patch one
adds the API, patch 2, 3, 4 convert three drivers that I can test
to use this facility.

Linus Walleij (4):
  gpio: add IRQ chip helpers in gpiolib
  gpio: pl061: convert driver to use gpiolib irqchip
  pinctrl: nomadik: convert driver to use gpiolib irqchip
  pinctrl: coh901: convert driver to use gpiolib irqchip

 drivers/gpio/Kconfig              |   4 +
 drivers/gpio/gpio-pl061.c         |  80 ++++-----------
 drivers/gpio/gpiolib.c            | 188 +++++++++++++++++++++++++++++++++++
 drivers/pinctrl/Kconfig           |   4 +
 drivers/pinctrl/pinctrl-coh901.c  | 204 ++++++++++----------------------------
 drivers/pinctrl/pinctrl-nomadik.c | 123 ++++++-----------------
 include/linux/gpio/driver.h       |  29 ++++++
 7 files changed, 329 insertions(+), 303 deletions(-)

-- 
1.8.5.3

