Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121AbaEHWh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 18:37:56 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:23142 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755669AbaEHWhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 18:37:55 -0400
Date: Thu, 8 May 2014 18:37:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [RFC PATCH] ftrace/x86: Move the mcount/fentry code out of
 entry_64.S
Message-ID: <20140508183752.19e99780@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.02.1405090019510.6261@ionos.tec.linutronix.de>
References: <20140508152152.2130e8cf@gandalf.local.home>
	<alpine.DEB.2.02.1405090019510.6261@ionos.tec.linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 May 2014 00:21:37 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Thu, 8 May 2014, Steven Rostedt wrote:
> 

> I'm fine with the code move per se. That's a good thing.

Great, then I'll add this to my 3.16 queue.

Can I get your Acked-by for it?

> 
> The live patcher argumentation for it is more than questionable.

Well, that was the final motivator. But I've been wanting to optimize
the function tracing a bit since it's been getting more and more users.
Namely, kprobes and perf. As such, I've been thinking about creating
custom trampolines (like what kprobes does today) where if there's two
or more users of ftrace, but they are using different functions, they
don't need to go through a loop, but instead have their own trampoline
that calls their function directly and is called by the functions they
trace.

Right now I'm working on getting the function graph tracer trampoline
(which is static) called directly if function graph is enabled.
Currently, we save regs for function tracing, restore them, and then
call function graph tracing. This is a big waste when function graph is
running by itself.

-- Steve
