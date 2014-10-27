Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbaJ0R7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 13:59:36 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:44979 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752006AbaJ0R6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 13:58:47 -0400
Message-Id: <20141027175606.622391559@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 27 Oct 2014 13:56:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/2] [GIT PULL] ftrace: Fix trampoline accounting
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Adding the new code for 3.19, I discovered a couple of minor bugs with
the accounting of the ftrace_ops trampoline logic. One was that the
old hash was not updated before calling the modify code for an ftrace_ops.
The second bug was what let the first bug go unnoticed, as the update would
check the current hash for all ftrace_ops (where it should only check the
old hash for modified ones). This let things work when only one ftrace_ops
was registered to a function, but could break if more than one was
registered depending on the order of the look ups.

The worse thing that can happen if this bug triggers is that the ftrace
self checks would find an anomaly and shut itself down.

*NOTE* My old subkey just expired. I created a new subkey: 8A87D95D
It may take a while before the key servers sync up.

Please pull the latest trace-fixes-v3.18-rc1 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-fixes-v3.18-rc1

Tag SHA1: fc028ab0bb793e19e6cd87b3348ce681f6e06d70
Head SHA1: 4fc409048d5afb1ad853f294b4262ecf2c980a49


Steven Rostedt (Red Hat) (2):
      ftrace: Set ops->old_hash on modifying what an ops hooks to
      ftrace: Fix checking of trampoline ftrace_ops in finding trampoline

----
 kernel/trace/ftrace.c | 54 +++++++++++++++++++++++++++++++++++----------------
 1 file changed, 37 insertions(+), 17 deletions(-)
