Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab3CONGl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:06:41 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52627 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754691Ab3CONGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:06:38 -0400
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Borislav Petkov <bp@suse.de>,
        Robert Richter <rric@kernel.org>
Subject: [RFC PATCH 0/3] Perf persistent events
Date: Fri, 15 Mar 2013 14:06:26 +0100
Message-Id: <1363352789-17991-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Yeah,

here's a refresh of the persistent events deal, accessing those is much
cleaner now. Here's how:

So kernel code initializes and enables the event at its convenience
(during boot, whenever) and userspace goes and says:

	sys_perf_event_open(pattr,...)

with pattr.persistent = 1. Userspace gets the persistent buffer file
descriptor to read from. Without that, we get a normal perf file
descriptor for the duration of the tracing.

This saves all the diddling of trying to hand down file descriptors
through debugfs or whatever. Instead, current perf code simply can use
it.

This is still RFC but things are starting to fall into place slowly. As
always, any and all comments/suggestions are welcome.

Borislav Petkov (3):
  perf: Add persistent events
  perf: Add persistent event facilities
  MCE: Enable persistent event

 arch/x86/kernel/cpu/mcheck/mce.c |  25 +++++++
 include/linux/perf_event.h       |  14 +++-
 include/uapi/linux/perf_event.h  |   3 +-
 kernel/events/Makefile           |   2 +-
 kernel/events/core.c             |  27 +++++---
 kernel/events/internal.h         |   4 ++
 kernel/events/persistent.c       | 141 +++++++++++++++++++++++++++++++++++++++
 7 files changed, 202 insertions(+), 14 deletions(-)
 create mode 100644 kernel/events/persistent.c

-- 
1.8.1.3.535.ga923c31

