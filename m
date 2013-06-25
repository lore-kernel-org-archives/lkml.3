Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab3FYKvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 06:51:32 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:37800 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab3FYKv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 06:51:28 -0400
Date: Tue, 25 Jun 2013 12:51:23 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 0/8] perf: add ability to sample physical data addresses
Message-ID: <20130625105123.GA13649@gmail.com>
References: <1371824448-7306-1-git-send-email-eranian@google.com>
 <20130624084338.GI28407@twins.programming.kicks-ass.net>
 <CABPqkBRqiNVZnioV_R4sfam1QwHwXZgo36Gixxg5ALPbLbiXfw@mail.gmail.com>
 <20130625104700.GZ28407@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130625104700.GZ28407@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, Jun 25, 2013 at 11:59:09AM +0200, Stephane Eranian wrote:
> > One guarantee we have is that the physical does correspond to the virtual
> > address at the time of the interrupt.
> 
> That might not be much of a guarantee depending on the circumstances.
> 
> > But yeah, if physical pages are swapped during the run, then things become
> > a lot more complicated. I am not trying to address this.
> > 
> > Can page move for shared memory segments?
> 
> Yep..
> 
> > > Such would completely shatter physical page relations.
> > >
> > > If the shared memory thing is really the issue, doesn't perf already
> > > have the process memory layout (/proc/$PID/maps and aux stream mmap
> > > updates) with which it can compute map relative offsets and compare
> > > thusly?
> > 
> > Not sure I understand this.
> > suppose the same shared memory segment is mapped at two different
> > addresses by shmat(). First, I don't know if those show up in /proc/maps.
> 
> They should; IIRC maps is a full vma list.. /me prods about in
> fs/proc/task_mmu.c.. yes it prints all vmas.

A syscall (ioctl?) to dump all current vmas into the mmap update stream 
(to form a starting point) might be handy - that would remove the 
fragility and overhead of parsing /proc/ details.

Thanks,

	Ingo
