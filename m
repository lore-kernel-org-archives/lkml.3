Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbaDXMWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:22:18 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:63783 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753175AbaDXMWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:22:15 -0400
Date: Thu, 24 Apr 2014 08:21:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: ftrace/kprobes: Warning when insmod two modules
Message-ID: <20140424082149.71b09e0f@gandalf.local.home>
In-Reply-To: <87k3afdvn3.fsf@rustcorp.com.au>
References: <1395637826-3312-1-git-send-email-indou.takao@jp.fujitsu.com>
	<5330164D.6030507@hitachi.com>
	<20140324105939.7f823b81@gandalf.local.home>
	<87bnvunhs9.fsf@rustcorp.com.au>
	<20140422094103.39488700@gandalf.local.home>
	<87k3afdvn3.fsf@rustcorp.com.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2014 17:08:56 +0930
Rusty Russell <rusty@rustcorp.com.au> wrote:

> OTOH, if it's just ftrace (do tracepoints have an issue?) I'd rather
> hardcode a ftrace_init_module() call in exactly the right place.
> Notifiers which are sensitive to their exact call location tend give me
> the creeps...

I think I like this solution the best. I believe it was the original
solution for ftrace until we realized that it can be also done by a
notifier.

It also makes it more in line with what the core kernel does, as I
considered notifiers similar to initcalls and the init code for ftrace
is hard coded in init/main.c and not done by initcalls, as it is
important to be done before anything else.

Yeah, a ftrace_init_module() hard coded in where the module state is
still MODULE_STATE_UNFORMED, would work.

-- Steve
