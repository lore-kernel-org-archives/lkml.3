Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407AbaKTXyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 18:54:54 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:38484 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756976AbaKTXyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 18:54:52 -0500
From: Benoit Parrot <bparrot@ti.com>
To: <linus.walleij@linaro.org>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Benoit Parrot <bparrot@ti.com>
Subject: [Patch v2 0/2] gpio: add GPIO hogging mechanism
Date: Thu, 20 Nov 2014 17:54:42 -0600
Message-ID: <1416527684-19017-1-git-send-email-bparrot@ti.com>
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
as part of the gpiochip_add().

The purpose of this is to allows specific GPIOs to be configured
without any driver specific code.
This particularly useful because board design are getting
increasingly complex and given SoC pins can now have upward
of 10 mux values a lot of connections are now dependent on
external IO muxes to switch various modes and combination.

Specific drivers should not necessarily need to be aware of
what accounts to a specific board implementation. This board level
"description" should be best kept as part of the dts file.

Changes since v1:
 * Split the devicetree bindings documentation in its own patch.
 * Refactor the gpio-hog mechanism as private functions meant to
   be to invoked from of_gpiochip_add().

Benoit Parrot (2):
  gpio: add GPIO hogging mechanism
  gpio: Document GPIO hogging mechanism

 Documentation/devicetree/bindings/gpio/gpio.txt |  25 ++++
 drivers/gpio/gpiolib-of.c                       | 188 ++++++++++++++++++++++++
 2 files changed, 213 insertions(+)

-- 
1.8.5.1

