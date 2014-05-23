Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbaEWKkD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:40:03 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:37850 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbaEWKkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:40:00 -0400
Message-ID: <537F2589.5050807@linaro.org>
Date: Fri, 23 May 2014 12:40:09 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        David Jander <david@protonic.nl>, Zhiwu Song <Zhiwu.Song@csr.com>
Subject: [GIT PULL] clockevents: fixes for 3.15
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Thomas, Ingo,

this pull request contains a couple of fixes:

  * David Jander fixed the calls to clk_disable/clk_enable in the 
tc_mode function as this could be called in an interrupt context

  * Zhiwu Song forces the irq affinity on the marco timer as the 
initialization can happen before the cpu to affine is up

Thanks
   -- Daniel


The following changes since commit 84ea7fe37908254c3bd90910921f6e1045c1747a:

   hrtimer: Set expiry time before switch_hrtimer_base() (2014-05-12 
10:47:39 +0200)

are available in the git repository at:

   git://git.linaro.org/people/daniel.lezcano/linux.git 
clockevents/3.15-fixes

for you to fetch changes up to acbf6d21ac81195071b97ebb114b0b37bd9fcc86:

   clocksource: tcb_clksrc: Make tc_mode interrupt safe (2014-05-22 
18:54:58 +0200)

----------------------------------------------------------------
David Jander (1):
       clocksource: tcb_clksrc: Make tc_mode interrupt safe

Zhiwu Song (1):
       clocksource: marco: Fix the affinity set for local timer of CPU1

  drivers/clocksource/tcb_clksrc.c  |    8 ++++----
  drivers/clocksource/timer-marco.c |    2 +-
  2 files changed, 5 insertions(+), 5 deletions(-)


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

