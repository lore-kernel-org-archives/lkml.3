Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab3KLOBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:01:33 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:43714 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab3KLOBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:01:30 -0500
Message-ID: <528234B9.7080402@linaro.org>
Date: Tue, 12 Nov 2013 15:01:29 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
CC: John Stultz <john.stultz@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: [GIT PULL] clockevents/clocksource: 3.12 fixes
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ingo and Thomas,

this pull request has the following contain:

  * Laurent Pinchard fixed a missing a clk_put in case the registering 
of the sh_mtu[2] drivers fails.

  * Uwe Kleine-König reuse clockevents_config_and_register for the 
at91rm9200_time timer as it was depending on the patch (commit a4578ea 
(clockevents: Sanitize ticks to nsec conversion).

I don't know why Thomas's patch "clockevents: Sanitize ticks to nsec 
conversion" appears in the request log because it is not part of the 
patches interval I specified for git request pull. The diffstat does not 
show the files which should have been changed by the patch. In any case 
I kept the changelog untouched since it is what gives me git and maybe 
someone can tell me why it appears.

Thanks
   -- Daniel

The following changes since commit 97b9410643475d6557d2517c2aff9fd2221141a9:

   clockevents: Sanitize ticks to nsec conversion (2013-10-23 12:51:21 
+0200)

are available in the git repository at:

   git://git.linaro.org/people/dlezcano/linux.git clockevents/fixes

for you to fetch changes up to 42ab3801115c2e2ae3d0467ecef943913bba8a2f:

   clocksource: sh_tmu: Add clk_prepare/unprepare support (2013-11-08 
11:08:00 +0100)

----------------------------------------------------------------
Daniel Lezcano (1):
       Merge tag 'timer-for-tip' of 
git://git.pengutronix.de/git/ukl/linux into clockevents/fixes

Laurent Pinchart (4):
       clocksource: sh_mtu2: Release clock when sh_mtu2_register() fails
       clocksource: sh_mtu2: Add clk_prepare/unprepare support
       clocksource: sh_tmu: Release clock when sh_tmu_register() fails
       clocksource: sh_tmu: Add clk_prepare/unprepare support

Thomas Gleixner (1):
       clockevents: Sanitize ticks to nsec conversion

Uwe Kleine-König (1):
       ARM: at91: rm9200: switch back to clockevents_config_and_register

  arch/arm/mach-at91/at91rm9200_time.c |    7 ++-----
  drivers/clocksource/sh_mtu2.c        |   16 ++++++++++++++--
  drivers/clocksource/sh_tmu.c         |   20 +++++++++++++++++---
  3 files changed, 33 insertions(+), 10 deletions(-)

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

