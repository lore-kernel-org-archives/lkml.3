Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641AbaGDEVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 00:21:44 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:53329 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaGDEVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 00:21:40 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Frederic Weisbecker <fweisbec@gmail.com>, preeti@linux.vnet.ibm.com,
        daniel.lezcano@linaro.org
Subject: [PATCH 0/2] clockevents: introduce ->set_dev_mode() and convert a few drivers
Date: Thu,  3 Jul 2014 21:21:34 -0700
Message-Id: <1404447696-4105-1-git-send-email-khilman@linaro.org>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the ->set_mode() method of a clockevent device is not
allowed to fail, so it has no return value.  In order to add new
clockevent modes, and allow the setting of those modes to fail, we
need the clockevent core to be able to detect when setting a mode
fails.

Rather than changing the current ->set_mode() and requiring all
clockevent devices to change immedately, introduce a new mode setting
method ->set_dev_mode() which returns 'int'.

In addition, migrate a few drivers over to the new method to
demonstrate how the new method is to be used, and how to convert.

Proposal for new method originally suggested by Thomas Gleixner[1].

[1] https://lkml.org/lkml/2014/5/10/86


Viresh Kumar (2):
  clockevents: introduce ->set_dev_mode() which can return error
  clockevents: migrate some drivers to new ->set_dev_mode()

 drivers/clocksource/arm_arch_timer.c     | 46 +++++++++++++++++---------------
 drivers/clocksource/bcm2835_timer.c      | 10 +++----
 drivers/clocksource/bcm_kona_timer.c     | 15 ++++++++---
 drivers/clocksource/i8253.c              | 11 +++++---
 drivers/clocksource/time-armada-370-xp.c | 21 +++++++++++----
 include/linux/clockchips.h               |  5 +++-
 kernel/time/clockevents.c                | 21 ++++++++++++---
 kernel/time/timer_list.c                 |  5 +++-
 8 files changed, 91 insertions(+), 43 deletions(-)

-- 
1.9.2

