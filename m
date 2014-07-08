Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbaGHOYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 10:24:20 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:53306 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750927AbaGHOYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 10:24:19 -0400
Date: Tue, 8 Jul 2014 10:24:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Oleg Nesterov <oleg@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Seth Jennings <sjenning@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC][PATCH 0/3] ftrace: Add dynamically allocated trampolines
Message-ID: <20140708102416.50d996e2@gandalf.local.home>
In-Reply-To: <alpine.LNX.2.00.1407071520370.1655@pobox.suse.cz>
References: <20140703200750.648550267@goodmis.org>
	<53B6AA0C.2080704@hitachi.com>
	<20140704102142.7d276e4b@gandalf.local.home>
	<alpine.LNX.2.00.1407071520370.1655@pobox.suse.cz>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jul 2014 15:22:27 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:

> On Fri, 4 Jul 2014, Steven Rostedt wrote:
> 
> > Well, I guess the answer to that is what do you consider the trampoline? 
> > I'm currently considering it to be the assembly code that the 
> > mcount/fentry call jumps to. We only have two trampolines (three if you 
> > count the function graph code that will be called directly come 3.17). 
> > Those two are the normal ftrace_caller and the ftrace_regs_caller. 
> 
> BTW, on those archs that support regs saving already, is there really a 
> reson not to kill ftrace_caller and keep just ftrace_regs_caller?
> 

Consistency. Perhaps the two can be the same trampoline, which would be
trivial to implement, but I wouldn't kill one which would make the
generic code more complex.

-- Steve
