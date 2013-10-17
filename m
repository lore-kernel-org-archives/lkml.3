Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904Ab3JQQil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 12:38:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58564 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757857Ab3JQQij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 12:38:39 -0400
Date: Thu, 17 Oct 2013 18:38:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] (Was: perf_event_mmap(vma) && !vma->vm_mm)
Message-ID: <20131017163828.GU10651@twins.programming.kicks-ass.net>
References: <20131012192203.GA21738@redhat.com>
 <20131014102426.GX3081@twins.programming.kicks-ass.net>
 <20131016200924.GA23214@redhat.com>
 <20131016202822.GI2675@laptop.programming.kicks-ass.net>
 <20131016204348.GA25121@redhat.com>
 <20131016205807.GG10651@twins.programming.kicks-ass.net>
 <20131016205800.GB26066@redhat.com>
 <20131016211613.GJ10651@twins.programming.kicks-ass.net>
 <20131017152027.GA14098@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131017152027.GA14098@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 05:20:27PM +0200, Oleg Nesterov wrote:
> On 10/16, Peter Zijlstra wrote:
> >
> > On Wed, Oct 16, 2013 at 10:58:00PM +0200, Oleg Nesterov wrote:
> > > OK. I'll wait for your review on this series, then send the next patch.
> > >
> >
> > Those two patches look good; thanks.
> 
> Thanks, can I have your acks for Ingo ?

Oh, I queued them :-)

> Yes, this is almost what I meant, but:
> 
> 	- name is "const char *", we need another variable

I cased that away ;-)

> 	- we do not really need "len", we can simply do
> 
> 		size = strlen(name) + 1;
> 		while (size % sizeof(u64))
> 			name[size++] = '\0';
> 
> 	  although I won't argue if you dislike "size & 7" in while().

Cute..

> 	- we can factor out strncpy(tmp, name).
> 
> Could you look at 3/2 I'll send in a minute?

I'll got have a look :-)
