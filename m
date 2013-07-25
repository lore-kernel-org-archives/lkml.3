Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab3GYNRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 09:17:35 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53504 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430Ab3GYNRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 09:17:33 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: Kevin Hilman <khilman@linaro.org>, Graeme Gregory <gg@slimlogic.co.uk>,
        <linux-omap@vger.kernel.org>, Ruslan Bilovol <ruslan.bilovol@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/5] mfd: twl6030-irq: rework and add twl6032 support
Date: Thu, 25 Jul 2013 16:15:46 +0300
Message-ID: <1374758151-12097-1-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series intorduces twl6030-irq module rework to use Threaded IRQ and
linear irq_domain, and adds support for PMIC TWL6032 IRQs.

After this patch series TWL6030/6032 IRQs will be supported only for DT boot mode.

Changes since v1:
- Added new patch "mfd: twl6030-irq: create struct twl6030_irq" 
  which introduces "struct twl6030_irq" to store all local variables inside it.
- Patch "mfd: twl6030-irq: migrate to IRQ threaded handler":
  Minor comments applied; fixed twl6030_exit_irq();
  The Parent IRQ has been set for each nested IRQ.
- Patch "mfd: twl6030-irq: convert to use linear irq_domain":
  The irq_find_mapping() is used in twl6030_mmc_card_detect_config()
  to get virtual IRQ number.

Based on v3.11-rc1

Tested generation of RTC_ALARM(3) and PWRON(0) IRQs on OMAP4430/TWL6030 and
OMAP4470/TWL6032.

Grygorii Strashko (3):
  mfd: twl6030-irq: add error check when IRQs are masked initially
  mfd: twl6030-irq: convert to use linear irq_domain
  mfd: twl6030-irq: create struct twl6030_irq

Naga Venkata Srikanth V (1):
  mfd: twl6030-irq: migrate to IRQ threaded handler

Oleksandr Dmytryshyn (1):
  mfd: twl6030-irq: Add interrupt mapping table for the twl6032

 drivers/mfd/twl6030-irq.c |  377 +++++++++++++++++++++++++--------------------
 1 file changed, 207 insertions(+), 170 deletions(-)

-- 
1.7.9.5

