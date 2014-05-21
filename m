Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbaEUPGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 11:06:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091AbaEUPGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 11:06:43 -0400
Date: Wed, 21 May 2014 11:06:13 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: peterz@infradead.org
Subject: ye olde task_ctx_sched_out trace.
Message-ID: <20140521150613.GA28702@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, peterz@infradead.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I thought we had this nailed down a while ago, but it still keeps
popping up...

WARNING: CPU: 3 PID: 32310 at kernel/events/core.c:2384 task_ctx_sched_out+0x6b/0x80()
CPU: 3 PID: 32310 Comm: trinity-c185 Not tainted 3.15.0-rc5+ #214
 0000000000000009 000000003d7dfb5c ffff880019671df8 ffffffff9371a1fd
 0000000000000000 ffff880019671e30 ffffffff9306d5dd ffff88024d0d6d48
 ffff88010c4944e8 0000000000000286 ffff880243b82d00 ffff88010c4944e8
Call Trace:
 [<ffffffff9371a1fd>] dump_stack+0x4e/0x7a
 [<ffffffff9306d5dd>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff9306d70a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff931430bb>] task_ctx_sched_out+0x6b/0x80
 [<ffffffff93146138>] perf_event_comm+0xc8/0x220
 [<ffffffff930a19cd>] ? get_parent_ip+0xd/0x50
 [<ffffffff931c025f>] set_task_comm+0x4f/0xc0
 [<ffffffff93085b23>] SyS_prctl+0x1d3/0x480
 [<ffffffff9372cf9f>] tracesys+0xdd/0xe2

There was on perf activity at all going on at the time.
I had told trinity to do -g vm which excludes all non-VM related syscalls.

What is perf_event_comm doing ? Is that storing some state in case
I later decide to run perf ?

	Dave

