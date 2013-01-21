Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab3AUGin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 01:38:43 -0500
Received: from mga03.intel.com ([143.182.124.21]:39002 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792Ab3AUGim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 01:38:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,504,1355126400"; 
   d="scan'208";a="193316291"
From: Feng Tang <feng.tang@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>
Subject: [RFC PATCH 0/5] Add support for S3 non-stop TSC support. 
Date: Mon, 21 Jan 2013 14:38:40 +0800
Message-Id: <1358750325-21217-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

On some new Intel Atom processors (Penwell and Cloverview), there is
a feature that the TSC won't stop S3, say the TSC value won't be
reset to 0 after resume. This feature makes TSC a more reliable
clocksource and could benefit the timekeeping code during system
suspend/resume cycles.

The enabling efforts include adding new flags for this feature, 
modifying clocksource.c and timekeeping.c to support and utilizing
it.

One remaining question is inside the timekeeping_resume(), we don't
know if it is called by resuming from suspend(s2ram) or from
hibernate(s2disk), as there is no easy way to check it currently.
But it doesn't hurt as these Penwell/Cloverview platforms only have
S3 state, and no S4.

Please help to review them, thanks!

- Feng

---------

Feng Tang (5):
  x86: Add cpu capability flag X86_FEATURE_TSC_S3_NOTSTOP
  clocksource: Add new feature flag CLOCK_SOURCE_SUSPEND_NOTSTOP
  x86: tsc: Add support for new S3_NOTSTOP feature
  clocksource: Enlarge the maxim time interval when configuring the
    scale and shift
  timekeeping: Add support for clocksource which doesn't stop during
    suspend

 arch/x86/include/asm/cpufeature.h |    1 +
 arch/x86/kernel/cpu/intel.c       |   12 ++++++++++++
 arch/x86/kernel/tsc.c             |    6 +++++-
 include/linux/clocksource.h       |    1 +
 kernel/time/clocksource.c         |    6 +++---
 kernel/time/timekeeping.c         |   23 ++++++++++++++++++-----
 6 files changed, 40 insertions(+), 9 deletions(-)

-- 
1.7.9.5

