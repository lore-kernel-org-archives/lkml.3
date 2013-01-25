Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab3AYQSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 11:18:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755481Ab3AYQSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 11:18:35 -0500
Date: Fri, 25 Jan 2013 17:17:28 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Anton Arapov <anton@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        Josh Stone <jistone@redhat.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suzuki Poulose <suzuki@in.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [GIT PULL] uprobes: pre-filtering
Message-ID: <20130125161728.GA11630@redhat.com>
References: <20130113185916.GA25831@redhat.com> <20130124121720.GA3104@gmail.com> <20130124154018.GA8580@redhat.com> <20130124154159.GB32071@gmail.com> <20130124170612.GA14823@redhat.com> <20130125064629.GD23723@linux.vnet.ibm.com> <20130125075437.GB21036@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130125075437.GB21036@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25, Ingo Molnar wrote:
>
> * Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:
>
> > The other alternative is to extend the current abi and pass
> > the prefilter option. Should we extend the abi for userspace
> > tracing is obviously debatable.
>
> That's the obvious path to go - why add something to the kernel
> if user-space cannot make use of it?

This is what I am going to (try to) do, but I am not sure if this makes
sense...

For the start, can't we teach 'uprobe_events' file to accept, say,

	'p file:0x1234 pid=1 other-opts'

for the start? This looks simple enough, and I after looked into tools/perf
it seems that perf can be changed too.

What do you think?

Then we can extend 'pid=' option to accept the list of pids, perhaps.

In the long term we probably need uprobes/pid_filter or something like this,
it should allow to add/del pid dynamically. I really do not know.

Oleg.

