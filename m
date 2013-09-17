Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab3IQIoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 04:44:19 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:51454 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab3IQIoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 04:44:16 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk, dmitry.torokhov@gmail.com
Cc: linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, bigeasy@linutronix.de,
        gregkh@linuxfoundation.org, zubair.lutfullah@gmail.com
Subject: [PATCH V9 0/2] iio: input: ti_am335x_adc: Add continuous sampling support
Date: Tue, 17 Sep 2013 09:44:05 +0500
Message-Id: <1379393047-11772-1-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This applies to togreg branch in iio.

Round 9 updates

- Removed Trigger.
- Restructured everything for INDIO_BUFFERED_HARDWARE mode.
- Threaded IRQ with top/bottom halfs. Top half HW IRQ wakes
bottom half threaded worker that pushes samples to iio/userspace.
- Removed some of the patchwork to the driver that was irrelevant to the
continuous sampling patch.

Cleanup will be done separately once this goes through.
Hope these patches meet the mighty kernel standards :)

Zubair

Zubair Lutfullah (2):
  input: ti_am335x_tsc: Enable shared IRQ for TSC
  iio: ti_am335x_adc: Add continuous sampling support

 drivers/iio/adc/ti_am335x_adc.c           |  222 ++++++++++++++++++++++++++++-
 drivers/input/touchscreen/ti_am335x_tsc.c |   12 +-
 include/linux/mfd/ti_am335x_tscadc.h      |    9 ++
 3 files changed, 235 insertions(+), 8 deletions(-)

-- 
1.7.9.5

