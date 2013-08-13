Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132Ab3HMQs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:48:27 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:44018 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab3HMQsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:48:24 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk, dmitry.torokhov@gmail.com, sameo@linux.intel.com,
        lee.jones@linaro.org
Cc: linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, bigeasy@linutronix.de,
        gregkh@linuxfoundation.org, Russ.Dill@ti.com
Subject: [PATCH 0/4] iio: input: ti_am335x_adc: Add continuous sampling support round 4
Date: Tue, 13 Aug 2013 17:48:15 +0100
Message-Id: <1376412499-21007-1-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: These apply to the fixes-togreg branch in IIO because of
a fix on the adc side in there.

The first few are for input which tweak the TSC driver to
allow ADC in continuous mode with irqs to work nicely together.

The last one is for iio which adds continuous mode to the adc side.

Received feedback on previous series.
1. What if IRQs occur together? 
This is handled now. Even if both assert.
They both work.

2. IIO error handling wrong. 
Fixed now.

3. Headers wierd in IIO. 
Fixed.

Apart from that, found a few bugs in continuous mode
here and there. And squashed them into the same patch.

Thanks
Zubair Lutfullah

Zubair Lutfullah (4):
  input: ti_am335x_tsc: correct step mask update after IRQ
  input: ti_am335x_tsc: Increase sequencer delay time
  input: ti_tsc: Enable shared IRQ for TSC and add overrun, underflow
    checks
  iio: ti_am335x_adc: Add continuous sampling and trigger support

 drivers/iio/adc/ti_am335x_adc.c           |  353 ++++++++++++++++++++++++-----
 drivers/input/touchscreen/ti_am335x_tsc.c |   45 +++-
 include/linux/mfd/ti_am335x_tscadc.h      |   15 +-
 3 files changed, 342 insertions(+), 71 deletions(-)

-- 
1.7.9.5

