Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbbAPJSB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 04:18:01 -0500
Received: from down.free-electrons.com ([37.187.137.238]:60448 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750741AbbAPJR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 04:17:58 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [RFC 0/2] clocksource: don't suspend/resume when unused
Date: Fri, 16 Jan 2015 10:17:52 +0100
Message-Id: <1421399874-29119-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a quite naive implementation to track whether a cloccksource is enabled.
I chose not to add a member in struct clocksource and use a flag instead.

I found that timekeeping.c is the only consumer for clocksource and I converted
it to use clocksource_enable and clocksource_disable.

Regards,

Alexandre Belloni (2):
  clocksource: track usage
  clocksource: don't suspend/resume when unused

 include/linux/clocksource.h |  4 ++++
 kernel/time/clocksource.c   | 30 ++++++++++++++++++++++++++++--
 kernel/time/timekeeping.c   |  8 +++-----
 3 files changed, 35 insertions(+), 7 deletions(-)

-- 
2.1.0

