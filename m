Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760758AbaEMK7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:59:10 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:64298 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760255AbaEMK67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:58:59 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-e7-5371faf09690
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 03/16] mfd: ipaq-micro: Make mfd_cell array const
Date: Tue, 13 May 2014 12:58:40 +0200
Message-id: <1399978733-13662-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1399978733-13662-1-git-send-email-k.kozlowski@samsung.com>
References: <1399978733-13662-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIJMWRmVeSWpSXmKPExsVy+t/xy7offhUGG+zpV7J4/cLQ4v7Xo4wW
	U/4sZ7K4vGsOm8XpblYHVo871/awecw7GejRt2UVo8fnTXIBLFFcNimpOZllqUX6dglcGfen
	8xT8Ya3YsbmPqYGxgbWLkZNDQsBE4t29C+wQtpjEhXvr2boYuTiEBJYySqyf/YAFJCEk0Mck
	sWafC4jNJmAssXn5EjYQW0QgS+LHtNVANRwczAKxEk+2lIOEhQUcJX5/fMIMYrMIqEpcPN3O
	CGLzCrhLnDm3iBlil5zEyWOTwW7gFPCQeHH7LCvEKneJG6smsUxg5F3AyLCKUTS1NLmgOCk9
	11CvODG3uDQvXS85P3cTIyRYvuxgXHzM6hCjAAejEg9vAFdBsBBrYllxZe4hRgkOZiURXvdP
	hcFCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGBeL/2ELTnefc8j5eqLGuduHtEIrv24qmadvs9r1
	SbeP6aSXbNut9vUd2KiVKd/fvO5cFrcy98IpFx9vjm432603/bqbDT/D267dnqeyIra8qzli
	Pv+C1mQOvUP3JriGuxTNP35hkbHNdtnXjUYqn9Sv/P3T6akaE7LotUdW6bolIY+ao327Hiux
	FGckGmoxFxUnAgCjCCqX9AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mfd_add_devices() expects array of struct mfd_cell to be const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/ipaq-micro.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/ipaq-micro.c b/drivers/mfd/ipaq-micro.c
index 1763d6db346e..fe3c97b275a6 100644
--- a/drivers/mfd/ipaq-micro.c
+++ b/drivers/mfd/ipaq-micro.c
@@ -368,7 +368,7 @@ static irqreturn_t micro_serial_isr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static struct mfd_cell micro_cells[] = {
+static const struct mfd_cell micro_cells[] = {
 	{ .name = "ipaq-micro-backlight", },
 	{ .name = "ipaq-micro-battery", },
 	{ .name = "ipaq-micro-keys", },
-- 
1.9.1

