Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab3LLRRM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 12:17:12 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:45747 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab3LLRRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 12:17:10 -0500
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>, Sekhar Nori <nsekhar@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Rob Herring <rob.herring@calxeda.com>, <prabhakar.csengg@gmail.com>,
        <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH 0/2] gpio: davinci: reuse for keystone arch
Date: Thu, 12 Dec 2013 20:12:51 +0200
Message-ID: <1386871973-26762-1-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is intended to update Davinci GPIO driver and reuse
it for Keystone SoCs, because Keystone uses the similar GPIO IP like Davinci.
Keystone GPIO IP: supports:
- up to 32 GPIO lines;
- only unbanked irqs;

See Documentation:
Keystone - http://www.ti.com/lit/ug/sprugv1/sprugv1.pdf

This series depends on:
[1] "[PATCH 1/2] gpio: davinci: Fix a check for unbanked gpio"
https://lkml.org/lkml/2013/11/8/22
[2] "[PATCH v6 0/6] gpio: daVinci: cleanup and feature enhancement"
https://www.mail-archive.com/devicetree@vger.kernel.org/msg05970.html
[3] "gpio: davinci: get rid of DAVINCI_N_GPIO"
https://lkml.org/lkml/2013/11/26/405
[4] "gpio: introduce GPIO_DAVINCI kconfig option"
https://lkml.org/lkml/2013/11/26/435
[5] "gpio: davinci: use chained_irq_enter/chained_irq_exit API"
https://lkml.org/lkml/2013/11/26/428

To handle all dependencies, I've created a branch where I collected all 
"ready to merge" patches (all acks added in patches) and this series:
- https://github.com/grygoriyS/linux.git
- branch: keystone-master-gpio-for-next

The "keystone-master-gpio-for-next" based on:
 https://git.kernel.org/cgit/linux/kernel/git/ssantosh/linux-keystone.git
 branch: keystone/master

+ where I've merged in:
 https://git.kernel.org/cgit/linux/kernel/git/nsekhar/linux-davinci.git
 branch: fixes

List of commits:
 6fb66de gpio: davinci: reuse for Keystone SoC
 c0c5422 gpio: davinci: don't create irq_domain in case of unbanked irqs
 df9f7bc gpio: davinci: use chained_irq_enter/chained_irq_exit API
 6230c92 gpio: davinci: introduce GPIO_DAVINCI kconfig option
 8b0c1a8 gpio: davinci: get rid of DAVINCI_N_GPIO
 5eb07f7 gpio: davinci: add OF support
 df3e59d gpio: davinci: remove unused variable intc_irq_num
 38804b6 gpio: davinci: converts to use irqdomain
 94eac24 gpio: davinci: use {readl|writel}_relaxed() instead of __raw_*

CC: Linus Walleij <linus.walleij@linaro.org>
CC: Sekhar Nori <nsekhar@ti.com>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>

Grygorii Strashko (2):
  gpio: davinci: don't create irq_domain in case of unbanked irqs
  gpio: davinci: reuse for Keystone SoC

 .../devicetree/bindings/gpio/gpio-davinci.txt      |    4 +-
 drivers/gpio/gpio-davinci.c                        |   83 ++++++++++++++------
 2 files changed, 59 insertions(+), 28 deletions(-)

-- 
1.7.9.5

