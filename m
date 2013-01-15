Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab3AOVqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 16:46:16 -0500
Received: from relay2.sgi.com ([192.48.179.30]:42279 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754012Ab3AOVqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 16:46:14 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        johnstul@us.ibm.com
Cc: linux-kernel@vger.kernel.org, Nathan Zimmer <nzimmer@sgi.com>
Subject: [PATCH RESEND 0/4] /proc/schedstat and /proc/sched_debug fail at 4096 
Date: Tue, 15 Jan 2013 15:46:08 -0600
Message-Id: <1358286372-13777-1-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running with 4096 cores attemping to read /proc/schedstat,
/proc/sched_debug, /proc/timer_list will fail with an ENOMEM condition.
On a sufficantly large systems the total amount of data is more then 4mb, so
it won't fit into a single buffer.  The failure can also occur on smaller
systems when memory fragmentation is high as reported by Dave Jones.
Also thanks to Al Viro for pointing me in the right direction with the
iterator.

An solution considered but not tried for sched_stat and scheddebug would to be
create an alternative mechanism to single_open but rather then calling *_show
once it calls show once per possible cpu.  If someone feels strongly that is
the way to go I can give it a spin.

Nathan Zimmer (4):
  sched: /proc/sched_stat fails on very very large machines.
  sched: /proc/sched_debug fails on very very large machines.
  timer_list: split timer_list_show_tickdevices
  timer_list: Convert timer list to be a proper seq_file.

 kernel/sched/debug.c     |   84 +++++++++++++++++++++++++++++++++-----
 kernel/sched/stats.c     |   73 ++++++++++++++++++++++++---------
 kernel/time/timer_list.c |  100 +++++++++++++++++++++++++++++++++++++---------
 3 files changed, 207 insertions(+), 50 deletions(-)

