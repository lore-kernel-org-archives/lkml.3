Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbaDDDk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 23:40:28 -0400
Received: from mail.efficios.com ([78.47.125.74]:60229 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbaDDDkW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 23:40:22 -0400
Date: Fri, 4 Apr 2014 03:40:17 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>
Message-ID: <1275825820.6059.1396582817493.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140403145441.2ca44063@gandalf.local.home>
References: <1396391508-17294-1-git-send-email-mathieu.desnoyers@efficios.com> <1396391508-17294-2-git-send-email-mathieu.desnoyers@efficios.com> <20140403131559.4ed4cf5e@gandalf.local.home> <693620685.5916.1396547394009.JavaMail.zimbra@efficios.com> <20140403145441.2ca44063@gandalf.local.home>
Subject: Re: [PATCH v9 1/1] Tracepoint: register/unregister struct
 tracepoint
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF28 (Linux)/8.0.5_GA_5839)
Thread-Topic: Tracepoint: register/unregister struct tracepoint
Thread-Index: lDWcRFrlJOXKJY02xngFA1W8YXr6cg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Steven Rostedt" <rostedt@goodmis.org>
> To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@kernel.org>, "Frederic Weisbecker" <fweisbec@gmail.com>,
> "Andrew Morton" <akpm@linux-foundation.org>, "Frank Ch. Eigler" <fche@redhat.com>, "Johannes Berg"
> <johannes.berg@intel.com>
> Sent: Thursday, April 3, 2014 2:54:41 PM
> Subject: Re: [PATCH v9 1/1] Tracepoint: register/unregister struct tracepoint
> 
> On Thu, 3 Apr 2014 17:49:54 +0000 (UTC)
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> 
> > So my current thinking is that the pre-existing code was erroneously
> > enabling tracepoints with the name of every event enabled (including
> > e.g. function tracer, kprobes, etc). It was not failing because
> > tracepoint.c silently accepted to enable tracepoints were not loaded
> > yet.
> > 
> 
> If that was true, than wouldn't the error code I added have returned an
> error?

Good point.

I found the culprit:

[    0.560002] event_trace_enable: �GT����� call ffffffff81613930 (core)                                                                                                      
[    0.564001] event_trace_enable: �GTȁ���� call ffffffff816139c0 (core) 

compudj@ok:~/git/rostedt/linux-trace$ objdump -t vmlinux |grep ffffffff81613930
ffffffff81613930 l     O .data	0000000000000090 event_sys_exit
compudj@ok:~/git/rostedt/linux-trace$ objdump -t vmlinux |grep ffffffff816139c0
ffffffff816139c0 l     O .data	0000000000000090 event_sys_enter

I'll look into those two sites tomorrow morning.

Thanks,

Mathieu

> 
> -- Steve
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
