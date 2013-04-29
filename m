Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab3D2Ap6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 20:45:58 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:46513 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756581Ab3D2Ap5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 20:45:57 -0400
MIME-Version: 1.0
In-Reply-To: <1367037606.7911.66.camel@Wailaba2>
References: <1365184746.874.103.camel@Wailaba2>
	<1365593710.30071.52.camel@laptop>
	<1365608911.707.65.camel@Wailaba2>
	<1365763837.17140.52.camel@laptop>
	<1365782115.17140.68.camel@laptop>
	<CAFTL4hwQ4FZs0VCNXP37f=+DBW7Q2EQc6PW_EtYiVnZCPWN4OQ@mail.gmail.com>
	<CAHGf_=pWPT4XdrJ8ZveL4zJKm1SE0whpL_fMHd5_TokuNQxSJQ@mail.gmail.com>
	<CAHGf_=psD4V-U4FFwAWr4k3ZP6p=GVkNY_0S-Cg06m-=89MM7Q@mail.gmail.com>
	<1366951210.7911.28.camel@Wailaba2>
	<1366957639.7911.42.camel@Wailaba2>
	<517AD0AE.1030404@gmail.com>
	<1367037606.7911.66.camel@Wailaba2>
Date: Mon, 29 Apr 2013 02:45:55 +0200
Message-ID: <CAFTL4hwxW9dGZH0rWOAngpYd1DJMGHAF7002weA4stNv6n4t6Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] process cputimer is moving faster than its
 corresponding clock
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Olivier Langlois <olivier@trillion01.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, schwidefsky@de.ibm.com,
        Steven Rostedt <rostedt@goodmis.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/27 Olivier Langlois <olivier@trillion01.com>:
>
>
> Forbids the cputimer to drift ahead of its process clock by
> blocking its update when a tick occurs while a autoreaping task
> is currently in do_exit() between the call to release_task() and
> its final call to schedule().
>
> Any task stats update after having called release_task() will
> be lost because they are added to the global process stats located
> in the signal struct from release_task().
>
> Ideally, you should postpone the release_task() call after the
> final context switch to get all the stats added but this is
> more complex to achieve.
>
> In other words, this is slowing down the cputimer so it keep the same
> pace than the process clock but in fact, what should be done is to
> speed up the process clock by adding the missing stats to it.
>
> Signed-off-by: Olivier Langlois <olivier@trillion01.com>

Thanks.

Could you please resend these three patches in a new mail thread to
make reviews easier? Also it would be nice to propose a different
subject for each individual patch. Each of which describing what the
patch does in a few words.

Thanks.
