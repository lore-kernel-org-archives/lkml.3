Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbbABR3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 12:29:41 -0500
Received: from mail.efficios.com ([78.47.125.74]:37990 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbbABR3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 12:29:39 -0500
Date: Fri, 2 Jan 2015 17:29:42 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Jiang Liu <jiang.liu@linux.intel.com>, x86@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Marc Zyngier <marc.zyngier@arm.com>, Yinghai Lu <yinghai@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Message-ID: <1726066336.34008.1420219782109.JavaMail.zimbra@efficios.com>
In-Reply-To: <20141215105201.16110c6d@gandalf.local.home>
References: <alpine.DEB.2.11.1412121539300.16494@nanos> <20141215105201.16110c6d@gandalf.local.home>
Subject: Re: Status of tip/x86/apic
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [24.114.83.58]
X-Mailer: Zimbra 8.0.7_GA_6021 (ZimbraWebClient - FF34 (Linux)/8.0.7_GA_6021)
Thread-Topic: Status of tip/x86/apic
Thread-Index: O7U+aKygdqAhSZE9iELrnjVJ/Vi2gA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Steven Rostedt" <rostedt@goodmis.org>
> To: "Thomas Gleixner" <tglx@linutronix.de>
> Cc: "LKML" <linux-kernel@vger.kernel.org>, "Jiang Liu" <jiang.liu@linux.intel.com>, x86@kernel.org, "Linus Torvalds"
> <torvalds@linux-foundation.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Bjorn Helgaas" <bhelgaas@google.com>,
> "Tony Luck" <tony.luck@intel.com>, "Borislav Petkov" <bp@alien8.de>, "Joerg Roedel" <joro@8bytes.org>, "Marc
> Zyngier" <marc.zyngier@arm.com>, "Yinghai Lu" <yinghai@kernel.org>, "Alex Williamson" <alex.williamson@redhat.com>,
> "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, "Frederic Weisbecker" <fweisbec@gmail.com>
> Sent: Monday, December 15, 2014 10:52:01 AM
> Subject: Re: Status of tip/x86/apic
> 
[...]
> >       
> >       I think the above can be solved, so we need to agree on a proper
> >       set of tracepoints. I came up with the following list:
> > 
> >       - trace_irqdomain_create(domain->id, domain->name, ...)
> 
> Is that suppose to be a variable number of args? Tracepoints do not
> support a variable length number of args passed in. I guess we could
> add that, but it wont be for this merge window.
> 
> I've added Mathieu and Frederic to the Cc list here.

Hi Steven,

Let's wait and see if it's really required first.

FWIW, at the user-space level in LTTng-UST, we have two distinct ways to
do static instrumentation:

  * tracepoint(): similar to those within the Linux kernel, except that the
                  tracepoint is wrapped in a define, so rather than calling:
                    trace_foo(arg1, arg2);
                  users call:
                    tracepoint(foo, arg1, arg2);

                  Which allows skipping over evaluation of "arg1" and "arg2"
                  even if they have side-effects when the tracepoint is disabled.

  * tracef(): I also added a "tracef()" macro, provides a programmer interface
              very similar to printf(), but prints the pretty-printed into the
              trace buffers. It can be enabled dynamically similarly to tracepoints,
              but does not have per-site event names attached. They are either all
              enabled or disabled, and meant mainly for adding temporary debugging
              trace statements.

So far, the feedback I got from end users seemed to split static
instrumentation use-cases in two major categories:

1) Instrumentation added into the code base, well structured (tracepoints),
   meant to be deployed with the application for in-production use.
   They need to be low-overhead,
2) Very quick (and dirty) instrumentation, meant for one-off use while
   in development. IOW, a replacement to printf(), with which people are
   already familiar. Low-overhead still matters, but not as much as it does
   for (1).

This is why we only implemented var arg support in tracef() so far.

> 
> If we do support this (and if it is needed) we could make it use the
> bprintf() infrastructure. It already supports just saving a format and
> args directly to the the buffer, and a way to print them again.

Happy new year :)

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
