Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab3CONqB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:46:01 -0400
Received: from vsp-authed02.binero.net ([195.74.38.226]:32412 "HELO
	vsp-authed-02-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755187Ab3CONp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:45:59 -0400
From: Andreas Larsson <andreas@gaisler.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        software@gaisler.com
Subject: [PATCH v5 0/3]  gpio: Add device driver for GRGPIO cores and support custom accessors with gpio-generic
Date: Fri, 15 Mar 2013 14:45:37 +0100
Message-Id: <1363355140-28216-1-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Differences since v4:
- Split out changes to gpio-generic into patch 1
- Make the basic driver without any irq support into patch 2, so that
  things can be applied so far if more revisions needs to be done for
  the irq support parts.
- Change irq support to use irq domain and put it in patch 3

Signed-off-by: Andreas Larsson <andreas@gaisler.com>

Andreas Larsson (3):
  gpio: gpio-generic: Add 16 and 32 bit big endian byte order support
  gpio: grgpio: Add device driver for GRGPIO cores
  gpio: grgpio: Add irq support

 .../devicetree/bindings/gpio/gpio-grgpio.txt       |   29 ++
 drivers/gpio/Kconfig                               |    9 +
 drivers/gpio/Makefile                              |    1 +
 drivers/gpio/gpio-generic.c                        |   56 ++-
 drivers/gpio/gpio-grgpio.c                         |  489 ++++++++++++++++++++
 include/linux/basic_mmio_gpio.h                    |    1 +
 6 files changed, 576 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-grgpio.txt
 create mode 100644 drivers/gpio/gpio-grgpio.c

-- 
1.7.10.4

