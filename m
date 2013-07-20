Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455Ab3GTQ1o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 12:27:44 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:63453 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374Ab3GTQ1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 12:27:41 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, koen@dominion.thruhere.net
Subject: [PATCH 0/4] mfd: iio: ti_am335x_tscadc: fixes adc sampling, TSC config and a typo
Date: Sat, 20 Jul 2013 17:27:32 +0100
Message-Id: <1374337656-6393-1-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This short series has 4 patches that apply on the mfd-next tree that fix/cleanup the am335x_tsadc driver.

1- Fix. ADC driver would read data from fifo before sampling completes. Fixed by waiting for sequencer to complete and then read data
Acked by IIO.

2- Fix. TSC registers would be configured even in ADC only mode. Fixed so that they are configured only when TSC is enabled.

3- Cleanup. Removes a check on the ADC clock which isn't needed anymore.

4- Typo. Coordinate is spelled Coordiante. Corrected in all files in one patch.

Note: The typo patch has been sent before on all relevant lists too. No response..

Patil, Rachna (3):
  iio: ti_am335x_adc: Fix wrong samples received on 1st read
  MFD: ti_tscadc: disable TSC config registers in adc mode
  MFD: ti_tscadc: ADC Clock check not required

Zubair Lutfullah (1):
  mfd: input: arm: dts: doc: ti_am335x: typo fixes (coordiante ->
    coordinate)

 .../bindings/input/touchscreen/ti-tsc-adc.txt      |    4 +--
 arch/arm/boot/dts/am335x-evm.dts                   |    2 +-
 drivers/iio/adc/ti_am335x_adc.c                    |   30 ++++++++++++++------
 drivers/input/touchscreen/ti_am335x_tsc.c          |    2 +-
 drivers/mfd/ti_am335x_tscadc.c                     |   26 ++++++++---------
 include/linux/mfd/ti_am335x_tscadc.h               |   17 ++++++++++-
 6 files changed, 55 insertions(+), 26 deletions(-)

-- 
1.7.9.5

