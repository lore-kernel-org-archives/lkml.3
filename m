Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbbALQM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:12:59 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:48126 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450AbbALQMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:12:46 -0500
From: Johan Hovold <johan@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 0/6] gpio: fix gpio_chip add and remove
Date: Mon, 12 Jan 2015 17:12:23 +0100
Message-Id: <1421079149-2236-1-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series fix a few issues with gpiochip_add and gpiochip_remove.

The gpio-chip removal paths have probably not been exercised much, and
there are further issues here that I'm working on fixing in order better
support hot-plugging of gpio chips. I believe these patches should go
into 3.19 meanwhile.

Johan


Johan Hovold (6):
  gpio: fix memory and reference leaks in gpiochip_add error path
  gpio: fix gpio-chip list corruption
  gpio: clean up gpiochip_add error handling
  gpio: fix memory leak and sleep-while-atomic
  gpio: fix sleep-while-atomic in gpiochip_remove
  gpio: unregister gpiochip device before removing it

 drivers/gpio/gpiolib.c | 58 ++++++++++++++++++++++++++------------------------
 1 file changed, 30 insertions(+), 28 deletions(-)

-- 
2.0.5

