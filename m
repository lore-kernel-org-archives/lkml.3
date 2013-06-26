Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891Ab3FZN3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 09:29:36 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:48104 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab3FZN3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 09:29:34 -0400
Date: Wed, 26 Jun 2013 15:29:30 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 0/8] perf: add ability to sample physical data addresses
Message-ID: <20130626132930.GA6319@gmail.com>
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

Btw., as a related matter, it would be nice to add an ioctl() that would 
trigger a regular MMAP event for all current vmas.

PERF_EVENT_IOC_DUMP_MMAPS or so?

This would be easier to process than the somewhat fragile parsing 
/proc/*/maps text files, and it would more consistently fit into the perf 
tracing model.

I suspect it would/could also be less racy than /proc/*/maps, which is 
restart based due to the 4K procfs limit, while the ioctl() could dump 
everything into the trace buffer, as long as the buffer is large enough.

Thanks,

	Ingo
