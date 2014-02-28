Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbaB1Nw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 08:52:58 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:17023 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751974AbaB1Nw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 08:52:56 -0500
Date: Fri, 28 Feb 2014 08:52:54 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/5] [GIT PULL] x86: Consolidate 32 and 64 bit
 thead_info (again)
Message-ID: <20140228085254.16aefb01@gandalf.local.home>
In-Reply-To: <20140206144127.181568017@goodmis.org>
References: <20140206144127.181568017@goodmis.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Feb 2014 09:41:27 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

HPA, Ping?

-- Steve


> 
> Peter,
> 
> Back in August 2011, I had a pull request to make the irq stack of
> i386 more like the x86_64 code. There seemed to be acceptance back
> then and you said you would even pull it after the merge window.
> But due to your travels it was forgotten (and I forgot about it too).
> 
> http://lkml.kernel.org/r/20110806011102.721109343@goodmis.org
> 
> I stumbled on these changes again and noticed that they were never
> applied so I forward ported them with a few more adjustments.
> 
> Hopefully they are still worth pulling. This time I waited till after
> the merge window to post :-)
> 
> Please pull the latest tip/x86/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/x86/core
> 
> Head SHA1: 3132e107d608f8753240d82d61303c500fd515b4
> 237dfcadc93749ca5cdd2f683f887c3dcf3a0c04
> 
> 
> Steven Rostedt (4):
>       x86: Nuke the supervisor_stack field in i386 thread_info
>       x86: Prepare removal of previous_esp from i386 thread_info structure
>       x86: Keep thread_info on thread stack in x86_32
>       x86: Clean up dumpstack_64.c code
> 
> Steven Rostedt (Red Hat) (1):
>       x86: Nuke GET_THREAD_INFO_WITH_ESP() macro for i386
> 
> ----
>  arch/x86/include/asm/processor.h   |   9 +++
>  arch/x86/include/asm/thread_info.h |  52 ++---------------
>  arch/x86/kernel/cpu/common.c       |   8 +--
>  arch/x86/kernel/dumpstack_32.c     |  44 ++++++++++++--
>  arch/x86/kernel/dumpstack_64.c     | 117 ++++++++++++++++++++++++++-----------
>  arch/x86/kernel/irq_32.c           |  79 ++++++++++++-------------
>  arch/x86/kernel/process_32.c       |   4 ++
>  arch/x86/kernel/ptrace.c           |   8 +--
>  arch/x86/kernel/smpboot.c          |   2 +-
>  9 files changed, 188 insertions(+), 135 deletions(-)

