Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab3KLPT6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 10:19:58 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33772 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab3KLPTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 10:19:55 -0500
Date: Tue, 12 Nov 2013 16:19:44 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, jolsa@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 4/5] perf record: mmap output file - v5
Message-ID: <20131112151944.GX5056@laptop.programming.kicks-ass.net>
References: <1384267617-3446-1-git-send-email-dsahern@gmail.com>
 <1384267617-3446-5-git-send-email-dsahern@gmail.com>
 <20131112145707.GV5056@laptop.programming.kicks-ass.net>
 <20131112150751.GA19321@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131112150751.GA19321@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 12:07:51PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Nov 12, 2013 at 03:57:07PM +0100, Peter Zijlstra escreveu:
> > On Tue, Nov 12, 2013 at 07:46:56AM -0700, David Ahern wrote:
> > > When recording raw_syscalls for the entire system, e.g.,
> > >     perf record -e raw_syscalls:*,sched:sched_switch -a -- sleep 1
> > > 
> > > you end up with a negative feedback loop as perf itself calls write() fairly
> > > often. This patch handles the problem by mmap'ing the file in chunks of 64M at
> > > a time and copies events from the event buffers to the file avoiding write
> > > system calls.
> > 
> > You know this completely fails the moment you trace faults, because
> > every new access to one of those pages (to mark it dirty) will trigger a
> > fault. And we'll take a bunch more faults -- one for each page -- than
> > we ever did write() syscalls.
> 
> So we should provide a neon lettered warning when doing that, no? :-)

Dunno.. it _should_ all work. Try it and see what it does.. Once the
events are bigger than a page things might get 'interesting' though.
