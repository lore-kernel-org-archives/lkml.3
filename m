Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760381Ab3GZXvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 19:51:21 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:37789 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017Ab3GZXvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 19:51:19 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, gregkh@linuxfoundation.org,
        Russ.Dill@ti.com
Subject: [PATCH 0/2] iio: input: ti_am335x_adc: Add continuous sampling and trigger support round 3
Date: Sat, 27 Jul 2013 00:51:12 +0100
Message-Id: <1374882674-18403-1-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ADC and TSC share an IRQ line. Patch one is simple and adds shared irq support on the TSC side.

The second patch adds continuous sampling support to the am335x_adc driver.

It has been submitted previously. This is round 3.

Previously:
- Submitted as a series of patches and bug fixes.
- The driver would continuously push samples into a buffer exposed to userspace.
- Extra sysfs attributes for selecting continuous mode or one shot mode.
- No trigger functionality.
- Reading from /dev/iio required patching the provided generic_buffer.c iio test application to bypass trigger.
- Only one channel could be read at a time.
- And even then, samples were skipped as the FIFO was read incorrectly.

Now: 
- All bug fixes merged together in one patch.
- Stuck closely to the IIO ABI this time.
- Added trigger support.
- Fixed channel scanning where only one channel could be read into the buffer at a time.
- Now all enabled channels in the scan_elements folder are pushed to the userspace properly without skipping any samples.
- generic_buffer.c test application can read samples without any modification.
- A sysfs trigger starts acquisition.

This has been tested on the Beaglebone Black running the am335x processor.
The patches apply on the iio branch fixes-togreg.

Patil, Rachna (1):
  input: ti_tsc: Enable shared IRQ for TSC

Zubair Lutfullah (1):
  iio: ti_am335x_adc: Add continuous sampling and trigger support

 drivers/iio/adc/ti_am335x_adc.c           |  334 +++++++++++++++++++++++------
 drivers/input/touchscreen/ti_am335x_tsc.c |   18 +-
 include/linux/mfd/ti_am335x_tscadc.h      |   13 +-
 3 files changed, 299 insertions(+), 66 deletions(-)

-- 
1.7.9.5

