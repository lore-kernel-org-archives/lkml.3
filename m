Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934558Ab3GRWVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 18:21:35 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:53186 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932931Ab3GRWVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 18:21:31 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk
Cc: gregkh@linuxfoundation.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net
Subject: [PATCH 00/15] iio: ti_am335x_adc: Add continuous mode take 2
Date: Thu, 18 Jul 2013 23:21:11 +0100
Message-Id: <1374186086-5015-1-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches now give correct authorship.

and checkpatch.pl issues are checked for each patch.

I hope the actual code bashing can begin now.

A series of patches that add continuous sampling support
for the adc drivers for the am335x.

These apply on top of mfd-next after the recent set of patches
on this driver by Sebastian Andrzej Siewior

Tested on the Beaglebone Black running 3.11

Patil, Rachna (5):
  MFD: ti_tscadc: disable TSC config registers in adc mode
  iio: ti_am335x_adc: Fix wrong samples received on 1st read
  input: ti_tsc: Enable shared IRQ for TSC
  iio: mfd: input: ti_am335x_adc:Add support for continuous mode
  MFD: ti_tscadc: ADC Clock check not required

Russ Dill (10):
  iio: ti_am335x_adc: Handle set to clear IRQENABLE
  iio: ti_am335x_adc: Handle set to clear IRQSTATUS
  iio: ti_am335x_adc: Handle overrun before threshold event
  iio: ti_am335x_adc: Avoid double threshold event
  iio: ti_am335x_adc: Also clear threshold event when clearing overrun
    event
  iio: ti_am335x_adc: Print error and handle short FIFO events
  iio: ti_am335x_adc: Fix allocation count of FIFO buffer.
  iio: ti_am335x_adc: Fix capture operation during resume
  iio: ti_am335x_adc: Reset and clear overrun status before capture
  iio: ti_am335x_adc: Properly handle out of memory situation.

 drivers/iio/adc/ti_am335x_adc.c           |  354 +++++++++++++++++++++++++----
 drivers/input/touchscreen/ti_am335x_tsc.c |   17 +-
 drivers/mfd/ti_am335x_tscadc.c            |   30 ++-
 include/linux/mfd/ti_am335x_tscadc.h      |   27 ++-
 4 files changed, 366 insertions(+), 62 deletions(-)

-- 
1.7.9.5

