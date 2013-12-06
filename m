Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab3LFCKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 21:10:19 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:18915 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754780Ab3LFCKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 21:10:11 -0500
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v2 0/3] pinctrl: Qualcomm 8x74 pinctrl driver
Date: Thu, 5 Dec 2013 18:10:02 -0800
Message-ID: <1386295805-13708-1-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds a pinctrl, pinmux, pinconf and gpiolib driver for the
Qualcomm TLMM block found in recent Qualcomm SoCs (8x60 and newer).
It designed with both v2 and v3 of the block in mind and comes with initial
definitions for the 8x74 SoCs.
This should be filled in with more data and definitions for more SoCs.

Regards,
Bjorn

v2
--
* Replaced subnode dt parsing with generic pinctrl function
* Installing irq_handler as chained irq handler
* Added call to handle_bad_irq() when no irqs are pending in irq handler
* Creating irq mapping at probe() and cleaned up the code accordingly
* Replaced pinctrl_add_gpio_range with gpiochip_add_pin_range
* Other minor updates based on review comments

Bjorn Andersson (3):
  pinctrl: Add Qualcomm TLMM driver
  pinctrl: Add msm8x74 configuration
  pinctrl: Add documentation for pinctrl-msm8x74

 .../bindings/pinctrl/qcom,msm8x74-pinctrl.txt      |   92 ++
 drivers/pinctrl/Kconfig                            |   10 +
 drivers/pinctrl/Makefile                           |    2 +
 drivers/pinctrl/pinctrl-msm.c                      | 1028 ++++++++++++++++++++
 drivers/pinctrl/pinctrl-msm.h                      |  123 +++
 drivers/pinctrl/pinctrl-msm8x74.c                  |  636 ++++++++++++
 6 files changed, 1891 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,msm8x74-pinctrl.txt
 create mode 100644 drivers/pinctrl/pinctrl-msm.c
 create mode 100644 drivers/pinctrl/pinctrl-msm.h
 create mode 100644 drivers/pinctrl/pinctrl-msm8x74.c

-- 
1.8.2.2

