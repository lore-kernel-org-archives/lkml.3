Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab3IALHW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 07:07:22 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:51195 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab3IALHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 07:07:18 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk, dmitry.torokhov@gmail.com
Cc: linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, bigeasy@linutronix.de,
        gregkh@linuxfoundation.org, zubair.lutfullah@gmail.com
Subject: [PATCH V7 0/2] iio: input: ti_am335x_tscadc: Add continuous sampling support to adc
Date: Sun,  1 Sep 2013 12:07:11 +0100
Message-Id: <1378033633-26301-1-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Round 7 updates
- Fixes to error handling path for trigger register

- Optimization of step enable calculations based 
on input from Sebastian

- trigger unregister added to remove section. was missing

- missing entry in Kconfig for triggered buffer support. added

- TSC/ADC IRQ handling was based on wierd ack system. not required. removed.
each irq handler deals with its own stuff *only*

Thanks for all the input 

Regards
Zubair Lutfullah Kakakhel

Zubair Lutfullah (2):
  input: ti_am335x_tsc: Enable shared IRQ for TSC
  iio: ti_am335x_adc: Add continuous sampling support

 drivers/iio/adc/Kconfig                   |    1 +
 drivers/iio/adc/ti_am335x_adc.c           |  243 ++++++++++++++++++++++++++---
 drivers/input/touchscreen/ti_am335x_tsc.c |   12 +-
 include/linux/mfd/ti_am335x_tscadc.h      |   13 ++
 4 files changed, 246 insertions(+), 23 deletions(-)

-- 
1.7.9.5

