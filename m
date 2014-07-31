Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbaGaQqN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:46:13 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:36839 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbaGaQqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:46:10 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: [PATCH 0/2] nohz: Avoid double clock write
Date: Thu, 31 Jul 2014 18:45:54 +0200
Message-Id: <1406825156-11901-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

The tick reschedules itself unconditionally. That's what we want as long
as the CPU is in periodic mode. It's not that relevant when the CPU
is in dynticks mode though as the clock write is likely to be overwritten
by the nohz code on irq exit.

In low-res mode, that even result in unexpected periodic behaviour when
no timer is scheduled in the future.

So here is a set that proposes the removal of these double writes.

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	origin/nohz/drop-double-write-v2

Thanks,
	Frederic
---

Viresh Kumar (2):
      nohz: Fix spurious periodic tick behaviour in low-res dynticks mode
      nohz: Avoid tick's double reprogramming in highres mode


 kernel/time/tick-sched.c | 8 ++++++++
 1 file changed, 8 insertions(+)
