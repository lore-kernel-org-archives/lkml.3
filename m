Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbbAUVe1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 16:34:27 -0500
Received: from 7of9.schinagl.nl ([88.159.158.68]:39397 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbbAUVeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 16:34:17 -0500
From: Olliver Schinagl <o.schinagl@ultimaker.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Olliver Schinagl <oliver@schinagl.nl>,
        Robin Gong <b38343@freescale.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Grant Likely <grant.likely@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>, Alexander Shiyan <shc_work@mail.ru>,
        Wolfram Sang <wsa@the-dreams.de>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-leds@vger.kernel.org,
        Olliver Schinagl <o.schinagl@ultimaker.com>
Subject: [PATCH v2 0/4] Let leds use named gpios
Date: Wed, 21 Jan 2015 22:33:44 +0100
Message-Id: <1421876028-22799-1-git-send-email-o.schinagl@ultimaker.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gpio binding docs ask to use named-gpios wherever possible, however 40b73183 probably forgot that. This patch makes the new devm_get_gpiod_from_child use named gpios.

Changed since v1:
  Fix a few typo's
  Fix of_find_gpio to remove hardcoded length of string
  Check both for leds-gpios and if that fails, fall back to standard gpios for the users of devm_get_gpiod_from_child.

Olliver Schinagl (4):
  gpio: use sizeof() instead of hardcoded values
  gpio: add parameter to allow the use named gpios
  leds: Let the binding document example for leds-gpio follow the gpio
    bindings
  leds: no longer use unnamed gpios

 Documentation/devicetree/bindings/leds/leds-gpio.txt | 14 ++++++++------
 drivers/gpio/devres.c                                | 18 +++++++++++++++++-
 drivers/gpio/gpiolib.c                               |  6 ++++--
 drivers/input/keyboard/gpio_keys_polled.c            | 20 ++++++++++++--------
 drivers/leds/leds-gpio.c                             |  2 +-
 include/linux/gpio/consumer.h                        |  1 +
 6 files changed, 43 insertions(+), 18 deletions(-)

-- 
2.1.4

