Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923AbaCMDKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 23:10:54 -0400
Received: from mail.efficios.com ([78.47.125.74]:53404 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568AbaCMDKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 23:10:53 -0400
Date: Thu, 13 Mar 2014 03:10:53 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
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
Message-ID: <209084517.2310.1394680253793.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140312204907.6b8d402c@gandalf.local.home>
References: <20140307150920.881849073@goodmis.org> <20140312121813.1e0102aa@gandalf.local.home> <285520930.1511.1394642395537.JavaMail.zimbra@efficios.com> <20140312135059.2d497b58@gandalf.local.home> <1906756968.1732.1394650035535.JavaMail.zimbra@efficios.com> <20140312145802.4819511e@gandalf.local.home> <1177120325.1928.1394653861180.JavaMail.zimbra@efficios.com> <20140312204907.6b8d402c@gandalf.local.home>
Subject: Re: [for-next][PATCH 08/20] tracing: Warn if a tracepoint is not
 set via debugfs
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF27 (Linux)/8.0.5_GA_5839)
Thread-Topic: tracing: Warn if a tracepoint is not set via debugfs
Thread-Index: ZO6W9Q/mPv73L7DJARa/wrrhGftR/g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Steven Rostedt" <rostedt@goodmis.org>
> To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@kernel.org>, "Frederic
> Weisbecker" <fweisbec@gmail.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Johannes Berg"
> <johannes.berg@intel.com>, "Linus Torvalds" <torvalds@linux-foundation.org>, "Peter Zijlstra"
> <peterz@infradead.org>, "Thomas Gleixner" <tglx@linutronix.de>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
> "lttng-dev" <lttng-dev@lists.lttng.org>, "Rusty Russell" <rusty@rustcorp.com.au>, "Andi Kleen" <andi@firstfloor.org>
> Sent: Wednesday, March 12, 2014 8:49:07 PM
> Subject: Re: [for-next][PATCH 08/20] tracing: Warn if a tracepoint is not set via debugfs
> 
> On Wed, 12 Mar 2014 19:51:01 +0000 (UTC)
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> > This only leaves tracepoints in header files and the impact of LTO as
> > requirements for having tracepoint callsites with the same name across
> > modules.
> 
> The only thing that needs to be unique is the struct tracepoint
> __tracepoint_##name. There should not be any duplicates of those. I
> can't see how the LTO would duplicate a data structure without screwing
> everything (not just tracepoints) up.
> 
> We can still have more than one trace_##name() called, as that is
> handled by the static key.

Hrm, I seem to have mixed up the concerns regarding compiler
optimisations between the static keys with those related to tracepoints
(including that their predecessors "kernel markers" worked more like
static keys than tracepoint). I did work in both area pretty much at the
same time back in 2007-2008.

Having gotten my head back up straight, I now see the point in your
proposal. Thanks for bearing with me.

Even if we ever want to have tracepoints within header files, as long
as we have the DECLARE_TRACE() within the header, and a DEFINE_TRACE()
in one location in the loaded kernel image (or a loaded module we depend
on), it should be possible too. All tracepoint.c cares about is the site
defined by DEFINE_TRACE().

> 
> Note, I'm scrambling to get ready for my trip tomorrow. Thus, I'm not
> as much at the computer. I may work on some patches in my 6 hour
> layover though.

Allright. Have a good trip!

Thanks,

Mathieu

> 
> -- Steve
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
