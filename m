Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbaKGUOO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 15:14:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbaKGUON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 15:14:13 -0500
Date: Fri, 7 Nov 2014 21:14:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aaron Tomlin <atomlin@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] proc: deuglify task_state()
Message-ID: <20141107201424.GA22209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I tried to optimize the usage of tasklist_lock in exit_notify() paths
but found the bug which should be fixed first: the EXIT_DEAD setting
in reparent_leader() can break the task_ppid_nr_ns()-like code and
ptrace_parent().

I am still thinking about the "right" fix, but whatever we do we need
to cleanup these users, probably before the fix.

One particular user is task_state(), but it also asks for other off-
topic cleanups which I believe make sense anyway, lets do this first.

Oleg.

 fs/proc/array.c |   47 ++++++++++++++++++++++-------------------------
 1 files changed, 22 insertions(+), 25 deletions(-)

