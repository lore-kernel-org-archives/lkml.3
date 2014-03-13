Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbaCMAtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 20:49:12 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:26832 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751574AbaCMAtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 20:49:11 -0400
Date: Wed, 12 Mar 2014 20:49:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        lttng-dev <lttng-dev@lists.lttng.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [for-next][PATCH 08/20] tracing: Warn if a tracepoint is not
 set via debugfs
Message-ID: <20140312204907.6b8d402c@gandalf.local.home>
In-Reply-To: <1177120325.1928.1394653861180.JavaMail.zimbra@efficios.com>
References: <20140307150920.881849073@goodmis.org>
	<20140312114611.43547df7@gandalf.local.home>
	<437054772.1403.1394640336308.JavaMail.zimbra@efficios.com>
	<20140312121813.1e0102aa@gandalf.local.home>
	<285520930.1511.1394642395537.JavaMail.zimbra@efficios.com>
	<20140312135059.2d497b58@gandalf.local.home>
	<1906756968.1732.1394650035535.JavaMail.zimbra@efficios.com>
	<20140312145802.4819511e@gandalf.local.home>
	<1177120325.1928.1394653861180.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2014 19:51:01 +0000 (UTC)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> This only leaves tracepoints in header files and the impact of LTO as
> requirements for having tracepoint callsites with the same name across
> modules.

The only thing that needs to be unique is the struct tracepoint
__tracepoint_##name. There should not be any duplicates of those. I
can't see how the LTO would duplicate a data structure without screwing
everything (not just tracepoints) up.

We can still have more than one trace_##name() called, as that is
handled by the static key.

Note, I'm scrambling to get ready for my trip tomorrow. Thus, I'm not
as much at the computer. I may work on some patches in my 6 hour
layover though.

-- Steve
