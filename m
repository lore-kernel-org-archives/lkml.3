Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab3KUN2q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 08:28:46 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:22924 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751491Ab3KUN2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 08:28:44 -0500
Date: Thu, 21 Nov 2013 08:28:41 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 15/22] tools lib traceevent: Change pevent_parse_event
 to return event format
Message-ID: <20131121082841.5b709947@gandalf.local.home>
In-Reply-To: <1385031680-9014-16-git-send-email-jolsa@redhat.com>
References: <1385031680-9014-1-git-send-email-jolsa@redhat.com>
	<1385031680-9014-16-git-send-email-jolsa@redhat.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Nov 2013 12:01:13 +0100
Jiri Olsa <jolsa@redhat.com> wrote:

> Changing pevent_parse_event to return 'struct event_format',
> for the parsed event if the return pointer is specified.

Can we not change the API of pevent_parse_event(), I use it quite a bit.

And yes, I'm working hard to keep what's in trace-cmd and the kernel
identical.

> 
> This way we can remove pevent_parse_format which does the
> same stuff just without 'struct pevent' object.

Actually, I don't use pevent_parse_format() at all. What about changing
that one to include the pevent?


> 
> The ultimate goal is to always use pevent object when dealing
> with traceevent library. The reason is that we might need
> additional processing (like plugins), which is not possible
> otherwise.

Right, so add a pevent to the pevent_parse_format() and leave the
pevent_parse_event() alone. That should make everyone happy :-)

Thanks!

-- Steve
