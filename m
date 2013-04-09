Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935335Ab3DIDjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 23:39:10 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:40525 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934804Ab3DIDjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 23:39:09 -0400
Message-ID: <51638D59.6010305@linaro.org>
Date: Mon, 08 Apr 2013 20:39:05 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: lkml <linux-kernel@vger.kernel.org>, Prarit Bhargava <prarit@redhat.com>,
        David Engraf <david.engraf@sysgo.com>
Subject: [GIT PULL] Timekeeping locking changes for 3.10
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
     Here's the second chunk of my 3.10 timekeeping changes.

This queue includes:
* NTP locking changes needed for your shadow-timekeeping work
* Your shadow-timekeeping work
* hrtimer fixes from David and Prarit (also tagged for stable)

Let me know if you have any comments or objections!
thanks
-john


The following changes since commit 0ed2aef9b3bffe598045b62a31a50d912eee92d8:

   Merge branch 'fortglx/3.10/time' of 
git://git.linaro.org/people/jstultz/linux into timers/core (2013-04-03 
12:27:29 +0200)

are available in the git repository at:


   git://git.linaro.org/people/jstultz/linux.git fortglx/3.10/time

for you to fetch changes up to 51fd36f3fad8447c487137ae26b9d0b3ce77bb25:

   hrtimer: Fix ktime_add_ns() overflow on 32bit architectures 
(2013-04-08 13:21:20 -0700)

----------------------------------------------------------------
David Engraf (1):
       hrtimer: Fix ktime_add_ns() overflow on 32bit architectures

John Stultz (8):
       ntp: Split out timex validation from do_adjtimex
       ntp: Move do_adjtimex() and hardpps() functions to timekeeping.c
       ntp: Move timex validation to timekeeping do_adjtimex call.
       ntp: Rework do_adjtimex to take timespec and tai arguments
       timekeeping: Move ADJ_SETOFFSET to top level do_adjtimex()
       timekeeping: Hold timekeepering locks in do_adjtimex and hardpps
       timekeeping: Simplify tai updating from do_adjtimex
       ntp: Remove ntp_lock, using the timekeeping locks to protect ntp 
state

Prarit Bhargava (1):
       hrtimer: Add expiry time overflow check in hrtimer_interrupt

Thomas Gleixner (4):
       timekeeping: Store cycle_last value in timekeeper struct as well
       timekeeping: Delay update of clock->cycle_last
       timekeeping: Implement a shadow timekeeper
       timekeeping: Shorten seq_count region

  include/linux/timekeeper_internal.h |    2 +
  include/linux/timex.h               |    7 --
  kernel/hrtimer.c                    |    6 ++
  kernel/time/ntp.c                   |   99 ++++++++---------------------
  kernel/time/ntp_internal.h          |   12 ++++
  kernel/time/timekeeping.c           |  120 
+++++++++++++++++++++++++++++------
  6 files changed, 148 insertions(+), 98 deletions(-)
  create mode 100644 kernel/time/ntp_internal.h
