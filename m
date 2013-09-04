Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762135Ab3IDHDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 03:03:18 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42381 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762016Ab3IDHDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 03:03:16 -0400
From: George Cherian <george.cherian@ti.com>
To: <linus.walleij@linaro.org>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <kuninori.morimoto.gx@renesas.com>,
        <n.a.balandin@gmail.com>, George Cherian <george.cherian@ti.com>
Subject: [PATCH v4 0/3] cleanup of gpio_pcf857x.c 
Date: Wed, 4 Sep 2013 12:33:00 +0530
Message-ID: <1378278183-26596-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series
        - removes the irq_demux_work
        - Uses devm_request_threaded_irq
        - Call the user handler iff gpio_to_irq is done.

v1 --> v2
        Split v1 to 3 patches
v2 --> v3
	Remove the unnecessary dts patches.
v3 --> v4
	Remove gpio->irq (in patch 2)

Note: these patches were made after applying [1].
[1] - [PATCH v5] gpio: pcf857x: Add OF support - https://lkml.org/lkml/2013/8/27/70

George Cherian (3):
  gpio: pcf857x: change to devm_request_threaded_irq
  gpio: pcf857x: remove the irq_demux_work and gpio->irq
  gpio: pcf857x: call the gpio user handler iff gpio_to_irq is done

 drivers/gpio/gpio-pcf857x.c | 53 ++++++++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 27 deletions(-)

-- 
1.8.1.4

