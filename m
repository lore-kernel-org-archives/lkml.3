Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbaCMSWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 14:22:48 -0400
Received: from mail.efficios.com ([78.47.125.74]:56871 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754510AbaCMSWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 14:22:47 -0400
Date: Thu, 13 Mar 2014 18:22:52 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Berg <johannes.berg@intel.com>
Message-ID: <1510944043.2892.1394734972867.JavaMail.zimbra@efficios.com>
In-Reply-To: <1394734673.26600.10.camel@pippen.local.home>
References: <1394727048-11204-1-git-send-email-mathieu.desnoyers@efficios.com> <20140313163531.GD14899@redhat.com> <1670411611.2880.1394729656679.JavaMail.zimbra@efficios.com> <1394734673.26600.10.camel@pippen.local.home>
Subject: Re: [RFC PATCH v2] Tracepoint: register/unregister struct
 tracepoint
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF27 (Linux)/8.0.5_GA_5839)
Thread-Topic: Tracepoint: register/unregister struct tracepoint
Thread-Index: J0T2oz3AHbi0g6b/alnAYFbwYQZToA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Steven Rostedt" <rostedt@goodmis.org>
> To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@kernel.org>, "Frederic
> Weisbecker" <fweisbec@gmail.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Johannes Berg"
> <johannes.berg@intel.com>
> Sent: Thursday, March 13, 2014 2:17:53 PM
> Subject: Re: [RFC PATCH v2] Tracepoint: register/unregister struct tracepoint
> 
> On Thu, 2014-03-13 at 16:54 +0000, Mathieu Desnoyers wrote:
> 
> > The other use-case is if the tracer has a module coming/going notifier
> > tracking the module's tracepoint callsites. The going notifier should
> > be run before the tracepoint.c going notifier. A notifier with negative
> > priority should have this effect, since the tracepoint.c notifier has
> > priority 0.
> > 
> 
> The tracepoint should change to have two different notifiers that
> represent one for coming and one for going (as ftrace does). The coming
> one should have a priority of 0 (or INT_MIN (all other notifiers
> dependent on this should have > 0)
> 
> The going notifier should have a INT_MAX to run after all other
> tracepoint notifiers. (see kernel/trace/ftrace.c ftrace_module_enter_nb
> and ftrace_module_exit_nb)

OK, I'll spin a v4 with this change.

Thanks!

Mathieu

> 
> -- Steve
> 
> 
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
