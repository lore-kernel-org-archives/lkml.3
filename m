Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320Ab3AYNoo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 08:44:44 -0500
Received: from smtp0.epfl.ch ([128.178.224.218]:49731 "HELO smtp0.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756394Ab3AYNom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 08:44:42 -0500
From: Florian Vaussard <florian.vaussard@epfl.ch>
To: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Thierry Reding <thierry.reding@avionic-design.de>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Florian Vaussard <florian.vaussard@epfl.ch>
Subject: [PATCH v2 0/3] leds-pwm: Defer PWM calls if PWM can sleep
Date: Fri, 25 Jan 2013 14:44:28 +0100
Message-Id: <1359121471-21457-1-git-send-email-florian.vaussard@epfl.ch>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

When using the leds-pwm module with external PWM chips connected through
I2C, the kernel will panic when settings a trigger. In this case, PWM
calls can sleep, and should be deferred.

Patch 1 and 2 add the necessary API to the PWM subsystem, and update
matching drivers. Patch 3 updates leds-pwm to use a worker if the PWM
chip can sleep, or performs direct calls otherwise.

This patchset is based on the for-next branch of the led subsystem [1],
as patch 3 depends on the recent work of Peter for DT bindings in leds-pwm.
The pwm patches should probably follow the same path.

Tested on Overo (OMAP3 + TWL4030) with device tree.

Best regards,

Florian

[1] git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds.git


Changes from v1:
* pwm_can_sleep -> pwm_cansleep
* avoid duplicated code between the worker and the direct call
* cache the value of pwm_cansleep inside leds-pwm to avoid API calls


Florian Vaussard (3):
  pwm: Add pwm_cansleep() as exported API to users
  pwm: Add can_sleep property to drivers
  leds: leds-pwm: Defer led_pwm_set() if PWM can sleep

 drivers/leds/leds-pwm.c   |   50 +++++++++++++++++++++++++++++++++++++-------
 drivers/pwm/core.c        |   12 ++++++++++
 drivers/pwm/pwm-twl-led.c |    1 +
 drivers/pwm/pwm-twl.c     |    1 +
 include/linux/pwm.h       |   10 +++++++++
 5 files changed, 66 insertions(+), 8 deletions(-)

-- 
1.7.5.4

