Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbaJIPWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 11:22:14 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:21183 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752628AbaJIPWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 11:22:00 -0400
Date: Thu, 9 Oct 2014 11:21:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH ftrace/for-next v5 0/5] ftrace, kprobes: Introduce
 IPMODIFY flag for ftrace_ops to detect conflicts
Message-ID: <20141009112157.17a52571@gandalf.local.home>
In-Reply-To: <20141009130059.4698.21616.stgit@kbuild-f20.novalocal>
References: <20141009130059.4698.21616.stgit@kbuild-f20.novalocal>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Oct 2014 13:00:59 +0000
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> Hi,
> 
> Here is the 5th version of the series of patches which introduces
> IPMODIFY flag for ftrace_ops to detect conflicts of ftrace users
> who can modify regs->ip in their handler.
> 
> The previous version is here;
>  https://lkml.org/lkml/2014/7/28/13
> 
> This version is basically an update of previous version to the
> latest ftrace tree, and adding a test code to selftest.
> 
> Currently, only kprobes can change the regs->ip in the handler,
> but recently kpatch is also want to change it. Moreover, since
> the ftrace itself exported to modules, it might be considerable
> senario.
> 
> Here we talked on github.
>  https://github.com/dynup/kpatch/issues/47
> 
> To protect modified regs-ip from each other, this series
> introduces FTRACE_OPS_FL_IPMODIFY flag and ftrace now ensures
> the flag can be set on each function entry location. If there
> is someone who already reserve regs->ip on target function
> entry, ftrace_set_filter_ip or register_ftrace_function will
> return -EBUSY. Users must handle that.
> The ftrace_ops with IPMODIFY flag requires at least one
> entry for filter hash, and its notrace_hash must be empty,
> because the IPMODIFY action is very address sensitve and
> user must consider the ip address.
> 
> The 3rd patch adds a special reservation of IPMODIFY on the
> jprobed address, since it is the only user who will change
> the regs->ip. Other kprobes do not change it anymore. 
> 
> Thank you,
> 

Masami,

Thanks for sending this. I'm going to look at it after Dusseldorf. It's
too late to get it into 3.18, but it looks like a good fit for the work
I have for 3.19.

Just don't let me forget you sent this :-)  Even though I tagged it as
important, I'm sure I'll be tagging a lot of other emails as important
in the next week.

Also, my main test box has finally died. I ordered a new motherboard
(thanks Linus for the suggestion!) and unfortunately it is due to
arrive tomorrow. That's the same day I leave and I don't trust my wife
to install it for me ;-)

This means I can not do my tests that I like to run before adding to
linux-next.

-- Steve
