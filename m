Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbaCMSSF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 14:18:05 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:63329 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754719AbaCMSSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 14:18:03 -0400
Message-ID: <1394734673.26600.10.camel@pippen.local.home>
Subject: Re: [RFC PATCH v2] Tracepoint: register/unregister struct tracepoint
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Berg <johannes.berg@intel.com>
Date: Thu, 13 Mar 2014 14:17:53 -0400
In-Reply-To: <1670411611.2880.1394729656679.JavaMail.zimbra@efficios.com>
References: <1394727048-11204-1-git-send-email-mathieu.desnoyers@efficios.com>
	 <20140313163531.GD14899@redhat.com>
	 <1670411611.2880.1394729656679.JavaMail.zimbra@efficios.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-13 at 16:54 +0000, Mathieu Desnoyers wrote:

> The other use-case is if the tracer has a module coming/going notifier
> tracking the module's tracepoint callsites. The going notifier should
> be run before the tracepoint.c going notifier. A notifier with negative
> priority should have this effect, since the tracepoint.c notifier has
> priority 0.
> 

The tracepoint should change to have two different notifiers that
represent one for coming and one for going (as ftrace does). The coming
one should have a priority of 0 (or INT_MIN (all other notifiers
dependent on this should have > 0)

The going notifier should have a INT_MAX to run after all other
tracepoint notifiers. (see kernel/trace/ftrace.c ftrace_module_enter_nb
and ftrace_module_exit_nb)

-- Steve


