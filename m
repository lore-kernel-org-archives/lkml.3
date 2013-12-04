Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab3LDCjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 21:39:11 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:7092 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754638Ab3LDCjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 21:39:08 -0500
Date: Tue, 3 Dec 2013 21:39:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Sasha Levin <sasha.levin@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v4 6/6] [RFC] kprobes/x86: Call exception handlers
 directly from do_int3/do_debug
Message-ID: <20131203213904.5ff1794c@gandalf.local.home>
In-Reply-To: <20131204012856.22118.91079.stgit@kbuild-fedora.novalocal>
References: <20131204012841.22118.82992.stgit@kbuild-fedora.novalocal>
	<20131204012856.22118.91079.stgit@kbuild-fedora.novalocal>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Dec 2013 01:28:56 +0000
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> To avoid a kernel crash by probing on lockdep code, call
> kprobe_int3_handler and kprobe_debug_handler directly
> from do_int3 and do_debug. Since there is a locking code
> in notify_die, lockdep code can be invoked. And because
> the lockdep involves printk() related things, theoretically,
> we need to prohibit probing on much more code...
> 
> Anyway, most of the int3 handlers in the kernel are already
> called from do_int3 directly, e.g. ftrace_int3_handler,
> poke_int3_handler, kgdb_ll_trap. Actually only
> kprobe_exceptions_notify is on the notifier_call_chain.
> 
> So I think this is not a crazy thing.

What? Oh, yeah. No, using notifiers in int3 handler is the crazy
thing ;-)

Hmm, if there's no users of the int3 notifier, should we just remove it?

-- Steve
