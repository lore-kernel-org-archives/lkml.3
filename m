Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab3F1T4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:56:36 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:33706 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab3F1T4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 15:56:31 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCHv2 0/8] clocksource: sunxi: Timer fixes and cleanup
Date: Fri, 28 Jun 2013 21:56:18 +0200
Message-Id: <1372449386-1334-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

The first timer code we merged when adding support for the A13 some
time back was mostly a clean up from the source drop we had, without
any documentation.  This happened to work, but the code merged in
turned out to be far from perfect, and had several flaws.

This patchset hopefully fixes these flaws, and cleanup most of the
driver as well, to end up in an almost complete rewrite of it (even
though it's not that long).

It also finally adds a clocksource from the free running counter found
in the A10/A13 SoCs.

These flaws have all been spotted when trying to add the A31 support,
work that is still ongoing, but will hopefully benefit from this
patchset as well.

Thanks,
Maxime

Changes from v1:
  - Rebased on top of linux-next to benefit from the move to all
    architectures of the sched_clock functions
  - Moved the clock source to the second timer instead of the 64 bits
    free-running counter like suggested by Thomas.

Maxime Ripard (8):
  clocksource: sun4i: Use the BIT macros where possible
  clocksource: sun4i: Add clocksource and sched clock drivers
  clocksource: sun4i: Don't forget to enable the clock we use
  clocksource: sun4i: Fix the next event code
  clocksource: sun4i: Factor out some timer code
  clocksource: sun4i: Remove TIMER_SCAL variable
  clocksource: sun4i: Cleanup parent clock setup
  clocksource: sun4i: Fix bug when switching from periodic to oneshot
    modes

 drivers/clocksource/sun4i_timer.c | 97 ++++++++++++++++++++++++++-------------
 1 file changed, 64 insertions(+), 33 deletions(-)

-- 
1.8.3.1

