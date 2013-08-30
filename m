Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125Ab3H3Kx3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 06:53:29 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39046 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510Ab3H3KxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 06:53:25 -0400
From: George Cherian <george.cherian@ti.com>
To: <linus.walleij@linaro.org>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <kuninori.morimoto.gx@renesas.com>,
        <n.a.balandin@gmail.com>, George Cherian <george.cherian@ti.com>
Subject: [PATCH v2 0/3] cleanup of gpio_pcf857x.c 
Date: Fri, 30 Aug 2013 16:18:30 +0530
Message-ID: <1377859713-13460-1-git-send-email-george.cherian@ti.com>
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

George Cherian (3):
  gpio: pcf857x: change to  devm_request_threaded_irq
  gpio: pcf857x: remove the irq_demux_work
  gpio: pcf857x: call the gpio user  handler  iff gpio_to_irq is done

 arch/arm/boot/dts/dra7-evm.dts |  6 ++---
 drivers/gpio/gpio-pcf857x.c    | 51 +++++++++++++++++++++---------------------
 2 files changed, 29 insertions(+), 28 deletions(-)

-- 
1.8.1.4

