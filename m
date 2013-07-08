Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab3GHQwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 12:52:43 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:53965 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab3GHQwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 12:52:42 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Baruch Siach <baruch@tkos.co.il>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Michal Simek <michal.simek@xilinx.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH v2 0/2] clocksource/cadence_ttc: Add sched_clock functionality
Date: Mon,  8 Jul 2013 09:51:36 -0700
Message-Id: <1373302298-27957-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I updated the original patch according to the discussion with Thomas and Baruch.
Furthermore, I noticed that the driver includes the clk-provider header for no
apparent reason and removed it.

	Sören

v2:
 - adding patch to remove unused header to the series
 - #include linux/sched_clock.h instead of asm/sched_clock.h
 - remove Kconfig options and #ifdefs around sched_clock related code
    The reasons for having those are obsolete, since ARM deprecated its
    custom sched_clock framework and migrated to the common one.


Soren Brinkmann (2):
  clocksource/cadence_ttc: Remove unused header
  clocksource/cadence_ttc: Reuse clocksource as sched_clock

 drivers/clocksource/cadence_ttc_timer.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

-- 
1.8.3.2

