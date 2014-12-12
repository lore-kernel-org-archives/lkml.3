Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaLLWHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 17:07:47 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:43328 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaLLWHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 17:07:45 -0500
From: Benoit Parrot <bparrot@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Alexandre Courbot <gnurou@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        Benoit Parrot <bparrot@ti.com>
Subject: [Patch v4 0/2] gpio: add GPIO hogging mechanism
Date: Fri, 12 Dec 2014 16:07:29 -0600
Message-ID: <1418422051-9471-1-git-send-email-bparrot@ti.com>
X-Mailer: git-send-email 1.8.5.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set re-introduces the gpio hogging concept first 
presented by Boris Brezillion.
This patch set provides a way to initally configure specific GPIO
when the gpio controller is probed.

The actual DT scanning to collect the GPIO specific data is performed
as part of the of_gpiochip_add().

The purpose of this is to allows specific GPIOs to be configured
without any driver specific code.
This particularly useful because board design are getting
increasingly complex and given SoC pins can now have upward
of 10 mux values a lot of connections are now dependent on
external IO muxes to switch various modes and combination.

Specific drivers should not necessarily need to be aware of
what accounts to a specific board implementation. This board level
"description" should be best kept as part of the dts file.

Changes since v3:
 * Relocated the non-DT "hog" function to gpiolib.c.
 * Rename some of the function to be clearer and remove _ prefixes.
 * Replace the gpiod_request/gpiod_put usage with
   gpiochip_request_own_desc/free_own_desc version instead.
 * Refactor some of the logic to better handle error condition/reporting
 * Renamed the "direction" DT properties to "state".

Changes since v2:
 * Refactor the gpio-hog mechanism to split the DT related action
   from the actual "hogging" operation.
 * This allows non-DT providers to implement hogs as well.
 * Added FLAG_IS_HOGGED to mark hogged gpio and make gpiochip removal
   able to release hogged gpio.
 * Similarly to the hogging, the cleanup is performed as part of
   of_gpiochip_remove

Changes since v1:
 * Split the devicetree bindings documentation in its own patch.
 * Refactor the gpio-hog mechanism as private functions meant to
   be to invoked from of_gpiochip_add().

Benoit Parrot (2):
  gpio: add GPIO hogging mechanism
  gpio: Document GPIO hogging mechanism

 Documentation/devicetree/bindings/gpio/gpio.txt |  23 +++++
 drivers/gpio/gpiolib-of.c                       | 119 ++++++++++++++++++++++
 drivers/gpio/gpiolib.c                          | 128 ++++++++++++++++++++----
 drivers/gpio/gpiolib.h                          |   3 +
 4 files changed, 253 insertions(+), 20 deletions(-)

-- 
1.8.5.1

