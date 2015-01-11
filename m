Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbbAKLqH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 06:46:07 -0500
Received: from down.free-electrons.com ([37.187.137.238]:48273 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752123AbbAKLpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 06:45:23 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 0/5] clocksource: sun5i: Support parent clock rate changes
Date: Sun, 11 Jan 2015 12:40:05 +0100
Message-Id: <1420976410-7826-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The Allwinner HS timers have the AHB clock as their parent
clock. Since this clock is shared with other devices, we could very
well have another driver requesting a rate change of that clock,
making our timer change frequency at the same time.

This is especially true on the A31, where the DMA controller needs to
do such a rate change, making the HS timer unreliable at the time on
the A31.

This serie makes some cleanups and implements clock notifiers to be
able to reflect such rate changes and make sure that the timer is
always working.

Maxime

Maxime Ripard (5):
  clocksource: sun5i: Switch to request_irq
  clocksource: sun5i: Use of_io_request_and_map
  clocksource: sun5i: Remove sched_clock
  clocksource: sun5i: Refactor the current code
  clocksource: sun5i: Add clock notifiers

 drivers/clocksource/timer-sun5i.c | 306 +++++++++++++++++++++++++++++---------
 1 file changed, 232 insertions(+), 74 deletions(-)

-- 
2.2.1

