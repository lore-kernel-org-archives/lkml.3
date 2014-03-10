Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbaCJRYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 13:24:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:4013 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754335AbaCJRYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 13:24:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,625,1389772800"; 
   d="scan'208";a="469695446"
Date: Mon, 10 Mar 2014 10:24:40 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v1 03/11] perf: Allow for multiple ring buffers per event
Message-ID: <20140310172440.GG13302@tassilo.jf.intel.com>
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1391683834-29868-4-git-send-email-alexander.shishkin@linux.intel.com>
 <20140217143340.GR27965@twins.programming.kicks-ass.net>
 <530529FC.6080704@intel.com>
 <87siqqtlv6.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87siqqtlv6.fsf@ashishki-desk.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Wouldn't we have to teach a ton of code how to be IRQ safe for this to
> > work?  Just step one: how do we go modifying page tables safely from an
> > interrupt?  mm->page_table_lock is a plain non-irq spinlock.
> 
> Yes, this does look more than just tricky even if we move the bulk of
> interrupt code to an irq_work. Peter, are you quite sure this is what we
> want to do just for exporting trace buffers to userspace?

The other big problem is scalability. Even if it was somehow possible
to make this scheme work the IPIs for flushing would kill performance 
on any multi threaded client.  Given perf is not multi-threaded today, but
it doesn't seem a good idea to design the interface assuming no client ever
will be.

-Andi
