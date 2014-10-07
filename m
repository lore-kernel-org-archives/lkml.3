Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743AbaJGXZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:25:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39877 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932401AbaJGXUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:20:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.10 00/13] 3.10.57-stable review
Date: Tue,  7 Oct 2014 16:20:05 -0700
Message-Id: <20141007231919.924479934@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
User-Agent: quilt/0.63-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.57 release.
There are 13 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Oct  9 23:19:13 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.57-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.57-rc1

Stratos Karafotis <stratosk@semaphore.gr>
    cpufreq: ondemand: Change the calculation of target frequency

Andreas Schwab <schwab@linux-m68k.org>
    cpufreq: Fix wrong time unit conversion

Johannes Berg <johannes.berg@intel.com>
    nl80211: clear skb cb before passing to netlink

Lars Ellenberg <lars.ellenberg@linbit.com>
    drbd: fix regression 'out of mem, failed to invoke fence-peer helper'

Andrew Hunter <ahh@google.com>
    jiffies: Fix timeval conversion to jiffies

NeilBrown <neilb@suse.de>
    md/raid5: disable 'DISCARD' by default due to safety concerns.

Hans Verkuil <hans.verkuil@cisco.com>
    media: vb2: fix VBI/poll regression

Mel Gorman <mgorman@suse.de>
    mm: numa: Do not mark PTEs pte_numa when splitting huge pages

Waiman Long <Waiman.Long@hp.com>
    mm, thp: move invariant bug check out of loop in __split_huge_page_map

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    ring-buffer: Fix infinite spin in reading buffer

Josh Triplett <josh@joshtriplett.org>
    init/Kconfig: Fix HAVE_FUTEX_CMPXCHG to not break up the EXPERT menu

Peter Zijlstra <peterz@infradead.org>
    perf: fix perf bug in fork()

Jan Kara <jack@suse.cz>
    udf: Avoid infinite loop when processing indirect ICBs


-------------

Diffstat:

 Makefile                                 |  4 +--
 drivers/block/drbd/drbd_nl.c             |  6 ++++
 drivers/cpufreq/cpufreq_governor.c       | 10 +-----
 drivers/cpufreq/cpufreq_governor.h       |  1 -
 drivers/cpufreq/cpufreq_ondemand.c       | 39 +++++------------------
 drivers/cpufreq/cpufreq_stats.c          |  2 +-
 drivers/md/raid5.c                       | 18 ++++++++++-
 drivers/media/v4l2-core/videobuf2-core.c | 15 +++++++--
 fs/udf/inode.c                           | 35 ++++++++++++---------
 include/linux/jiffies.h                  | 12 -------
 include/media/videobuf2-core.h           |  4 +++
 init/Kconfig                             |  1 +
 kernel/events/core.c                     |  4 ++-
 kernel/fork.c                            |  5 +--
 kernel/time.c                            | 54 ++++++++++++++++++--------------
 kernel/trace/ring_buffer.c               |  2 +-
 mm/huge_memory.c                         | 11 ++++---
 net/wireless/nl80211.c                   |  6 ++++
 18 files changed, 123 insertions(+), 106 deletions(-)


