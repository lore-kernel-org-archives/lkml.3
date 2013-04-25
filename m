Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297Ab3DYUbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 16:31:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:45958 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758773Ab3DYUbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 16:31:44 -0400
Message-Id: <20130425142452.908423538@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 25 Apr 2013 20:31:42 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 00/15] clocksource/events: Overhaul (un)registration
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clocksource_unregister() interface is broken. A clocksource can be
removed unconditionally even if there is no fallback clocksource
available. clocksources in a module can be removed as well. Aside of
that the registration part lacks a few sanity checks as well.

The clockevents layer does not allow unregistration, but for
reconfigurable hardware this is a must have feature.

The following patch series fixes the clocksource part and adds
unregister support for clockevent devices.

Thanks,

	tglx
---
 drivers/clocksource/dw_apb_timer.c |   12 -
 include/linux/clockchips.h         |    4 
 include/linux/clocksource.h        |    7 
 include/linux/dw_apb_timer.h       |    1 
 kernel/time/clockevents.c          |  271 ++++++++++++++++++++++++++++++++-----
 kernel/time/clocksource.c          |  190 +++++++++++++++++++------
 kernel/time/tick-broadcast.c       |   33 +++-
 kernel/time/tick-common.c          |  189 +++++++++----------------
 kernel/time/tick-internal.h        |   17 +-
 kernel/time/timekeeping.c          |   20 +-
 10 files changed, 514 insertions(+), 230 deletions(-)


