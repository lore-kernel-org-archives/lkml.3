Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691Ab3AYGr6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 01:47:58 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:39596 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139Ab3AYGrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 01:47:55 -0500
Date: Fri, 25 Jan 2013 12:16:29 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Anton Arapov <anton@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        Josh Stone <jistone@redhat.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suzuki Poulose <suzuki@in.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [GIT PULL] uprobes: pre-filtering
Message-ID: <20130125064629.GD23723@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20130113185916.GA25831@redhat.com>
 <20130124121720.GA3104@gmail.com>
 <20130124154018.GA8580@redhat.com>
 <20130124154159.GB32071@gmail.com>
 <20130124170612.GA14823@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130124170612.GA14823@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012506-9360-0000-0000-00000FAE4B74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2013-01-24 18:06:12]:

> On 01/24, Ingo Molnar wrote:
> >
> > * Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > > Unfortunately, currently there is no in-kernel user of
> > > pre-filtering.
> > >
> > > I'll try to implement the pid-base filtering at least for
> > > tracing/uprobe_events, but this needs a time. Not only I am
> > > not familiar with this code, I am not sure how this interface
> > > should actually look. And I agree, perf should be able to use
> > > it somehow, perhaps at least to allow to probe a single
> > > task/mm.
> >
> > Would be nice to get something minimal/simple going, so that it
> > can be tested, etc.
> 
> Heh, I understand.
> 
> I do not see anything simple to implement... I'll try to think.
> Srikar, do you have any idea?
> 
> All I can say right now: I'll send you the patches when I have them ;)
> Can't promise this will be soon.
> 
> _Perhaps_, as a first step, we can simply change create_trace_uprobe()
> so that it would be possible to specify list-of-pids at creation time...
> Not sure this actually makes sense.
> 

[ Adding Masami and Steven since they have other ideas / inputs ]

I can see two not-so-easy alternatives

Reuse the event's post filtering meta data and convert it to a
prefiltering handler. Convertion looks very tricky 

probe_event_enable() seems to be the right place to do this.
tu->call.filter would have the post filtering data
utc->filter needs to be set to the pre-filtering handler.

The other alternative is to extend the current abi and pass the
prefilter option. Should we extend the abi for userspace tracing is
obviously debatable.

> Oleg.
> 

-- 
Thanks and Regards
Srikar Dronamraju

