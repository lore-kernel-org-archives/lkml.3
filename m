Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab3GQR04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:26:56 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:49963 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900Ab3GQR0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:26:54 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk
Cc: linux-iio@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net,
        zubair.lutfullah@gmail.com
Subject: [PATCH 00/21] iio: TI-am335x-adc continuous mode
Date: Wed, 17 Jul 2013 18:26:29 +0100
Message-Id: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A series of patches that add continuous sampling support
for the adc drivers for the am335x.

Most of the work is done by Rachil Patna and Russ Dill from TI.

TI maintains a 3.2 based kernel tree.
I forward ported these patches from those.

One of the significant changes I made to their patches
was to the ring_sw buffer as that support has been removed from iio.

I also merged some of their bug fixes in the same large patch which
adds the main support (patch 5 with the subject "Add continuous mode to adc")

MFD and Input changes are little. I will cc them once IIO has acked
this patchset. No need to clutter their lists with a dozen iio patches.

These apply on top of mfd-next after the recent set of patches
on this driver by Sebastian Andrzej Siewior.

Tested on the Beaglebone Black running 3.11

Check_patch.pl issues are resolved in the last three patches separately.

*** BLURB HERE ***

Zubair Lutfullah (21):
  MFD: ti_tscadc: disable TSC control
  IIO: ADC: ti_adc: Fix 1st sample read
  iio: ti_am335x_adc: Added iio_voltageX_scale
  input: ti_tsc: Enable shared IRQ for TSC
  iio: input: am335x_adc: Add continuous mode to adc
  MFD: ti_tscadc: ADC Clock check not required
  iio: TI-am335x-adc: Cleanup
  IIO: ti_adc: Handle set to clear IRQENABLE register properly.
  IIO: ti_adc: Handle set to clear IRQSTATUS register properly
  IIO: ti_adc: Handle overrun before threshold event
  iio: ti_adc: Avoid double threshold event
  IIO: ti_adc: Also clear threshold event when clearing overrun event
  IO: ti_adc: Reset and clear overrun status before capture.
  IIO: ti_adc: Properly handle out of memory situation.
  IIO: ti_adc: Print error and handle short FIFO events
  IIO: ti_adc: Fix allocation count of FIFO buffer.
  Revert "IIO: ti_adc: Correct wrong samples received on 1st read in
    continuous mode"
  IIO: ti_adc: Fix capture operation during resume
  iio: ti_amss5x adc Fix check_patch.pl issues
  input: ti_am335x_tsc.c fix checkpatch.pl issues
  mfd: ti_am335x_tscadc.c fix checkpatch.pl issues

 drivers/iio/adc/ti_am335x_adc.c           |  388 ++++++++++++++++++++++++++---
 drivers/input/touchscreen/ti_am335x_tsc.c |   17 +-
 drivers/mfd/ti_am335x_tscadc.c            |   30 +--
 include/linux/mfd/ti_am335x_tscadc.h      |   29 ++-
 4 files changed, 403 insertions(+), 61 deletions(-)

-- 
1.7.9.5

