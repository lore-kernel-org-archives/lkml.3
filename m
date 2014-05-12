Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbaELJa0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 05:30:26 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:53479 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbaELJaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 05:30:24 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linaro-networking@linaro.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        arvind.chauhan@arm.com, daniel.lezcano@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [RFC 0/2] clockevents: add ->set_dev_mode() to struct clock_event_device
Date: Mon, 12 May 2014 15:00:04 +0530
Message-Id: <cover.1399886467.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

As suggested by you (https://lkml.org/lkml/2014/5/10/86), here is an attempt to
implement first two steps for fixing the bigger problem.

This patchset is about adding ->set_dev_mode() to struct clock_event_device with
return type 'int'. To achieve that return type of clockevents_set_mode() is also
changed to propagate failures.

Let me know if this is what you wanted to see or I screwed up again :(

I will then start updating drivers one by one (100 drivers AFAICT). I will try to
fix them in separate patches and will post them together in a single patchset.
And because the number is going to be over 100, let me know how do you want me
to send that..

Viresh Kumar (2):
  clockevents: return 'int' from clockevents_set_mode()
  clockevents: add ->set_dev_mode() to struct clock_event_device

 arch/arm/common/bL_switcher.c |  5 +++--
 include/linux/clockchips.h    |  7 +++++--
 kernel/time/clockevents.c     | 34 +++++++++++++++++++++++++---------
 kernel/time/tick-broadcast.c  | 25 ++++++++++++++++---------
 kernel/time/tick-common.c     |  6 +++---
 kernel/time/tick-oneshot.c    |  6 +++---
 kernel/time/timer_list.c      |  9 +++++++--
 7 files changed, 62 insertions(+), 30 deletions(-)

-- 
2.0.0.rc2

