Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab3AOM4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 07:56:41 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62356 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756600Ab3AOM4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 07:56:38 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, sameo@linux.intel.com,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 07/26] mfd: ab8500-sysctrl: export read/write symbols
Date: Tue, 15 Jan 2013 12:55:47 +0000
Message-Id: <1358254566-12419-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

Export ab8500_sysctrl_read() and ab8500_sysctrl_write() symobols.

They will be used by LTP test cases.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Reviewed-by: Bengt JONSSON <bengt.g.jonsson@stericsson.com>
---
 drivers/mfd/ab8500-sysctrl.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/ab8500-sysctrl.c b/drivers/mfd/ab8500-sysctrl.c
index 19a024e..5a61e94 100644
--- a/drivers/mfd/ab8500-sysctrl.c
+++ b/drivers/mfd/ab8500-sysctrl.c
@@ -94,6 +94,7 @@ int ab8500_sysctrl_read(u16 reg, u8 *value)
 	return abx500_get_register_interruptible(sysctrl_dev, bank,
 		(u8)(reg & 0xFF), value);
 }
+EXPORT_SYMBOL(ab8500_sysctrl_read);
 
 int ab8500_sysctrl_write(u16 reg, u8 mask, u8 value)
 {
@@ -109,6 +110,7 @@ int ab8500_sysctrl_write(u16 reg, u8 mask, u8 value)
 	return abx500_mask_and_set_register_interruptible(sysctrl_dev, bank,
 		(u8)(reg & 0xFF), mask, value);
 }
+EXPORT_SYMBOL(ab8500_sysctrl_write);
 
 static int __devinit ab8500_sysctrl_probe(struct platform_device *pdev)
 {
-- 
1.7.9.5

