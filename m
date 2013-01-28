Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328Ab3A1MV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 07:21:26 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:58350 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab3A1MVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 07:21:22 -0500
Date: Mon, 28 Jan 2013 17:49:43 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Anton Arapov <anton@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        Josh Stone <jistone@redhat.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Suzuki Poulose <suzuki@in.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [GIT PULL] uprobes: pre-filtering
Message-ID: <20130128121943.GD29865@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20130113185916.GA25831@redhat.com>
 <20130124121720.GA3104@gmail.com>
 <20130124154018.GA8580@redhat.com>
 <20130124154159.GB32071@gmail.com>
 <20130124170612.GA14823@redhat.com>
 <20130125064629.GD23723@linux.vnet.ibm.com>
 <20130125075437.GB21036@gmail.com>
 <20130125161728.GA11630@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130125161728.GA11630@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012812-8256-0000-0000-00000600EA12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2013-01-25 17:17:28]:

> On 01/25, Ingo Molnar wrote:
> >
> > * Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:
> >
> > > The other alternative is to extend the current abi and pass
> > > the prefilter option. Should we extend the abi for userspace
> > > tracing is obviously debatable.
> >
> > That's the obvious path to go - why add something to the kernel
> > if user-space cannot make use of it?
> 
> This is what I am going to (try to) do, but I am not sure if this makes
> sense...
> 
> For the start, can't we teach 'uprobe_events' file to accept, say,
> 
> 	'p file:0x1234 pid=1 other-opts'


I think this would be a very good start


The only downside, I see is we would have add and remove to change the
filter. Something like perf record will not be able to dynamically
change the filter parameter.


> 
> for the start? This looks simple enough, and I after looked into tools/perf
> it seems that perf can be changed too.
> 
> What do you think?
> 
> Then we can extend 'pid=' option to accept the list of pids, perhaps.
> 
> In the long term we probably need uprobes/pid_filter or something like this,
> it should allow to add/del pid dynamically. I really do not know.

Yes, I think having a file like uprobes/pid_filter would be able to
dynamically change the filter.  Probably when we code this up should we
make this something more generic otherwise, we might end up with
uid_filter, sid_filter ..

Steven, 
Are you still pursuing multiple ftrace buffers that you proposed at LPC 2012?

In which case, this new filter should also be per buffer.

-- 
Thanks and Regards
Srikar Dronamraju

