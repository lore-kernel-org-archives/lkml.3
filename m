Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab3AXPmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 10:42:06 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:37535 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab3AXPmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 10:42:04 -0500
Date: Thu, 24 Jan 2013 16:41:59 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Arapov <anton@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, Josh Stone <jistone@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] uprobes: pre-filtering
Message-ID: <20130124154159.GB32071@gmail.com>
References: <20130113185916.GA25831@redhat.com>
 <20130124121720.GA3104@gmail.com>
 <20130124154018.GA8580@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130124154018.GA8580@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> On 01/24, Ingo Molnar wrote:
> >
> > * Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > > Ingo, please pull from
> > >
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc uprobes/core
> > >
> > > Mostly pre-filtering. This needs more work and perhaps more functionality.
> > > In particular, perhaps dup_mmap() should remove the unwanted breakpoints.
> > > And we can add more ->filter() hooks to, say, speedup uprobe_register().
> > > Plus we can do some optimizations to avoid register_for_each_vma() in
> > > case when we know that all mm's were previously acked/nacked.
> >
> > The kernel side looks good to me - but how does 'perf 
> > uprobe' make use of it in practice, how can I test it?
> 
> Unfortunately, currently there is no in-kernel user of 
> pre-filtering.
> 
> I'll try to implement the pid-base filtering at least for 
> tracing/uprobe_events, but this needs a time. Not only I am 
> not familiar with this code, I am not sure how this interface 
> should actually look. And I agree, perf should be able to use 
> it somehow, perhaps at least to allow to probe a single 
> task/mm.

Would be nice to get something minimal/simple going, so that it 
can be tested, etc.

Thanks,

	Ingo
