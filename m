Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254AbaF0R1b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 13:27:31 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:50754 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbaF0R1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 13:27:22 -0400
From: John Stultz <john.stultz@linaro.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, John Whitmore <arigead@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 0/2][RFC] Try to handle hctosys w/ rtc modules 
Date: Fri, 27 Jun 2014 10:27:09 -0700
Message-Id: <1403890031-26419-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Its been pointed out that the RTC hctosys functionality doesn't
work well with RTC modules, which may not be loaded until after
late_init().

While there have been other attempts to sovle this, this patchset
is a very quick 10 minute effort to show how I'd try to resolve
this. There likely are still issues here, but I'd be happy to
make fixes and adjustments to ensure it works.

Feedback and comments always appreciated!

-john

Cc: John Whitmore <arigead@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexander Holler <holler@ahsoftware.de>

John Stultz (2):
  time: Introduce do_first_settimeofday()
  rtc: Rework hctosys so that it is called on RTC registration

 drivers/rtc/class.c       |  2 ++
 drivers/rtc/hctosys.c     | 19 +++++++----------
 include/linux/rtc.h       |  6 ++++++
 include/linux/time.h      |  2 ++
 kernel/time/timekeeping.c | 54 ++++++++++++++++++++++++++++++++++++++---------
 5 files changed, 62 insertions(+), 21 deletions(-)

-- 
1.9.1

