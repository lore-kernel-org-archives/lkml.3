Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934835Ab3BTTlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 14:41:46 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:36409 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934450Ab3BTTlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 14:41:45 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mats Liljegren <mats.liljegren@enea.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org
Subject: [RFC/PATCH 0/5] context_tracking: prerequisites for ARM support
Date: Wed, 20 Feb 2013 11:41:37 -0800
Message-Id: <1361389302-11968-1-git-send-email-khilman@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic,

Here is a first pass at some changes needed in order to add ARM
support.

I have another series coming that instruments the syscalls, exceptions
etc. on ARM also, but this one is just to get some prerequisites out
for broader discussion.

This series applies on top of your 3.8-rc6-nohz4 branch, and is also available
here: 

git://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux.git wip/arm-nohz/prereq

I'm aware of the >80 column warnings from checkpatch on the atomic64
conversion patch, but wanted to get some feedback on this approach
before fixing all those up.  Maybe some simpler wrappers in
kernel_stat.h would make this a bit cleaner?

Kevin


Kevin Hilman (5):
  context tracking: conditionalize guest support based on CONFIG_KVM
  kernel_cpustat: convert to atomic 64-bit accessors
  virt CPU accounting: Kconfig: drop 64-bit requirment
  cputime: use do_div() for nsec resolution conversion helpers
  ARM: Kconfig: allow virt CPU accounting

 arch/arm/Kconfig                    |  1 +
 fs/proc/stat.c                      | 36 +++++++++++++-------------
 fs/proc/uptime.c                    |  2 +-
 include/asm-generic/cputime_nsecs.h | 51 +++++++++++++++++++++++++++----------
 include/linux/kernel_stat.h         |  2 +-
 init/Kconfig                        |  2 +-
 kernel/context_tracking.c           |  4 +++
 kernel/sched/core.c                 | 10 ++++----
 kernel/sched/cputime.c              | 24 ++++++++---------
 9 files changed, 80 insertions(+), 52 deletions(-)

-- 
1.8.1.2

