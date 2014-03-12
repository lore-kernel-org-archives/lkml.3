Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbaCLUrF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 16:47:05 -0400
Received: from mail.efficios.com ([78.47.125.74]:52105 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbaCLUrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 16:47:03 -0400
Date: Wed, 12 Mar 2014 20:47:07 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, "Frank Ch. Eigler" <fche@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        lttng-dev <lttng-dev@lists.lttng.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Message-ID: <1083852821.1959.1394657227042.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140312203515.GV22728@two.firstfloor.org>
References: <20140307150920.881849073@goodmis.org> <20140312121813.1e0102aa@gandalf.local.home> <285520930.1511.1394642395537.JavaMail.zimbra@efficios.com> <20140312135059.2d497b58@gandalf.local.home> <1906756968.1732.1394650035535.JavaMail.zimbra@efficios.com> <20140312145802.4819511e@gandalf.local.home> <1177120325.1928.1394653861180.JavaMail.zimbra@efficios.com> <20140312203515.GV22728@two.firstfloor.org>
Subject: Re: [for-next][PATCH 08/20] tracing: Warn if a tracepoint is not
 set via debugfs
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF27 (Linux)/8.0.5_GA_5839)
Thread-Topic: tracing: Warn if a tracepoint is not set via debugfs
Thread-Index: 8+P3sr6LattmxFBzMLo0iZvUjD1Ojw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Andi Kleen" <andi@firstfloor.org>
> To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Cc: "Steven Rostedt" <rostedt@goodmis.org>, "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org, "Ingo
> Molnar" <mingo@kernel.org>, "Frederic Weisbecker" <fweisbec@gmail.com>, "Andrew Morton" <akpm@linux-foundation.org>,
> "Johannes Berg" <johannes.berg@intel.com>, "Linus Torvalds" <torvalds@linux-foundation.org>, "Peter Zijlstra"
> <peterz@infradead.org>, "Thomas Gleixner" <tglx@linutronix.de>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
> "lttng-dev" <lttng-dev@lists.lttng.org>, "Rusty Russell" <rusty@rustcorp.com.au>, "Andi Kleen" <andi@firstfloor.org>
> Sent: Wednesday, March 12, 2014 4:35:15 PM
> Subject: Re: [for-next][PATCH 08/20] tracing: Warn if a tracepoint is not set via debugfs
> 
> > So I understand that you wish to banish tracepoints from static inline
> > functions within headers to ensure they only appear within a single module.
> > This seems to be a step backward, but let's assume we stick to that rule.
> > Then how do you envision dealing with Link-Time Optimisations (LTO) ?
> 
> I assume it uses the file name defines set by Kbuild?

Just to make sure I understand your question: I understand that you are asking
whether tracepoints use file name defines at all in the naming of a tracepoint.
The answer to this question is: No, they do not.

> These don't change with
> LTO. It's whatever was specified at compile time. Also LTO doesn't
> inline over module boundaries (if the module is not built in)

Good to know. Can it inline core kernel functions into a module ?

Thanks,

Mathieu

> 
> -Andi
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
