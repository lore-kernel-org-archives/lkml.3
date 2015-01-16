Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbbAPQ5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 11:57:30 -0500
Received: from down.free-electrons.com ([37.187.137.238]:35777 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752578AbbAPQ52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 11:57:28 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH v2 0/2] clocksource: don't suspend/resume when unused
Date: Fri, 16 Jan 2015 17:57:17 +0100
Message-Id: <1421427439-11699-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a quite naive implementation to track whether a clocksource is enabled.
I chose not to add a member in struct clocksource and use a flag instead.

I found that timekeeping.c is the only consumer for clocksource and I converted
it to use clocksource_enable and clocksource_disable.

Changes in v2:
 - removed the check on enable in timekeeping.c to ensure all clocksources are
   going through clocksource_enable
 - rework clocksource_enable to set CLOCK_SOURCE_USED when enable is successful
   if present

Alexandre Belloni (2):
  clocksource: track usage
  clocksource: don't suspend/resume when unused

 include/linux/clocksource.h |  4 ++++
 kernel/time/clocksource.c   | 34 ++++++++++++++++++++++++++++++++--
 kernel/time/timekeeping.c   |  8 +++-----
 3 files changed, 39 insertions(+), 7 deletions(-)

-- 
2.1.0

