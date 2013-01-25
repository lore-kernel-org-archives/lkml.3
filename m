Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107Ab3AYSqJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 13:46:09 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:37847 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729Ab3AYSqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 13:46:07 -0500
Date: Fri, 25 Jan 2013 19:46:02 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Anton Arapov <anton@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        Josh Stone <jistone@redhat.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suzuki Poulose <suzuki@in.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [GIT PULL] uprobes: pre-filtering
Message-ID: <20130125184602.GD31022@gmail.com>
References: <20130113185916.GA25831@redhat.com>
 <20130124121720.GA3104@gmail.com>
 <20130124154018.GA8580@redhat.com>
 <20130124154159.GB32071@gmail.com>
 <20130124170612.GA14823@redhat.com>
 <20130125064629.GD23723@linux.vnet.ibm.com>
 <20130125075437.GB21036@gmail.com>
 <20130125161728.GA11630@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130125161728.GA11630@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

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
> 
> for the start? This looks simple enough, and I after looked 
> into tools/perf it seems that perf can be changed too.
> 
> What do you think?

Sounds sensible and functional to me.

> Then we can extend 'pid=' option to accept the list of pids, 
> perhaps.
> 
> In the long term we probably need uprobes/pid_filter or 
> something like this, it should allow to add/del pid 
> dynamically. I really do not know.

For now removing+adding a new one should be enough to 'change' a 
uprobe, right?

Thanks,

	Ingo
