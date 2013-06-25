Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab3FYKrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 06:47:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45028 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab3FYKrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 06:47:16 -0400
Date: Tue, 25 Jun 2013 12:47:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 0/8] perf: add ability to sample physical data addresses
Message-ID: <20130625104700.GZ28407@twins.programming.kicks-ass.net>
References: <1371824448-7306-1-git-send-email-eranian@google.com>
 <20130624084338.GI28407@twins.programming.kicks-ass.net>
 <CABPqkBRqiNVZnioV_R4sfam1QwHwXZgo36Gixxg5ALPbLbiXfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBRqiNVZnioV_R4sfam1QwHwXZgo36Gixxg5ALPbLbiXfw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 11:59:09AM +0200, Stephane Eranian wrote:
> One guarantee we have is that the physical does correspond to the virtual
> address at the time of the interrupt.

That might not be much of a guarantee depending on the circumstances.

> But yeah, if physical pages are swapped during the run, then things become
> a lot more complicated. I am not trying to address this.
> 
> Can page move for shared memory segments?

Yep..

> > Such would completely shatter physical page relations.
> >
> > If the shared memory thing is really the issue, doesn't perf already
> > have the process memory layout (/proc/$PID/maps and aux stream mmap
> > updates) with which it can compute map relative offsets and compare
> > thusly?
> 
> Not sure I understand this.
> suppose the same shared memory segment is mapped at two different
> addresses by shmat(). First, I don't know if those show up in /proc/maps.

They should; IIRC maps is a full vma list.. /me prods about in
fs/proc/task_mmu.c.. yes it prints all vmas.

> Second, what offset are you talking about here?

The offset to the start of the vma, this should be the same for both
maps, irrespective of where they're mapped.

You could then match shared memory segments on inode:offset.
