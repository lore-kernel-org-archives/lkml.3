Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbaLIWDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 17:03:38 -0500
Received: from mail.kernel.org ([198.145.19.201]:59607 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbaLIWDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 17:03:37 -0500
From: Kevin Hilman <khilman@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Frederic Weisbecker <fweisbec@gmail.com>, preeti@linux.vnet.ibm.com
Subject: [PATCH 0/2] clockevents: introduce ->set_dev_mode() and convert a few drivers
Date: Tue,  9 Dec 2014 14:03:32 -0800
Message-Id: <1418162614-19182-1-git-send-email-khilman@kernel.org>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Hilman <khilman@linaro.org>

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
2.1.3

