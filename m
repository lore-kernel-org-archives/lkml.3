Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbaCMQyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 12:54:14 -0400
Received: from mail.efficios.com ([78.47.125.74]:56553 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238AbaCMQyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 12:54:12 -0400
Date: Thu, 13 Mar 2014 16:54:16 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Berg <johannes.berg@intel.com>
Message-ID: <1670411611.2880.1394729656679.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140313163531.GD14899@redhat.com>
References: <1394727048-11204-1-git-send-email-mathieu.desnoyers@efficios.com> <20140313163531.GD14899@redhat.com>
Subject: Re: [RFC PATCH v2] Tracepoint: register/unregister struct
 tracepoint
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF27 (Linux)/8.0.5_GA_5839)
Thread-Topic: Tracepoint: register/unregister struct tracepoint
Thread-Index: xVU1L//+Qjhh8RXmx1D+BWKpBpnXqg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Frank Ch. Eigler" <fche@redhat.com>
> To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Cc: "Steven Rostedt" <rostedt@goodmis.org>, linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@kernel.org>, "Frederic
> Weisbecker" <fweisbec@gmail.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Johannes Berg"
> <johannes.berg@intel.com>
> Sent: Thursday, March 13, 2014 12:35:31 PM
> Subject: Re: [RFC PATCH v2] Tracepoint: register/unregister struct tracepoint
> 
> Hi -
> 
> On Thu, Mar 13, 2014 at 12:10:48PM -0400, Mathieu Desnoyers wrote:
> 
> > [...]  Moreover, tracers are responsible for unregistering the probe
> > before the module containing its associated tracepoint is unloaded.
> 
> Could you spell out please how a tracer is supposed to know early
> enough that the module is going to be unloaded?

There are two ways this can be done.

One use-case is when the probe and the callsite are within the same module,
or if the module containing the probe has a symbol dependency on the callsite.
In this case the probe normally unregisters itself from a module exit function
before the module unloads.

The other use-case is if the tracer has a module coming/going notifier
tracking the module's tracepoint callsites. The going notifier should
be run before the tracepoint.c going notifier. A notifier with negative
priority should have this effect, since the tracepoint.c notifier has
priority 0.

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
