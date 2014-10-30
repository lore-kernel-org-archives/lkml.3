Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161375AbaJ3W20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 18:28:26 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41214 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161293AbaJ3W2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 18:28:25 -0400
Date: Thu, 30 Oct 2014 23:28:14 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Matt Fleming <matt@console-pimps.org>,
        Vince Weaver <vince@deater.net>, Andy Lutomirski <luto@amacapital.net>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [RFD] perf syscall error handling
Message-ID: <20141030222814.GF15602@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Earlier today I was reminded that perf syscall error handling sucks arse
-- albeit not in those words.

Now I know we've had this discussion before, but nothing really
happened. I think back then the suggestion was having the kernel write a
string back or somesuch.

The problem with a string is, its hard for machines to interpret, its
English, so near impossible for some humans too.

So would something simple, like an offset into the struct
perf_event_attr pointing at the current field we're trying to process
make sense? Maybe with negative offsets to indicate the syscall
arguments?

That would narrow down the 'WTF is wrong noaw' a lot I think. But then,
I've not actually done a lot of userspace the last few years, so maybe
I'm just dreaming things.

Anybody?

