Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759084Ab3HMUFM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:05:12 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:59585 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759043Ab3HMUFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:05:08 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk, dmitry.torokhov@gmail.com
Cc: linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, bigeasy@linutronix.de,
        gregkh@linuxfoundation.org, Russ.Dill@ti.com
Subject: [PATCH 0/4] iio: input: ti_am335x_adc: Add continuous sampling support round 5
Date: Tue, 13 Aug 2013 21:04:59 +0100
Message-Id: <1376424303-22740-1-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Round 5 updates. Fixed the define order in the header as guided by Lee.

Round 4 updates below.

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
  input: ti_am335x_tsc: Enable shared IRQ for TSC, add overrun and
    underflow checks
  iio: ti_am335x_adc: Add continuous sampling and trigger support

 drivers/iio/adc/ti_am335x_adc.c           |  353 ++++++++++++++++++++++++-----
 drivers/input/touchscreen/ti_am335x_tsc.c |   45 +++-
 include/linux/mfd/ti_am335x_tscadc.h      |   14 ++
 3 files changed, 342 insertions(+), 70 deletions(-)

-- 
1.7.9.5

