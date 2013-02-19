Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526Ab3BSGZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 01:25:35 -0500
Received: from miso.sublimeip.com ([203.12.5.51]:57764 "EHLO
	miso.sublimeip.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab3BSGZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 01:25:33 -0500
Subject: Re: prctl(PR_SET_MM)
To: rostedt@goodmis.org (Steven Rostedt)
Date: Tue, 19 Feb 2013 17:25:31 +1100 (EST)
Cc: u3557@dialix.com.au, oleg@redhat.com (Oleg Nesterov),
        palves@redhat.com (Pedro Alves), dvlasenk@redhat.com (Denys Vlasenko),
        jan.kratochvil@redhat.com (Jan Kratochvil),
        gorcunov@openvz.org (Cyrill Gorcunov),
        xemul@parallels.com (Pavel Emelyanov),
        fweisbec@gmail.com (Frederic Weisbecker),
        mingo@redhat.com (Ingo Molnar),
        a.p.zijlstra@chello.nl (Peter Zijlstra), linux-kernel@vger.kernel.org
Reply-To: u3557@dialix.com.au
In-Reply-To: <1361216963.23152.168.camel@gandalf.local.home>
X-Mailer: ELM [version 2.5 PL8]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20130219062531.4F317592076@miso.sublimeip.com>
From: u3557@miso.sublimeip.com (Amnon Shiloh)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:

> If only you, or a few people are using it (ie. distros don't see a
> need), then it will be up to you to make the changes.

I believe that this functionality is of a general nature and is needed
by many, not only by myself and by the CRIU group, but by all user-level
software packages, past present and future, that provide some form or
another of reconstructing a Linux process.

For example:
1) Checkpoint-restore
   - the ability to resume a computation after computer crashes.
2) Process-migration
   - the ability to have a running computation change computers.
     (for numerous reasons, including planned shutdown; overheating;
     load-balancing; increased memory demands; the original computer
     being required by higher-priority users, etc. etc.)
3) Process-duplication
   - the ability to have a running computation continue in parallel from
     a point in time on two or more computers, so that if one of them
     fails, at least one copy will still be running (in time-critical
     missions, a periodic checkpointing may not be sufficient).

To reconstruct Linux process(es), one must be able to restore all their
memory contents, states and registers to their original and consistent
values.    

Other than the code currently enclosed in "CONFIG_CHECKPOINT_RESTORE",
nothing else in the kernel provides the ability to set those 11 fields:

     start_code, end_code, start_data, end_data, start_brk, brk,
     start_stack, arg_start, arg_end, env_start, env_end.

There are many possible ways to implement this functionality and if you
believe that it would be a good idea, I could instead send a simple,
independent kernel patch that sets those 11 fields.  It would be shorter
than the current and perhaps implemented as a new "ptrace" function,
but given that the CRIU group already wrote this code and that it is
already in the kernel, I am concerned that trying to duplicate it might
interfere with their work, so I first ask for the relevant code in
"kernel/sys.c" to no longer be enclosed by an #ifdef.  What do you think?

Best Regards,
Amnon.
