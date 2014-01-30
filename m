Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbaA3Nzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 08:55:36 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:62853 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752921AbaA3Nzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 08:55:35 -0500
Date: Thu, 30 Jan 2014 08:55:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: FTRACE_WARN_ON((rec->flags & ~FTRACE_FL_MASK) == 0))
Message-ID: <20140130085533.5436dc2a@gandalf.local.home>
In-Reply-To: <20140130053232.GA14856@redhat.com>
References: <20140130041622.GA23875@redhat.com>
	<cbf0c86a-317e-451f-9bb4-48c582ab4e1e@email.android.com>
	<20140130053232.GA14856@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jan 2014 00:32:32 -0500
Dave Jones <davej@redhat.com> wrote:

> On Wed, Jan 29, 2014 at 11:50:43PM -0500, Steven Rostedt wrote:
>  > Are you running as root?  If not, you found another way to get perf to start function tracing.
> 
> Good point. In this case, I was trying some new experimental trinity code
> that starts as root, generates fd's, then drops privs before doing syscalls.
> 
> So the "generate fds" part did some perf_event_open's as root, yeah.
> 
> While that's less scary from a security pov than it was last time, it's still
> something that aparently needs fixing.
> 

OK, then I'm not as worried (phew!). But you are correct, this needs to
be fixed. How do I run just perf commands from trinity? I do not think
this occurs from any other systemcall needing to be run.

Peter, Jiri,

Although we fixed the bug that let a normal user enable function
tracing from perf, we never figured out why perf screws up the function
tracing filter accounting. That will happen if you either use a
uninitialized ftrace hash, or modify the hash without using the ftrace
API. If it is the latter, it is probably done by some kind of use after
free.

-- Steve
