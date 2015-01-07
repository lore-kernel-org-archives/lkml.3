Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395AbbAGJJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 04:09:16 -0500
Received: from 7of9.schinagl.nl ([88.159.158.68]:42970 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158AbbAGJJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 04:09:08 -0500
From: Olliver Schinagl <oliver+list@schinagl.nl>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Cc: Olliver Schinagl <oliver@schinagl.nl>, Robin Gong <b38343@freescale.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Alexander Shiyan <shc_work@mail.ru>,
        Jingoo Han <jg1.han@samsung.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        Olliver Schinagl <o.schinagl@ultimaker.com>
Subject: [PATCH v1 0/4] Let leds use named gpios
Date: Wed,  7 Jan 2015 10:08:38 +0100
Message-Id: <1420621722-7428-1-git-send-email-oliver+list@schinagl.nl>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olliver Schinagl <o.schinagl@ultimaker.com>

The gpio binding docs ask to use named-gpios wherever possible, however 40b73183 probably forgot that. This patch makes the new devm_get_gpiod_from_child use named gpios.

Olliver Schinagl (4):
  gpio:gpiolib: use static const char const * for a suffixes array
  gpio: add parameter to allow the use named gpios
  leds: Let the binding document example for leds-gpio follow the gpio
    bindings
  leds: no longer use unnamed gpios

 Documentation/devicetree/bindings/leds/leds-gpio.txt | 14 ++++++++------
 drivers/gpio/devres.c                                | 16 +++++++++++++++-
 drivers/gpio/gpiolib.c                               |  2 +-
 drivers/input/keyboard/gpio_keys_polled.c            |  2 +-
 drivers/leds/leds-gpio.c                             |  2 +-
 include/linux/gpio/consumer.h                        |  1 +
 6 files changed, 27 insertions(+), 10 deletions(-)

-- 
2.1.4

