Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758958Ab3IBUCB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 16:02:01 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:39981 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757112Ab3IBUCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 16:02:00 -0400
Message-ID: <5224EEB4.2080902@linaro.org>
Date: Mon, 02 Sep 2013 22:01:56 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] clockevents/clocksource : armada-370-xp fixes, sh_cmt,
 em_sti  timer-sp and nomadik changes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Thomas,

this is the last minute git pull request, hoping it is not too late.

I had these patches in my tree since a while but I was waiting for the
first pull request to be consumed before sending this one out (vacations
arrived in the meantime).

The branch contains some fixes for the armada-370-xp, a couple of
changes for em_sti and sh_cmt, and finally a couple of patches for the
dynamic irq affinity flag which should have been picked for 3.10 but
lost in limbo.


The following changes since commit cfb6d656d569510ac9239583ce09e4c92ad54719:

  Merge branch 'timers/clockevents-next' of
git://git.linaro.org/people/dlezcano/clockevents into timers/core
(2013-08-21 14:59:23 +0200)

are available in the git repository at:


  git://git.linaro.org/people/dlezcano/clockevents.git timers/clockevents

for you to fetch changes up to 63ce2cc474ce962d936ae6dfaa6ae2354b1db5b2:

  clocksource: armada-370-xp: Add detailed clock requirements in
devicetree binding (2013-09-02 21:44:58 +0200)

----------------------------------------------------------------
Daniel Lezcano (1):
      ARM: nomadik: add dynamic irq flag to the timer

Ezequiel Garcia (8):
      clocksource: armada-370-xp: Use BIT()
      clocksource: armada-370-xp: Simplify TIMER_CTRL register access
      clocksource: armada-370-xp: Use CLOCKSOURCE_OF_DECLARE
      clocksource: armada-370-xp: Introduce new compatibl
      clocksource: armada-370-xp: Fix device-tree binding
      clocksource: armada-370-xp: Replace WARN_ON with BUG_ON
      clocksource: armada-370-xp: Get reference fixed-clock by name
      clocksource: armada-370-xp: Add detailed clock requirements in
devicetree binding

Laurent Pinchart (1):
      clocksource: em_sti: Convert to devm_* managed helpers

Magnus Damm (1):
      clocksource: sh_cmt: 32-bit control register support

Viresh Kumar (1):
      ARM: timer-sp: Set dynamic irq affinity

 .../bindings/timer/marvell,armada-370-xp-timer.txt |   36 +++++-
 arch/arm/common/timer-sp.c                         |    3 +-
 arch/arm/mach-mvebu/armada-370-xp.c                |    4 +-
 drivers/clocksource/em_sti.c                       |   49 ++-----
 drivers/clocksource/nomadik-mtu.c                  |    3 +-
 drivers/clocksource/sh_cmt.c                       |   50 +++++--
 drivers/clocksource/time-armada-370-xp.c           |  136
+++++++++++---------
 include/linux/time-armada-370-xp.h                 |   18 ---
 8 files changed, 164 insertions(+), 135 deletions(-)
 delete mode 100644 include/linux/time-armada-370-xp.h

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

