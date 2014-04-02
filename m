Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717AbaDBRaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 13:30:15 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:9901 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758822AbaDBRaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 13:30:09 -0400
Message-Id: <20140402172639.994587272@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 02 Apr 2014 13:26:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/2] x86: Fix perf deadlock caused by dumpstack cleanup
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Here are two patches that fix the deadlock that you discovered.

The first patch is the real culprit, but as I was looking at the code
I realized that the irq stack part was a bit off too. That part didn't
cause the lock up, but needs to be fixed regardless.

Note, I'm hoping to use these clean ups to make x86_64 and i386 code
a bit closer to each other, so I hope the original change does not
get reverted.

-- Steve



Steven Rostedt (Red Hat) (2):
      x86: Fix dumpstack_64 to keep state of "used" variable in loop
      x86: Fix dumpstack_64 irq stack handling

----
 arch/x86/kernel/dumpstack_64.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)
