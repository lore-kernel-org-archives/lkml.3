Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601AbaAJFJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 00:09:00 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:51940 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaAJFI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 00:08:57 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Colin Cross <ccross@android.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jesse Barker <jesse.barker@arm.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: [PATCH 0/2] ION dummy driver v2
Date: Thu,  9 Jan 2014 21:08:36 -0800
Message-Id: <1389330518-31919-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ION subsystem requires something register it along with the
various heaps that may be available on a system in order to work
(Otherwise no /dev/ion is created).

This can make it difficult to play with. Thus I've created this
simple dummy driver which allocates and registers some basic heaps.

I've been using this dummy driver, along with Colin's unit tests
and test driver, to be able to validate basic functionality on
a number of architectures and it was handy to chase down a few
issues before ION was submitted to staging.

If you want to play with all of this, Colin's unit tests can be
found in AOSP under the system/core/libion directory, but if you
want to try to use them in a non-Android environment, I've
mirrored that directory and added some changes to get it building
under Ubuntu here:
   https://github.com/johnstultz-work/ion-test


Greg: I realize this is after the usual -rc6 cutoff for staging,
and I've already made a fool of myself with v1 (but maaaaybe you
don't remember!) so no pressure if you want to defer this for 3.15.

thanks
-john


Changes in v2:
* Fix module build issue (should have been bool instead of tristate)


Cc: Colin Cross <ccross@android.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Jesse Barker <jesse.barker@arm.com>
Cc: Android Kernel Team <kernel-team@android.com>

John Stultz (2):
  ion: Add dummy driver for testing
  ion: Add carveout and chunk heaps to dummy driver

 drivers/staging/android/ion/Kconfig            |  10 ++
 drivers/staging/android/ion/Makefile           |   3 +
 drivers/staging/android/ion/ion_dummy_driver.c | 158 +++++++++++++++++++++++++
 3 files changed, 171 insertions(+)
 create mode 100644 drivers/staging/android/ion/ion_dummy_driver.c

-- 
1.8.3.2

